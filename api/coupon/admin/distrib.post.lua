-- description=选择一个优惠券，分发给某个用户，需要指定可使用次数，有效期时间
-- request=[
--   {"name": "json@coupon_id", "type": "int", "required": true},
--   {"name": "json@phone", "type": "string", "required": true},
--   {"name": "json@times", "type": "int", "required": true},
--   {"name": "json@period", "type": "datetime", "required": true}
-- ]
-- middlewares=jwt_admin@match,role,10

local res = state.orm()
    .table({"users"})
    .first({
        {phone=ctx.req("phone")}
    })
    .exec("base", false)
if err ~= nil then
    ctx.json(500, {msg="不存在该用户", desc=err})
    return
end

local user_id = res.res.id
local res = state.orm()
    .table({"coupon_instance"})
    .create({
        {
            coupon_id=ctx.req("coupon_id"),
            user_id=user_id,
            validaty_times=ctx.req("times"),
            validity_period=ctx.req("period")
        }
    })
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="优惠券分发失败"})
    return
end

ctx.json(200, {
    msg="优惠券分发成功"
})