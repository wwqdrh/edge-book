-- description=修改信息
-- request=[
--   {"name": "json@id", "type": "int", "required": true},
--   {"name": "json@name", "type": "string"},
--   {"name": "json@phone", "type": "string"},
--   {"name": "json@password", "type": "string"}
-- ]
-- middlewares=jwt@match,role,2|10

local record = {
    name=ctx.req("name"),
    phone=ctx.req("phone")
}
if ctx.reqhas("password") then
    record.insert("password", "[[password]]" .. ctx.req("password"))
end

local res = state.orm()
    .table({"users"})
    .where({
        "id = ?", ctx.req("id")
    })
    .updates({record})
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="修改信息失败"})
    return
end

ctx.json(200, {
    msg="修改信息成功"
})