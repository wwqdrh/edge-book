-- middlewares=jwt_admin@match,role,1|2|10
-- request=[
--   {"name": "query@status", "type": "int", "default": 0}
-- ]

local whereQuery = ""
local whereArg = {}
if ctx.reqhas("status") then
    whereQuery = "orders.status = ?"
    table.insert(whereArg, ctx.req("status"))
end
local res = state.orm()
    .table({"orders"})
    .select({
        "orders.id id",
        "orders.check_in_date check_in_date",
        "orders.check_out_date check_out_date",
        "orders.total_price total_price",
        "orders.status status",
        "orders.created_at created_at",
        "rooms.cover_image cover_image"
    })
    .joins({
        {"JOIN rooms ON orders.roomid = rooms.id"}
    })
    .where({
        whereQuery, whereArg
    })
    .find({})
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="用户订单查询失败"})
    return
end

ctx.json(200, {
    data=res.res
})