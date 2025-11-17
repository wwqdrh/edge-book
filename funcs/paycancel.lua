-- name=paycancel
-- entry=index
-- args=[
-- {"name": "orderid", "type": "number"},
-- {"name": "userid", "type": "number"}
-- ]

function index(orderid, userid)
    local res = state.orm()
        .table({"orders"})
        .where({
            "id = ? AND userid = ?", orderid, userid 
        })
        .updates({
            {status=4}
        })
        .exec("base", false)
    if res.err ~= nil then
        return "false"
    else
        return "true"
    end
end
