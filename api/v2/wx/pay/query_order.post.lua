-- 检查订单是否支付完成的接口-- description=订单预处理，生成id给小程序，由小程序唤起支付组件,参考https://pay.weixin.qq.com/doc/v3/merchant/4012791897
-- request=[
--   {"name": "json@ordertype", "type": "int", "default": 2},
--   {"name": "json@orderid", "type": "string", "required": true}
-- ]
-- middlewares=jwt

res, err = pay.wechat_jsapi_query({
    order_type=ctx.req("ordertype"),
    order_no=ctx.req("orderid")
})
if err ~= nil then
    ctx.json(500, {err=err})
    return
end
ctx.json(200, {
    data=res
})