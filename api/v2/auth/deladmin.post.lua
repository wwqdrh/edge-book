-- description=将用户修改为普通权限，role为0
-- request=[
--   {"name": "json@phone", "type": "string", "required": true}
-- ]
-- middlewares=jwt@match,role,2

local res = state.orm()
    .table({"users"})
    .where({
        "phone = ?", ctx.req("phone")
    })
    .updates({
        {role=0}
    })
    .exec("base")

if res.err ~= nil then
    ctx.json(400, {msg="权限改为普通用户失败"})
    return
end

ctx.json(200, {
    msg="权限已改为普通用户"
})
