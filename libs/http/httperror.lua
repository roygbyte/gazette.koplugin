local _ = require("gettext")
local T = require("ffi/util").template

local HttpError = {

}

HttpError.REQUEST_UNSUPPORTED_SCHEME = _("Scheme not supported.")

return HttpError
