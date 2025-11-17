-- middlewares=jwt_admin@match,role,1|2|10


local res = state.orm()
    .table({"room_feature"})
    .select({"id", "mode", "title", "icon"})
    .where({"mode=?", 1})
    .find({})
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="房间列表查询失败"})
    return
end

ctx.json(200, {
    data=res.res
})