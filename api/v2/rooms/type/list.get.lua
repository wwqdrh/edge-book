-- description=获取房源列表，可以指定筛选条件进行查询，提供分页功能

local res = state.orm()
    .table({"room_type"})
    .select({"id", "name"})
    .find({})
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="房间列表查询失败"})
    return
end

ctx.json(200, {
    data=res.res
})