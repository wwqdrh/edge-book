-- request=[
--   {"name": "json@phone", "type": "string", "required": true},
--   {"name": "json@password", "type": "string", "required": true}
-- ]
-- description=使用手机号直接进行登录而不是在微信小程序环境中，方便进行接口测试

local user_data = state.orm()
    .table({"users"})
    .where({
        "phone = ?", ctx.req("phone")
    })
    .find({})
    .exec("base", false)
if user_data.err ~= nil then
    ctx.json(400, {msg="用户登录失败", detail="用户不存在"})
    return
end

local user = user_data.res[1]
local ok, err = state.password_check(ctx.req("password"), user.password)
if err ~= nil or not ok then
    ctx.json(400, {msg="用户登录失败", detail="密码错误"})
    return
end

local is_admin = user.role ~= 0
local tokenData, err = ctx.middleware("jwt", "token", {
    user={
        id=user.id,
        username=user.name,
        isadmin=is_admin,
        phone=user.phone,
        role=user.role
    }
})
ctx.json(200, {
    msg="登录成功",
    accessToken=tokenData.token,
    refreshToken=tokenData.refreshToken,
    idToken=tokenData.token,
    is_admin=is_admin
})
