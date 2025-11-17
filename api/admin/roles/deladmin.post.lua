-- description=删除一个管理员账户
-- request=[
--   {"name": "json@phone", "type": "string", "required": true}
-- ]
-- middlewares=jwt_admin

local phone = ctx.req("phone")
local res = state.orm()
    .table({"admins"})
    .delete({"phone=?", phone})
    .exec("base")

if res.err ~= nil then
    ctx.json(400, {msg="管理员用户删除失败"})
    return
end

ctx.json(200, {
    msg="管理员用户删除成功"
})
