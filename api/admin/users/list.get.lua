-- request=[
--    {"name": "query@page", "type": "int", "default": 1},
--    {"name": "query@pagesize", "type": "int", "default": 10}
-- ]
-- middlewares=jwt_admin@match,role,1|2|10

local startidx = (ctx.req("page") - 1) * ctx.req("pagesize")
local res = state.orm()
    .table({"users"})
    .limit({10})
	.offset({startidx})
    .find({})
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="用户列表查询失败"})
    return
end

ctx.json(200, {
    data=res.res
})