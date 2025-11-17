-- description=获取用户订单列表
-- request=[
--   {"name": "query@status", "type": "int", "required": true}
-- ]
-- middlewares=jwt

local userInfo = ctx.middleware("jwt", "info").user

local query_str = "orders.userid = ? AND orders.deleted_at IS NULL "
local query_arg = {userInfo.id}

if ctx.reqhas("status") then
    query_str = query_str .. " AND orders.status = ? "
    table.insert(query_arg, ctx.req("status"))
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
    .where({query_str, query_arg})
    .find({})
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="用户订单查询失败"})
    return
end

ctx.json(200, {
    data=res.res
})