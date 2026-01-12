local content, err = osx.content("content/books/tags.json")
if err ~= nil then
    ctx.json(400, {msg="书籍不存在",detail=err})
    return
end

ctx.json(200, {
    data=json.query(content, ".#.name")
})