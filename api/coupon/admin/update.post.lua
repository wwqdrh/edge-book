-- description=新建优惠券类型，指定名称，优惠方式(优惠率，减免金)，卡图
-- request=[
--   {"name": "json@id", "type": "int"},
--   {"name": "json@name", "type": "string"},
--   {"name": "json@type", "type": "int"},
--   {"name": "json@value", "type": "int"}
-- ]
-- middlewares=jwt_admin@match,role,10

if not ctx.reqhas("id") then
    local res = state.orm()
        .table({"coupon_definition"})
        .create({
            {
                name=ctx.req("name"),
                discount_type=ctx.req("type"),
                discount_value=ctx.req("value")
            }
        })
        .exec("base", false)

    if res.err ~= nil then
        ctx.json(400, {msg="优惠券新增失败"})
        return
    end

    ctx.json(200, {
        msg="优惠券新增成功"
    })
else
    local res = state.orm()
        .table({"coupon_definition"})
        .where({"id = ?", ctx.req("id")})
        .updates({
            {
                name=ctx.req("name"),
                discount_type=ctx.req("type"),
                discount_value=ctx.req("value"),
            }
        })
        .exec("base", false)

    if res.err ~= nil then
        ctx.json(400, {msg="优惠券信息修改失败"})
        return
    end

    ctx.json(200, {
        msg="优惠券信息修改成功"
    })
end
