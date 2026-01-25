-- description=创建房间订单
-- request=[
--   {"name": "json@orderid", "type": "int", "required": true}
-- ]
-- middlewares=jwt_admin@match,role,1|2|10

local res = state.orm()
    .table({"orders"})
    .where({
        "id = ?", ctx.req("orderid")
    })
    .updates({
        {status=2}
    })
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="入住失败"})
    return
end

ctx.json(200, {
    msg="入住成功"
})