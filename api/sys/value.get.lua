-- description=验证码
-- middlewares=jwt
-- request=[
--   {"name": "query@name", "type": "string", "required": true}
-- ]

local res = state.orm()
    .table({"sys_info"})
    .select({"value"})
    .first({
        {name=ctx.req("name")}
    })
    .exec("base", false)
if err ~= nil then
    ctx.json(500, {msg="检查失败", desc=err})
    return
end

if next(res.res) == nil then
    ctx.json(200, {
        ok=false
    })
else
    ctx.json(200, {
        data=res.res,
        ok=true
    })
end
