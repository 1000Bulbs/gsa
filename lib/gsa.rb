require 'rest_client'
require 'active_support/core_ext'
require 'json'

require_relative 'gsa/version'
require_relative 'gsa/modules/injector'
require_relative 'gsa/modules/xmlizer'
require_relative 'gsa/modules/filer'
require_relative 'gsa/records_converter'
require_relative 'gsa/feeder'
require_relative 'gsa/searcher'
require_relative 'gsa/faceter'
require_relative 'gsa/search_converter'
require_relative 'gsa/uid_extractor'
require_relative 'gsa/exceptions'

require_relative 'defaults'
require_relative 'facade'

module GSA
  class << self
    attr_accessor :base_uri
  end

  include Defaults
  extend  Facade
end
