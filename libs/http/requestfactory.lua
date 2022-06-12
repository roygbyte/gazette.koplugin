local Request = require("libs/http/request")

local RequestFactory = {

}

function RequestFactory:makeGetRequest(url, config)
    return Request:new{
        url = url,
        timeout = config.timeout,
        maxtime = config.maxtime,
        method = Request.method.get
    }
end

return RequestFactory
