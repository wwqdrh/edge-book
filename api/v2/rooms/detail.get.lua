-- description=获取房间详细信息
-- request=[
--   {"name": "query@roomid", "type": "int", "required": true}
-- ]

local res = state.orm()
    .table({"rooms"})
    .first({
        "id=?", ctx.req("roomid")
    })
    .find({
        {"toArray", "slider_images"}
    })
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="房间列表查询失败"})
    return
end

-- 查找features字段以及amentities
if res.res.features ~= nil then
    local features = state.orm()
        .table({"room_feature"})
        .select({"id", "icon", "title"})
        .where({
            helper.str2nums(res.res.features)
        })
        .find({})
        .exec("base", false)
    if features.err ~= nil then
        ctx.json(400, {msg="房间特征查询失败"})
        return
    else
        res.res.features = features.res
    end
end

if res.res.amentities ~= nil then
    local amentities = state.orm()
        .table({"room_feature"})
        .select({"id", "icon", "title"})
        .where({
            helper.str2nums(res.res.amentities)
        })
        .find({})
        .exec("base", false)
    if amentities.err ~= nil then
        ctx.json(400, {msg="房间特征查询失败"})
        return
    else
        res.res.amentities = amentities.res
    end
end

ctx.json(200, {
    data=res.res
})