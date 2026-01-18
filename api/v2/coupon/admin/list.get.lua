-- description=优惠券列表
-- middlewares=jwt_admin@match,role,10


local res = state.orm()
    .table({"coupon_definition"})
    .find({})
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="优惠券列表查询失败"})
    return
end

ctx.json(200, {
    data=res.res
})