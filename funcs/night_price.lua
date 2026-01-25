-- name=night_price
-- entry=index
-- args=[
-- {"name": "roomid", "type": "number"}
-- ]

function index(roomid)
    local res = state.orm()
        .table({"rooms"})
        .where({
            "id = ?", roomid
        })
        .find({})
        .exec("base", false)
    if res.err ~= nil or next(res.res) == nil then
        return 0, "价格查询失败"
    else
        return res.res[1].price, ""
    end
end
