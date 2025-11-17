-- request=[
--   {"name": "json@code", "type": "string", "required": true}
-- ]
-- description=小程序组件拿到动态code之后，使用这个code去调用接口获取手机号


token_data, err = funcs.call("get_access_token", {})
if err ~= nil then
    ctx.json(500, {msg="获取access_token失败", desc=err})
    return
end

access_token = json.query(token_data, "access_token")
if access_token == "null" then
    ctx.json(500, {msg="获取access_token失败, access_token为空", detail=json.query(token_data, "err")})
    return
end
print("get access token: " .. access_token)

content, err = osx.fetch("https://api.weixin.qq.com/wxa/business/getuserphonenumber", "post", {
    query={
        access_token=access_token
    },
    json={
        code=ctx.req("code")
    }
})
if err ~= nil then
    ctx.json(500, {err=err})
    return
end

local user_phone = json.query(content, "phone_info.phoneNumber")
if user_phone == "null" then
    ctx.json(500, {msg="获取用户手机号失败，登录失败", detail=content})
    return
end
print("get user phone: " .. user_phone)
local res = state.orm()
    .table({"users"})
    .select({
        "users.*",
        "admins.role role"
    })
    .joins({
        {"LEFT JOIN admins ON users.phone = admins.phone"}
    })
    .first_or_create({
        {"users.phone=?", user_phone},
        {phone=user_phone, name="user"..user_phone}
    })
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="用户登录失败"})
    return
end
print("find user success: " .. json.encode(res.res))
-- 判断是否是管理员，如果是的话那么将管理员的token一起创建了
local isadmin = funcs.call("isadmin", {phone=res.res.phone}) == "true"
local tokenData, err = ctx.middleware("jwt", "token", {
    user={
        id=res.res.id,
        username=res.res.name,
        isadmin=isadmin,
        phone=res.res.phone,
        role=res.res.role
    }
})
if err ~= nil then
    ctx.json(500, {msg="用户登录失败", desc=err})
    return
end
print("create jwt token success")

if isadmin then
    print("is admin")
    local admin_res = funcs.call("gen_admin_token", {phone=res.res.phone})
    ctx.json(200, {
        msg="登录成功",
        accessToken=tokenData.token,
        refreshToken=tokenData.refreshToken,
        idToken=tokenData.token,
        isadmin=true,
        admin=json.decode(admin_res)
    })
else
    print("is not admin")
    ctx.json(200, {
        msg="登录成功",
        accessToken=tokenData.token,
        refreshToken=tokenData.refreshToken,
        idToken=tokenData.token,
        isadmin=false
    })
end
