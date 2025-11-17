-- description=新增管理员账号
-- request=[
--   {"name": "json@name", "type": "string", "required": true},
--   {"name": "json@phone", "type": "string", "required": true}
-- ]
-- middlewares=jwt_admin@match,role,2|10

local res = state.orm()
    .table({"admins"})
    .create({
        {
            name=ctx.req("name"),
            phone=ctx.req("phone"),
            role=1
        }
    })
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="管理员新增失败"})
    return
end

ctx.json(200, {
    msg="管理员新增成功"
})