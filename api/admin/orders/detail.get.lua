-- description=查看订单详细信息
-- request=[
--   {"name": "query@id", "type": "int", "required": true}
-- ]
-- middlewares=jwt_admin@match,role,1|2|10

local res = state.orm()
    .table({"orders"})
    .select({
        "orders.*",
        "rooms.cover_image cover_image",
        "rooms.door_number door_number",
        "rooms.typeid roomtype"
    })
    .joins({
        {"JOIN rooms ON orders.roomid = rooms.id"}
    })
    .first({"orders.id = ?", ctx.req("id")})
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="订单信息查询失败"})
    return
end

ctx.json(200, {
    data=res.res
})
