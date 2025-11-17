-- description=创建房间订单
-- request=[
--   {"name": "json@orderid", "type": "int", "required": true}
-- ]
-- middlewares=jwt

local userInfo = ctx.middleware("jwt", "info").user
local userId = userInfo.id

local res = state.orm()
    .table({"orders"})
    .where({
        "id=? AND userid=?", ctx.req("orderid"), userId
    })
    .updates({
        {deleted_at="[[datetime]]NOW"}
    })
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="订单删除失败"})
    return
end

ctx.json(200, {
    msg="订单删除成功"
})