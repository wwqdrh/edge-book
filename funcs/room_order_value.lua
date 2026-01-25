-- name=room_order_value
-- entry=index
-- args=[
-- {"name": "userid", "type": "number"},
-- {"name": "roomid", "type": "number"},
-- {"name": "couponid", "type": "number"},
-- {"name": "start_date", "type": "string"},
-- {"name": "end_date", "type": "string"}
-- ]

function index(userid, roomid, couponid, start_date, end_date)
    local couponinfo = state.orm()
        .table({"coupon_definition"})
        .select({
            "coupon_instance.id",
            "coupon_definition.discount_type",
            "coupon_definition.discount_value"
        })
        .joins({
            {"JOIN coupon_instance ON coupon_instance.coupon_id = coupon_definition.id"}
        })
        .first({"coupon_instance.user_id=? AND coupon_definition.id=? AND coupon_instance.deleted_at IS NULL", userid, couponid})
        .exec("base", false)

    if couponinfo.err ~= nil or next(couponinfo.res) == nil then
        return 0, "优惠券不存在"
    end

    local discount_type = couponinfo.res.discount_type
    local discount_value = couponinfo.res.discount_value


    local night_price, err = funcs.call("night_price", {roomid=ctx.req("roomid")})
    if err ~= nil then
        return 0, "房间价格查询失败"
    end

    local night_times, err = osx.night_times(ctx.req("start_date"), ctx.req("end_date"))
    if err ~= nil then
        return 0, "房间预定天数计算失败"
    end

    return night_times * night_price
end
