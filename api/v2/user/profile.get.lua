-- description=验证码
-- middlewares=jwt

local userInfo = ctx.middleware("jwt", "info").user

ctx.json(200, {
    id=userInfo.id,
    username=userInfo.username,
    isadmin=userInfo.isadmin,
    phone=userInfo.phone,
    role=userInfo.role
})
