-- description=获取房间详细信息
-- request=[
--   {"name": "query@typeid", "type": "int"}
-- ]
-- middlewares=jwt_admin@match,role,1|2|10

local res = state.orm()
    .table({"rooms"})
    .where({"typeid=?",ctx.req("typeid")})
    .count({})
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="房间列表查询失败"})
    return
end

ctx.json(200, {
    data=res.res
})