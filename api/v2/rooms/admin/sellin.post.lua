-- description=新增房源信息
-- request=[
--   {"name": "json@id", "type": "string"}
-- ]
-- middlewares=jwt@match,role,1|2|10


local res = state.orm()
    .table({"rooms"})
    .where({
        "id = ?", ctx.req("id")
    })
    .updates({
        {status=1}
    })
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="房间上架失败"})
    return
end

ctx.json(200, {
    msg="房间上架成功"
})