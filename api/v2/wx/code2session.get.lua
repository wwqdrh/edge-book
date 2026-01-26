-- request=[
--   {"name": "query@code", "type": "string", "required": true}
-- ]
-- description=登录凭证校验。通过 wx.login 接口获得临时登录凭证 code 后传到开发者服务器调用此接口完成登录流程

content, err = osx.fetch("https://api.weixin.qq.com/sns/jscode2session", "get", {
    query={
        appid=osx.genv("wx_appid"),
        secret=osx.genv("wx_secret"),
        grant_type="authorization_code",
        js_code=ctx.req("code")
    }
})
if err ~= nil then
    ctx.json(500, {err=err})
    return
end

ctx.json(200, {
    data=json.decode(content)
})