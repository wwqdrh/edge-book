-- description=获取优惠券详细信息
-- request=[
--   {"name": "json@id", "type": "int", "required": true}
-- ]
-- middlewares=jwt_admin@match,role,10

local res = state.orm()
    .table({"coupon_definition"})
    .first({"id = ?", ctx.req("id")})
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="优惠券信息查询失败"})
    return
end

ctx.json(200, {
    data=res.res
})
