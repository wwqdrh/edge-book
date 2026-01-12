-- description=获取书本内容
-- request=[
--   {"name": "query@tag", "type": "string", "required": true},
--   {"name": "query@title", "type": "string", "required": true}
-- ]

local tag_content, err = osx.content("content/books/tags.json")
if err ~= nil then
    ctx.json(400, {msg="分类不存在",detail=err})
    return
end

local article_path, err = json.query(tag_content, '.#(name=="' .. ctx.req("tag") .. '").path')
if err ~= nil then
    ctx.json(400, {msg="分类不存在",detail=err})
    return
end

local article_content, err = osx.content("content/books/" .. article_path)
if err ~= nil then
    ctx.json(400, {msg="分类不存在",detail=err})
    return
end

ctx.json(200, {
    data=json.query(article_content, '.#(title=="' .. ctx.req("title") .. '").content')
})