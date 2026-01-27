-- description=新增普通用户账号
-- request=[
--   {"name": "json@name", "type": "string", "required": true},
--   {"name": "json@phone", "type": "string", "required": true},
--   {"name": "json@password", "type": "string", "default": "123456"}
-- ]

local res = state.orm()
    .table({"users"})
    .create({
        {
            name=ctx.req("name"),
            phone=ctx.req("phone"),
            password="[[password]]" .. ctx.req("password")
        }
    })
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="新增用户失败"})
    return
end

ctx.json(200, {
    msg="新增用户成功",
    data={
        id=res.res.id
    }
})
