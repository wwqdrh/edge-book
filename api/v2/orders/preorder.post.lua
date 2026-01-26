-- description=订单预处理，生成id给小程序，由小程序唤起支付组件,参考https://pay.weixin.qq.com/doc/v3/merchant/4012791897
-- request=[
--   {"name": "json@openid", "type": "string", "required": true},
--   {"name": "json@out_trade_no", "type": "string", "required": true}
-- ]
-- middlewares=jwt

local res = state.orm()
    .table({"orders"})
    .first({
        {out_trade_no=ctx.req("out_trade_no")}
    })
    .exec("base", false)

if res.err ~= nil or next(res.res) == nil then
    ctx.json(400, {msg="订单不存在"})
    return
end

local order_data = res.res
local total_price = order_data.night_times * order_data.night_price
if order_data.discount_type == 1 then
    total_price = total_price * order_data.discount_value / 100
elseif order_data.discount_type == 2 then
    total_price = total_price - order_data.discount_value
end

res, err = pay.wechat_jsapi_prepay({
    description="支付测试",
    out_trade_no=ctx.req("out_trade_no"),
    time_expire=osx.time_after_seconds(600, "RFC3339"),
    notify_url="https://www.weixin.qq.com/wxpay/pay.php",
    amount=total_price,
    openid=ctx.req("openid")
})
if err ~= nil then
    ctx.json(500, {err=err})
    return
end

local data = json.decode(res)
data["order_id"] = order_data.id
ctx.json(200, {
    data=data
})