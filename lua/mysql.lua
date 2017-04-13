local mysql = require "resty.mysql"
local db, err = mysql:new()
if not db then
    ngx.say("failed to instantiate mysql: ", err)
    return
end

db:set_timeout(1000)    -- 1 sec

local ok, err, errno, sqlstate = db:connect{
    host = "192.168.1.110",
    port = 3306,
    database = "ngx_test",
    user = "root",
    password = "password",
    max_packet_size = 1024 * 1024
}

if not ok then
    ngx.say("failed to connect: ", err, ": ", errno, " ", sqlstate)
    return
end

ngx.say("connected to mysql.")

res, err, errno, sqlstate = db:query("create table cats "
                        .. "(id serial primary key, "
                        .. "name varchar(5))")
if not res then
    ngx.say("bad result: ", err, ": ", errno, " ", sqlstate)
    return
end

ngx.say("table cats created.")

res, err, errno, sqlstate = db:query("insert into cats (name) "
                        .. "values (\'Bob\'), (\'\'), (null)")

if not res then
    ngx.say("bad result: ", err, ": ", errno, " ", sqlstate)
    return
end
