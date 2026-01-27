-- description=将用户修改为管理员权限，role为1
-- request=[
--   {"name": "json@phone", "type": "string", "required": true}
-- ]
-- middlewares=jwt@match,role,2

local phone = ctx.req("phone")
local res = state.orm()
    .table({"users"})
    .first_or_create({
        {"phone=?", phone},
        {name="user"..phone, phone=phone,role=1}
    })
    .exec("base")

if res.err ~= nil or next(res.res) == nil then
    ctx.json(400, {msg="用户创建失败"})
    return
end

ctx.json(200, {
    msg="用户创建成功",
    data={
        id=res.res.id
    }
})