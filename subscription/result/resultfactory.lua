local Result = require("subscription/result/result")

local ResultFactory = {}

function ResultFactory:makeResult(entry_or_data)
   local result
   if entry_or_data.getId and
      type(entry_or_data.getId) == "function"
   then
      local entry = entry_or_data
      result = Result:new({
            id = entry:getId()
      })
   else
      local data = entry_or_data
      result = Result:new({
            id = data.id,
            error_message = data.error_message,
            success = data.success
      })
   end
   return result
end

return ResultFactory
