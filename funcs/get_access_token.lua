-- name=get_access_token
-- entry=index
-- args=[]

function index()
    token_key = "wx_access_token_"
    token_data, err1 = osx.gcache(token_key)
    if err1 ~= nil then
        content, err = osx.fetch("https://api.weixin.qq.com/cgi-bin/token", "get", {
            query={
                grant_type="client_credential",
                appid=osx.genv("wx_appid"),
                secret=osx.genv("wx_secret")
            }
        })
        if err ~= nil then
            return json.encode({err=err})
        end
        expire_at = osx.time_after_seconds(json.query(content, "expires_in"))
        content, err = json.set(content, {expire_at=expire_at})
        if err ~= nil then
            return json.encode({err=err})
        end
        osx.scache(token_key, content)
        token_data = content
    end
    return token_data
end