-- description=取消房间订单
-- request=[
--   {"name": "json@orderid", "type": "int", "required": true}
-- ]
-- middlewares=jwt

local userInfo = ctx.middleware("jwt", "info").user
local userId = userInfo.id

local res = state.orm()
    .table({"orders"})
    .where({
        "id = ? AND userid = ?", ctx.req("orderid"), userId 
    })
    .updates({
        {status=4,cancel_at="[[datetime]]NOW"}
    })
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="订单取消失败"})
    return
end

-- 微信支付系统取消订单
res, err = pay.wechat_jsapi_close({
    out_trade_no=ctx.req("orderid")
})
if err ~= nil then
    ctx.json(500, {err=err})
    return
end

ctx.json(200, {
    msg="订单取消成功"
})