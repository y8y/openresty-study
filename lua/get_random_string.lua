local args = ngx.req.get_uri_args()
local salt = args.salt

if not salt then
    ngx.exit(ngx.HTTP_BAD_REQUEST)
end

local s = ngx.md5(ngx.time() .. salt)
ngx.say(s)
