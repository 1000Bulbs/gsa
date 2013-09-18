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

#records = [
#{"id"=>1, "name"=>"blue Incandescent bulb", "description"=>"excellent and masterful blue bulb", "voltage"=>"120", "brand"=>"Bulbrite", "material"=>"Plastic", "bulb_type"=>"Incandescent", "bulb_color"=>"blue", "price"=>71},
#{"id"=>2, "name"=>"white Incandescent bulb", "description"=>"awe-inspiring and poignant white bulb", "voltage"=>"220", "brand"=>"Satco", "material"=>"Brass", "bulb_type"=>"Incandescent", "bulb_color"=>"white", "price"=>41},
#{"id"=>3, "name"=>"blue Halogen bulb", "description"=>"super and masterful blue bulb", "voltage"=>"100", "brand"=>"Eiko", "material"=>"Plastic", "bulb_type"=>"LED", "bulb_color"=>"blue", "price"=>66},
#{"id"=>4, "name"=>"yellow Incandescent bulb", "description"=>"awesome and tasteful yellow bulb", "voltage"=>"220", "brand"=>"Plusrite", "material"=>"Brass", "bulb_type"=>"Incandescent", "bulb_color"=>"yellow", "price"=>27},
#{"id"=>5, "name"=>"green LED bulb", "description"=>"amazing and unique green bulb", "voltage"=>"135", "brand"=>"Sylvania", "material"=>"Fiberglass", "bulb_type"=>"LED", "bulb_color"=>"green", "price"=>95},
#{"id"=>6, "name"=>"yellow LED bulb", "description"=>"awesome and unique yellow bulb", "voltage"=>"65", "brand"=>"Sylvania", "material"=>"Resin", "bulb_type"=>"LED", "bulb_color"=>"yellow", "price"=>4},
#{"id"=>7, "name"=>"yellow LED bulb", "description"=>"cheery and interesting yellow bulb", "voltage"=>"135", "brand"=>"Satco", "material"=>"Fiberglass", "bulb_type"=>"Incandescent", "bulb_color"=>"yellow", "price"=>53},
#{"id"=>8, "name"=>"yellow Incandescent bulb", "description"=>"excellent and masterful yellow bulb", "voltage"=>"45", "brand"=>"Eiko", "material"=>"Metal", "bulb_type"=>"Incandescent", "bulb_color"=>"yellow", "price"=>6},
#{"id"=>9, "name"=>"white Incandescent bulb", "description"=>"super and haunting white bulb", "voltage"=>"140", "brand"=>"Plusrite", "material"=>"Wood", "bulb_type"=>"Incandescent", "bulb_color"=>"white", "price"=>94},
#{"id"=>10, "name"=>"blue Incandescent bulb", "description"=>"awesome and warm blue bulb", "voltage"=>"45", "brand"=>"Eiko", "material"=>"Ceramic", "bulb_type"=>"Halogen", "bulb_color"=>"blue", "price"=>17},
#{"id"=>11, "name"=>"black Incandescent bulb", "description"=>"amazing and haunting black bulb", "voltage"=>"45", "brand"=>"Bulbrite", "material"=>"Brass", "bulb_type"=>"Halogen", "bulb_color"=>"black", "price"=>63},
#{"id"=>12, "name"=>"white Halogen bulb", "description"=>"awe-inspiring and heavenly white bulb", "voltage"=>"45", "brand"=>"Sylvania", "material"=>"Fabric", "bulb_type"=>"LED", "bulb_color"=>"white", "price"=>85},
#{"id"=>13, "name"=>"blue Incandescent bulb", "description"=>"super and unique blue bulb", "voltage"=>"135", "brand"=>"Satco", "material"=>"Resin", "bulb_type"=>"Flourescent", "bulb_color"=>"blue", "price"=>19},
#{"id"=>14, "name"=>"green Flourescent bulb", "description"=>"super and special green bulb", "voltage"=>"75", "brand"=>"Plusrite", "material"=>"Glass", "bulb_type"=>"Halogen", "bulb_color"=>"green", "price"=>59},
#{"id"=>15, "name"=>"white Incandescent bulb", "description"=>"cool and unique white bulb", "voltage"=>"135", "brand"=>"Sylvania", "material"=>"Ceramic", "bulb_type"=>"Flourescent", "bulb_color"=>"white", "price"=>79}
#]

##### searchable == searchable record attributes
#results = GSA.direct_feed(
#  :file_name       => "out", 
#  :records         => records, 
#  :searchable      => [:name, :description],
#  :datasource_name => "products"
#)
#puts results # ie "success"

# search
#query = "black bulb"
#pretty_search = GSA.pretty_search(query)
#uids = GSA.uids_from_pretty_search(pretty_search)
#puts uids.inspect
























































































































































































































