local Result = {
   success = nil,
   error_message = nil,
}

function Result:new(o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self

   return o
end

function Result:getId()
   return self.id
end

function Result:setError(error_message)
   self.success = false
   self.error_message = error_message
   return self
end

function Result:setSuccess()
   self.success = true
   return self
end

function Result:isSuccessful()
   return self.success
end

return Result
