-- description=获取accesstoken

token_data, err = funcs.call("get_access_token", {})
if err ~= nil then
    ctx.json(500, {msg="获取access_token失败", desc=err})
    return
end

access_token = json.query(token_data, "access_token")
if access_token == "null" then
    ctx.json(500, {msg="获取access_token失败, access_token为空", detail=json.query(token_data, "err")})
    return
end

return ctx.json(200, {access_token=access_token})