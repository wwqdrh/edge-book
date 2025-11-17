-- description=新增管理员账号
-- request=[
--   {"name": "json@id", "type": "int", "required": true}
-- ]
-- middlewares=jwt_admin@match,role,2|10

local res = state.orm()
    .table({"admins"})
    .delete({"id=?", ctx.req("id")})
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="管理员删除失败"})
    return
end

ctx.json(200, {
    msg="管理员删除成功"
})