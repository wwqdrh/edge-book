-- name=gen_admin_token
-- entry=index
-- args=[{"name": "phone", "type": "string"}]

function index(phone)
    local res = state.orm()
        .table({"admins"})
        .select({
            "id", "role"
        })
        .first({
            "phone=?", phone,
        })
        .exec("base", false)

    if res.err ~= nil then
        return json.encode({errmsg=res.err})
    end

    local tokenData, err = ctx.middleware("jwt_admin", "token", {
        user={
            id=res.res.id,
            role=res.res.role
        }
    })
    if err ~= nil then
        return json.encode({errmsg=err})
    end
    return json.encode({
        accessToken=tokenData.token,
        refreshToken=tokenData.refreshToken,
        idToken=tokenData.token
    })
end
