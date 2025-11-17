-- description=修改管理员信息
-- request=[
--   {"name": "json@id", "type": "int", "required": true},
--   {"name": "json@name", "type": "string", "required": true},
--   {"name": "json@phone", "type": "string", "required": true}
-- ]
-- middlewares=jwt_admin@match,role,2|10

if not ctx.reqhas("id") then
    ctx.json(400, {msg="未传入id参数"})
    return
end

local res = state.orm()
    .table({"admins"})
    .where({
        "id = ?", ctx.req("id")
    })
    .updates({
        {
            name=ctx.req("name"),
            phone=ctx.req("phone")
        }
    })
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="修改管理员信息失败"})
    return
end

ctx.json(200, {
    msg="修改管理员信息成功"
})