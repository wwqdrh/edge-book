-- description=判断用户是否是admin角色
-- request=[
--   {"name": "json@phone", "type": "string", "required": true}
-- ]
-- middlewares=jwt

local res = state.orm()
    .table({"users"})
    .select({
        "role"
    })
    .first({
        {phone=ctx.req("phone")}
    })
    .exec("base", false)

if res.err ~= nil or next(res.res) == nil then
    ctx.json(400, {msg="用户不存在"})
    return
end

if res.res.role == 0 then
    ctx.json(200, {
        isadmin=false,
        msg="查询成功"
    })
else
    ctx.json(200, {
        isadmin=true,
        msg="查询成功"
    })
end
