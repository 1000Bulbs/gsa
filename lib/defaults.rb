module Defaults
  # remember to set your base uri :)
  NO_URI_TEXT            = "base_uri not set"

  # feed extension
  FEED_EXTENSION         = ":19902/xmlfeed"
  
  # feed actions
  ADD_ACTION             = "add"
  DELETE_ACTION          = "delete"

  # values for feeding
  FEED_TYPE              = "incremental" # OPTIONS: incremental, full

  # values for searching
  MAX_RESULTS            = "1000"        # GSA MAX: 1000
  DEFAULT_NUM            = MAX_RESULTS   # OPTIONS: 1..1000
  DEFAULT_FILTER         = "0"           # OPTIONS: 0, 1, s, p
  DEFAULT_GETFIELDS      = "*"           # OPTIONS: * || names of specific metadatum. ie: price || name.price.description
  DEFAULT_SORT           = "relevance"   # OPTIONS: relevance, date
  DEFAULT_OUTPUT         = "xml_no_dtd"  # OPTIONS: xml_no_dtd, xml
  DEFAULT_START          = "0"           # OPTIONS: 0..max_search_results
  DEFAULT_CLIENT         = "default_frontend"
  NO_RESULTS             = 0

  # values for making xml files
  DOC_TYPE               = "<!DOCTYPE gsafeed PUBLIC '-//Google//DTD GSA Feeds//EN' ''>"
  XML_TYPE               = "<?xml version='1.0' encoding='UTF8'?>"
  MIME_TYPE              = "text/plain"

  # values for parsing returned search results
  GOOGLE_SEARCH_PROTOCOL = "GSP"
  PARAMETERS             = "PARAM"
  RESULTS                = "RES"
  RESULT                 = "R"
  RESULT_NUMBER          = "N"
  URL                    = "U"
  TITLE                  = "T"
  METATAGS               = "MT"
  META_NAME              = "N"
  META_VALUE             = "V"
  SEARCH_RESULT_SNIPPET  = "S"

  # values for parsing returned dynamic navigation ( faceting )
  FACETS                 = "PARM"
  FACET                  = "PMT"
  FACET_RAW_NAME         = "NM"
  FACET_DISPLAY_NAME     = "DN"
  FACET_IS_RANGE         = "IR" # 1, 0 (boolean)
  FACET_TYPE             = "T"  # 0-Integer, 1-String, 2-Float, 3-Currency, 4-Date
  BUCKET                 = "PV"
  BUCKET_VALUE           = "V"
  BUCKET_LOW_RANGE       = "L"
  BUCKET_HIGH_RANGE      = "H"
  BUCKET_COUNT           = "C"
end
