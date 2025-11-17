-- description=获取订单详情信息
-- request=[
--   {"name": "query@id", "type": "int", "required": true}
-- ]
-- middlewares=jwt

local userInfo = ctx.middleware("jwt", "info").user
local res = state.orm()
    .table({"orders"})
    .select({
        "orders.*",
        "rooms.cover_image cover_image",
        "rooms.name room_name",
    })
    .joins({
        {"JOIN rooms ON orders.roomid = rooms.id"}
    })
    .first({"orders.id = ? and orders.userid = ?", ctx.req("id"), userInfo.id})
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="订单信息查询失败"})
    return
end

-- 查询订单时，如果订单是等待支付状态，顺便去看看订单是否支付完成
if res.res.status == 0 then
    pay_status, err = pay.wechat_jsapi_query({
        order_type=2,
        order_no=res.res.out_trade_no
    })
    print(osx.time_after_seconds(0))
    print(res.res.expired_at)
    if pay_status == "支付成功" then
        if funcs.call("payok", {orderid=ctx.req("id"), userid=userInfo.id}) == "true" then
            res.res.status = 1
        end
    elseif osx.time_after_seconds(0) > res.res.expired_at then
        if funcs.call("paycancel", {orderid=ctx.req("id"), userid=userInfo.id}) == "true" then
            res.res.status = 4
        end
    end
end

ctx.json(200, {
    data=res.res
})
