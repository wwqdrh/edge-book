-- middlewares=jwt_admin@match,role,1|2|10

local res = state.orm()
    .table({"orders"})
    .count({})
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="订单数查询失败"})
    return
end

ctx.json(200, {
    data=res.res
})