-- description=验证码
-- middlewares=jwt_admin

local userInfo = ctx.middleware("jwt_admin", "info")

ctx.json(200, userInfo)
