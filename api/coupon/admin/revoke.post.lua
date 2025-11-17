-- description=撤销某个用户的优惠卡
-- middlewares=jwt_admin@match,role,10
-- request=[
--   {"name": "json@instanceid", "type": "int", "required": true}
-- ]


local userInfo = ctx.middleware("jwt", "info").user
local userId = userInfo.id

local res = state.orm()
    .table({"coupon_instance"})
    .where({
        "id=?", ctx.req("instanceid")
    })
    .updates({
        {deleted_at="[[datetime]]NOW"}
    })
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="优惠券撤销失败"})
    return
end

ctx.json(200, {
    msg="优惠券撤销成功"
})