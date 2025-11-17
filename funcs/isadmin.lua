-- name=isadmin
-- entry=index
-- args=[{"name": "phone", "type": "string"}]

function index(phone)
    local res = state.orm()
        .table({"admins"})
        .select({"id"})
        .first({
            {phone=phone}
        })
        .exec("base", false)
    if res.err ~= nil or next(res.res) == nil then
        return "false"
    else
        return "true"
    end
end
