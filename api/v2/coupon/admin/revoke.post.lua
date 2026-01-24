-- description=撤销某个用户的优惠卡
-- request=[
--   {"name": "json@instanceid", "type": "int", "required": true}
-- ]
-- middlewares=jwt@match,role,1|2

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