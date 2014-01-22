require 'rest_client'
require 'active_support/core_ext'
require 'json'

require_relative 'gsa/version'
require_relative 'gsa/modules/injector'
require_relative 'gsa/modules/xmlizer'
require_relative 'gsa/records_converter'
require_relative 'gsa/feeder'
require_relative 'gsa/searcher'
require_relative 'gsa/search_converter'
require_relative 'gsa/uid_extractor'
require_relative 'gsa/exceptions'
require_relative 'gsa/readable_results'
require_relative 'gsa/readable_results/readable_buckets'
require_relative 'gsa/readable_results/readable_facets'
require_relative 'gsa/readable_results/readable_metatags'
require_relative 'gsa/readable_results/readable_result_sets'

require_relative 'defaults'
require_relative 'facade'

ActiveSupport::XmlMini.backend = 'Nokogiri'

module GSA
  class << self
    attr_accessor :base_uri
  end

  include Defaults
  extend  Facade
end
