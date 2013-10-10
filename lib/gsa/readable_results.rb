module GSA
  class ReadableResults
    extend Injector

    def self.extract(search_results)
      search_results[GSA::GOOGLE_SEARCH_PROTOCOL][GSA::RESULTS]
    end

    def self.parse_core(parsables)
      parsables = [parsables] if parsables.is_a? Hash
      inject_a(parsables) {|parsable| yield(parsable) }
    end
  end
end
