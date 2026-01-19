-- request=[
--   {"name": "json@phone", "type": "string", "required": true},
--   {"name": "json@password", "type": "string", "required": true}
-- ]
-- description=使用手机号直接进行登录而不是在微信小程序环境中，方便进行接口测试

local user_phone = ctx.req("phone")
local user_data = state.orm()
    .table({"users"})
    .where({
        "phone = ?", user_phone
    })
    .find({})
    .exec("base", false)
if user_data.err ~= nil then
    ctx.json(400, {msg="用户登录失败"})
    return
end

local user = user_data.res[1]
local tokenData, err = ctx.middleware("jwt", "token", {
    user={
        id=user.id,
        username=user.name,
        isadmin=false,
        phone=user.phone
    }
})

ctx.json(200, {
    msg="登录成功",
    accessToken=tokenData.token,
    refreshToken=tokenData.refreshToken,
    idToken=tokenData.token,
    isadmin=false
})
