-- description=删除房源信息
-- request=[
--   {"name": "json@name", "type": "string"}
-- ]
-- middlewares=jwt_admin@match,role,1|2|10

local res = state.orm()
    .table({"room_type"})
    .create({
        {name=ctx.req("name")}
    })
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="房间类型添加失败"})
    return
end

ctx.json(200, {
    msg="房间类型添加成功"
})