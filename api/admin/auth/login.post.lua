-- request=[
--   {"name": "json@phone", "type": "string", "required": true}
-- ]
-- description=用户使用手机号码登录，如果数据库中不存在，那么新增为普通用户，然后返回登录token，后续使用该token作为是否登录凭证

local user_phone = ctx.req("phone")
local res = state.orm()
    .table({"admins"})
    .select({
        "id", "role"
    })
    .first({
        "phone=?", user_phone,
    })
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="用户登录失败",detail=res.err})
    return
end

local tokenData, err = ctx.middleware("jwt_admin", "token", {
    user={
        id=res.res.id,
        role=res.res.role
    }
})
if err ~= nil then
    ctx.json(500, {msg="用户登录失败", desc=err})
    return
end

ctx.json(200, {
    msg="登录成功",
    data={
        accessToken=tokenData.token,
        refreshToken=tokenData.refreshToken,
        idToken=tokenData.token
    },
    ext={
        role=res.res.role
    }
})
