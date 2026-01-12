-- description=获取书本内容
-- request=[
--   {"name": "query@book", "type": "string", "required": true}
-- ]

local content, err = osx.content("content/" .. ctx.req("book") .. ".json")
if err ~= nil then
    ctx.json(400, {msg="书籍不存在",detail=err})
    return
end

ctx.json(200, json.decode(content))