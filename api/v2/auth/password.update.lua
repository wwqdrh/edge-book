-- request=[
--   {"name": "json@phone", "type": "string", "required": true},
--   {"name": "json@password", "type": "string", "required": true},
--   {"name": "json@code", "type": "string", "required": true}
-- ]
-- description=修改用户密码，用户密码默认为空，修改后可以使用账号密码进行登录

if ctx.req("code") ~= osx.genv("ACTION_CODE") or os.genv("ACTION_CODE") == "" then
    ctx.json(400, {msg="修改用户密码失败", detail="ACTION_CODE不正确"})
    return
end

local user_data = state.orm()
    .table({"users"})
    .where({
        "phone = ?", ctx.req("phone")
    })
    .updates({
        {password="[[password]]" .. ctx.req("password")}
    })
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="修改用户密码失败", detail=res.err})
    return
end

ctx.json(200, {
    msg="修改用户密码成功"
})