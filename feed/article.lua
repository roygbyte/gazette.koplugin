local Article = {

}

function Article:new(o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)

    return o
end

return Article
