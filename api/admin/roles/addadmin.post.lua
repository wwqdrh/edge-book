-- description=新增管理员账号
-- request=[
--   {"name": "json@phone", "type": "string", "required": true}
-- ]
-- middlewares=jwt_admin

local phone = ctx.req("phone")
local res = state.orm()
    .table({"admins"})
    .first_or_create({
        {"phone=?", phone},
        {phone=phone,role=1}
    })
    .exec("base")

if res.err ~= nil then
    ctx.json(400, {msg="用户创建失败"})
    return
elseif #res.res == 0 then
    ctx.json(400, {msg="用户创建失败"})
    return
end

ctx.json(200, {
    msg="用户创建成功"
})