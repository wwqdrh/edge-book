-- description=新增房源信息
-- request=[
--   {"name": "json@name", "type": "string", "required": true},
--   {"name": "json@door_number", "type": "string", "required": true},
--   {"name": "json@price", "type": "int", "required": true},
--   {"name": "json@status", "type": "int", "required": true},
--   {"name": "json@description", "type": "string", "required": true},
--   {"name": "json@cover_image", "type": "string"},
--   {"name": "json@slider_images", "type": "[]string"},
--   {"name": "json@features", "type": "string", "required": true},
--   {"name": "json@amentities", "type": "string", "required": true},
--   {"name": "json@area", "type": "int", "required": true},
--   {"name": "json@type", "type": "int", "required": true},
--   {"name": "json@capacity", "type": "int", "required": true}
-- ]
-- middlewares=jwt_admin@match,role,1|2|10

local res = state.orm()
    .table({"rooms"})
    .create({
        {
            name=ctx.req("name"),
            door_number=ctx.req("door_number"),
            price=ctx.req("price"),
            status=ctx.req("status"),
            description=ctx.req("description"),
            cover_image=ctx.req("cover_image"),
            slider_images=ctx.req("slider_images"),
            area=ctx.req("area"),
            typeid=ctx.req("type"),
            capacity=ctx.req("capacity"),
            features=ctx.req("features"),
            amentities=ctx.req("amentities")
        }
    })
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="房间数据新增失败"})
    return
end

ctx.json(200, {
    msg="房间新增成功"
})