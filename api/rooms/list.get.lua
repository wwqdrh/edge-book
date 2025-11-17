-- description=获取房源列表，可以指定筛选条件进行查询，提供分页功能
-- request=[
--   {"name": "query@start_date", "type": "date"},
--   {"name": "query@end_date", "type": "date"}
-- ]

if ctx.reqhas("start_date") and ctx.reqhas("end_date") then
    invalid_roomid_res = state.orm()
        .table({"rooms"})
        .select({
            "rooms.id"
        })
        .joins({
            {"LEFT JOIN booking ON rooms.id = booking.roomid"}
        })
        .where({
            "booking.deleted_at IS NULL AND (\
                (booking.book_start < ? AND booking.book_end > ?)\
            )", ctx.req("end_date"), ctx.req("start_date")
        })
        .find({
            {"unique", "id"},
            {"combine", "id"}
        })
        .exec("base", false)

    if invalid_roomid_res.err ~= nil then
        ctx.json(400, {msg="房间列表查询失败"})
        return
    end

    if #invalid_roomid_res.res > 0 and #invalid_roomid_res.res[1].id > 0 then
        -- invalid_roomid_res是所有不能用的房间
        res = state.orm()
            .table({"rooms"})
            .where({
                "status=?", 1
            })
            .notin({
                invalid_roomid_res.res[1]
            })
            .find({
                {"toArray", "slider_images"}
            })
            .exec("base", false)

        if res.err ~= nil then
            ctx.json(400, {msg="房间列表查询失败"})
            return
        end
    else
        res = state.orm()
        .table({"rooms"})
        .where({
            "status=?", 1
        })
        .find({
            {"toArray", "slider_images"}
        })
        .exec("base", false)

        if res.err ~= nil then
            ctx.json(400, {msg="房间列表查询失败"})
            return
        end
    end
else
    res = state.orm()
        .table({"rooms"})
        .where({
            "status=?", 1
        })
        .find({
            {"toArray", "slider_images"}
        })
        .exec("base", false)

    if res.err ~= nil then
        ctx.json(400, {msg="房间列表查询失败"})
        return
    end
end

ctx.json(200, {
    data=res.res
})