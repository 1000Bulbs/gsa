require 'rest_client'
require 'active_support/core_ext'
require 'json'

require_relative 'gsa/modules/injector'
require_relative 'gsa/modules/xmlizer'
require_relative 'gsa/modules/filer'
require_relative 'gsa/records_converter'
require_relative 'gsa/feeder'
require_relative 'gsa/searcher'
require_relative 'gsa/faceter'
require_relative 'gsa/search_converter'
require_relative 'gsa/uid_extractor'

module GSA
  #####################################################
  # CUSTOMIZABLE VALUES                               #
  #####################################################

  # values to be set as variables and not in the yaml config files
  DATASOURCE_BASE_URI = "http://0.0.0.0:3000/products" # to be set at init time
  DATASOURCE_UID      = "id"                           # to be set at init time
  
  # the base uri for your gsa box
  BASE_URI            = "http://dev-gsa.1000bulbs.com"

  # values for feeding
  FEED_TYPE           = "incremental"                  # OPTIONS: incremental, full

  # values for searching
  MAX_RESULTS         = "1000"       # GSA MAX: 1000
  DEFAULT_NUM         = MAX_RESULTS  # OPTIONS: 1..1000
  DEFAULT_FILTER      = "0"          # OPTIONS: 0, 1, s, p
  DEFAULT_GETFIELDS   = "*"          # OPTIONS: * || names of specific metadatum. ie: price || name.price.description
  DEFAULT_SORT        = "relevance"  # OPTIONS: relevance, date
  DEFAULT_OUTPUT      = "xml_no_dtd" # OPTIONS: xml_no_dtd, xml
  NO_RESULTS          = 0

  #####################################################
  # DO NOT CHANGE THESE VALUES UNLESS EMERGENCY       #
  #####################################################
  
  # feed url
  FEED_URL               = "#{BASE_URI}:19900/xmlfeed"

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
end

module GSA
  class << self
    def direct_feed(args)
      xml = records_to_xml(args)
      feed(xml, args[:datasource_name])
    end

    def pretty_search(query, filters={})
      raw_results = search(query, filters)
      return raw_results if raw_results == GSA::NO_RESULTS
      pretty_search_results(raw_results)
    end

    def facet(search_results, facetables)
      GSA::Faceter.facet(search_results, facetables)
    end

    def uids_from_pretty_search(pretty_search_results)
      GSA::UIDExtractor.extract(pretty_search_results)
    end

    #########
    protected
    #########

    def feed(xml_file, datasource_name)
      GSA::Feeder.feed(xml_file, datasource_name)
    end

    def search(query, filters={})
      GSA::Searcher.search(query, filters)
    end

    def pretty_search_results(search_results)
      GSA::SearchConverter.convert(search_results)
    end

    def records_to_xml(args)
      GSA::RecordsConverter.convert(args)
    end
  end
end
