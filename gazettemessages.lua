local _ = require("gettext")

local GazetteMessages = {

}

GazetteMessages.ERROR_FEED_FETCH = _("Error fetching feed.")
GazetteMessages.ERROR_ENTRY_FETCH = _("Error fetching entry.")
GazetteMessages.UNTITLED_FEED = _("Untitled feed")
GazetteMessages.DEFAULT_NAV_TITLE = _("Table of Contents")

GazetteMessages.CONFIGURE_SUBSCRIPTION_TEST_FEED_BEGIN = _("Testing feed...")
GazetteMessages.CONFIGURE_SUBSCRIPTION_TEST_FETCH_URL = _("Fetching URL...")
GazetteMessages.CONFIGURE_SUBSCRIPTION_TEST_ERROR = _("Error! %1")
GazetteMessages.CONFIGURE_SUBSCRIPTION_TEST_SUCCESS = _("Success! Got '%1'")
GazetteMessages.CONFIGURE_SUBSCRIPTION_FEED_NOT_TESTED = _("Feed must be tested and pass before being saved.")

GazetteMessages.SYNC_SUBSCRIPTIONS_SYNC =  _("Syncing subscriptions...")


return GazetteMessages
