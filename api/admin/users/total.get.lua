-- middlewares=jwt_admin@match,role,1|2|10

local res = state.orm()
    .table({"users"})
    .count({})
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="用户列表查询失败"})
    return
end

ctx.json(200, {
    data=res.res
})