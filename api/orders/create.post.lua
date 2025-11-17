-- description=创建房间订单
-- request=[
--   {"name": "json@roomid", "type": "int", "required": true},
--   {"name": "json@check_in_date", "type": "date", "required": true},
--   {"name": "json@check_out_date", "type": "date", "required": true},
--   {"name": "json@guest_name", "type": "string", "required": true},
--   {"name": "json@guest_phone", "type": "string", "required": true},
--   {"name": "json@guest_idcard", "type": "string", "required": true},
--   {"name": "json@guest_desc", "type": "string", "required": true},
--   {"name": "json@couponid", "type": "int"},
--   {"name": "json@night_times", "type": "int", "required": true},
--   {"name": "json@night_price", "type": "int", "required": true},
--   {"name": "json@total_price", "type": "int", "required": true}
-- ]
-- middlewares=jwt

local userInfo = ctx.middleware("jwt", "info").user
local userId = userInfo.id

local canbook, err = funcs.call("checkbook", {
    start_date=ctx.req("start_date"),
    end_date=ctx.req("end_date"),
    roomid=ctx.req("roomid")
})
if err ~= nil or canbook == "false" then
    ctx.json(400, {
        code=40001,
        msg="订单时间冲突，请返回首页选择时间后再来吧"
    })
    return
end

local coupon_id = 0
local discount_type = 0
local discount_value = 0
-- 获取优惠券具体优惠内容
if ctx.reqhas("couponid") then
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
        .first({"coupon_instance.user_id=? AND coupon_definition.id=? AND coupon_instance.deleted_at IS NULL", userId, ctx.req("couponid")})
        .exec("base", false)

    if couponinfo.err ~= nil or next(couponinfo.res) == nil then
        ctx.json(400, {msg="优惠券信息不存在"})
        return
    end

    discount_type = couponinfo.res.discount_type
    discount_value = couponinfo.res.discount_value
    coupon_id = couponinfo.res.id
end

res = state.orm().transaction({
    state.orm().table({"orders"}).create({
        {
            userid=userId,
            roomid=ctx.req("roomid"),
            out_trade_no=mathx.random(32,1),
            discount_type=discount_type,
            discount_value=discount_value,
            check_in_date=ctx.req("check_in_date"),
            check_out_date=ctx.req("check_out_date"),
            guest_name=ctx.req("guest_name"),
            guest_phone=ctx.req("guest_phone"),
            guest_idcard=ctx.req("guest_idcard"),
            guest_desc=ctx.req("guest_desc"),
            night_price=ctx.req("night_price"),
            night_times=ctx.req("night_times"),
            total_price=ctx.req("total_price"),
            verification_code=mathx.random(6, 1),
            created_at=osx.time_after_seconds(0),
            created_at=osx.time_after_seconds(15*60),
        }
    }).data,
    state.orm().table({"booking"}).create({
        {
            roomid=ctx.req("roomid"),
            orderid="#0.0.id",
            book_start=ctx.req("check_in_date"),
            book_end=ctx.req("check_out_date")
        }
    }).data,
    state.orm().table({"coupon_instance"}).where({
        "id = ?", coupon_id
    }).updates({
        {
            validaty_times="[[expr]]validaty_times-?,1"
        }
    }).data
}).exec("base", false)
if res.err ~= nil then
    ctx.json(400, {msg="订单创建失败"})
    return
end

ctx.json(200, {
    msg="订单创建成功",
    data={
        orderid=res.res.res1[1].id,
        out_trade_no=res.res.res1[1].out_trade_no
    }
})