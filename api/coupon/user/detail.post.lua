-- description=获取优惠券详细信息
-- request=[
--   {"name": "json@id", "type": "int"}
-- ]
-- middlewares=jwt

local userInfo = ctx.middleware("jwt", "info").user

local res = state.orm()
    .table({"coupon_definition"})
    .select({
        "coupon_definition.*"
    })
    .joins({
        {"JOIN coupon_instance ON coupon_instance.coupon_id = coupon_definition.id"}
    })
    .first({"coupon_instance.user_id=? AND coupon_definition.id=? AND coupon_instance.deleted_at IS NULL", userInfo.id, ctx.req("id")})
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="优惠券信息查询失败"})
    return
end

ctx.json(200, {
    data=res.res
})
