-- description=新增普通用户账号
-- request=[
--   {"name": "json@name", "type": "string", "required": true},
--   {"name": "json@phone", "type": "string", "required": true}
-- ]
-- middlewares=jwt_admin@match,role,2|10

local res = state.orm()
    .table({"users"})
    .create({
        {
            name=ctx.req("name"),
            phone=ctx.req("phone")
        }
    })
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="用户新增失败"})
    return
end

ctx.json(200, {
    msg="用户新增成功"
})