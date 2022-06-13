local socketutil = require("socketutil")

local Response = {
    code = nil,
    headers = nil,
    status = nil,
    url = nil,
}

function Response:new(o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)

    if o:hasRedirected()
    then
        o:setUrlFromHeaders()
    end

    if o:isHostUnknown()
    then
        o.code = 404
    end

    return o
end

function Response:canBeConsumed()
    if self:hasCompleted() and
        self:hasHeaders()
    then
        return true
    else
        return false
    end
end

function Response:hasRedirected()
    if type(self.code) == "number" and
        self.code > 299 and
        self.code < 400
    then
        return true
    else
        return false
    end
end

function Response:hasCompleted()
    if not self.code or
        self.code == socketutil.TIMEOUT_CODE or
        self.code == socketutil.SSL_HANDSHAKE_CODE or
        self.code == socketutil.SINK_TIMEOUT_CODE
    then
        return false
    else
        return true
    end
end

function Response:hasHeaders()
    if self.headers == nil or
        not self.headers["content-type"]
    then
        return false
    else
        return true
    end
end

function Response:isHostUnknown()
    if self.code == "host or service not provided, or not known"
    then
        return true
    else
        return false
    end
end


function Response:setUrlFromHeaders()
    local url = self.headers.location
    local parsed_url = socket_url.parse(url)
    self.url = socet_url.build(parsed_url)
end

return Response
