-- description=查看订单详细信息
-- request=[
--   {"name": "query@code", "type": "string", "required": true}
-- ]
-- middlewares=jwt_admin@match,role,1|2|10

local res = state.orm()
    .table({"orders"})
    .where({"verification_code = ?", ctx.req("code")})
    .find({})
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="订单信息查询失败"})
    return
end

ctx.json(200, {
    data=res.res
})
