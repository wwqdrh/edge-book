-- request=[
--   {"name": "query@start_date", "type": "date"},
--   {"name": "query@end_date", "type": "date"},
--   {"name": "query@roomid", "type": "int"}
-- ]

local res = state.orm()
    .table({"rooms"})
    .select({
        "rooms.*"
    })
    .joins({
        {"LEFT JOIN booking ON rooms.id = booking.roomid"}
    })
    .where({
        "booking.roomid = ? AND booking.deleted_at IS NULL AND (\
            (booking.book_start < ? AND booking.book_end > ?)\
        )", ctx.req("roomid"), ctx.req("end_date"), ctx.req("start_date")
    })
    .find({
        {"unique", "id"}
    })
    .exec("base", false)

if res.err ~= nil or next(res.res) ~= nil then
    ctx.json(400, {
        code=40001,
        msg="订单时间冲突，请返回首页选择时间后再来吧"
    })
else
    ctx.json(200, {
        msg="ok",
        data=res.res
    })
end
