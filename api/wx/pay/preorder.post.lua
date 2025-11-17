-- description=订单预处理，生成id给小程序，由小程序唤起支付组件,参考https://pay.weixin.qq.com/doc/v3/merchant/4012791897
-- request=[
--   {"name": "json@openid", "type": "string", "required": true},
--   {"name": "json@out_trade_no", "type": "string", "required": true}
-- ]
-- middlewares=jwt

-- TODO: 现在支付是一分钱测试，需要根据out_trade_no获取订单原价

local res = state.orm()
    .table({"orders"})
    .first({
        "out_trade_no=?", ctx.req("out_trade_no")
    })
    .find({})
    .exec("base", false)
if res.err ~= nil or next(res.res) == nil then
    ctx.json(400, {msg="订单不存在"})
    return
end

local total_price = res.res.total_price
print(total_price)

res, err = pay.wechat_jsapi_prepay({
    description="支付测试",
    out_trade_no=ctx.req("out_trade_no"),
    time_expire=osx.time_after_seconds(600, "RFC3339"),
    notify_url="https://www.weixin.qq.com/wxpay/pay.php",
    amount=1,
    openid=ctx.req("openid")
})
if err ~= nil then
    ctx.json(500, {err=err})
    return
end
ctx.json(200, {
    data=json.decode(res)
})