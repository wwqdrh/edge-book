-- request=[
--   {"name": "json@phone", "type": "string", "required": true},
--   {"name": "json@password", "type": "string", "required": true},
--   {"name": "json@code", "type": "string", "required": true}
-- ]
-- description=修改用户密码，用户密码默认为空，修改后可以使用账号密码进行登录
-- middlewares=local

local action_code = osx.genv("ACTION_CODE")
if ctx.req("code") ~= action_code or action_code == "" then
    ctx.json(400, {msg="修改用户密码失败", detail="ACTION_CODE不正确"})
    return
end

local passencode = state.password_encode(ctx.req("password"))
local user_data = state.orm()
    .table({"users"})
    .where({
        "phone = ?", ctx.req("phone")
    })
    .updates({
        {password=passencode}
    })
    .exec("base", false)

if user_data.err ~= nil then
    ctx.json(400, {msg="修改用户密码失败", detail=user_data.err})
    return
end

ctx.json(200, {
    msg="修改用户密码成功"
})