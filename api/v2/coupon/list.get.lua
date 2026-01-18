-- description=用户获取自己拥有的优惠券，默认所有，包括可用的以及过期的
-- middlewares=jwt

local userInfo = ctx.middleware("jwt", "info").user

local res = state.orm()
    .table({"coupon_instance"})
    .select({
        "coupon_definition.*",
        "-coupon_definition.created_at",
        "coupon_instance.validaty_times",
        "coupon_instance.validity_period",
        "coupon_instance.created_at"
    })
    .joins({
        {"JOIN coupon_definition ON coupon_instance.coupon_id = coupon_definition.id"}
    })
    .where({"coupon_instance.user_id=? AND coupon_instance.deleted_at IS NULL AND coupon_instance.validaty_times > 0", userInfo.id})
    .find({})
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="优惠券列表查询失败"})
    return
end

ctx.json(200, {
    data=res.res
})