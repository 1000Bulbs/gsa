module GSA
  class SearchConverter
    extend Injector

    def self.convert(convertable)
      parse result_sets_from results_param_in convertable
    end

    def self.results_param_in(convertable)
      convertable[GSA::GOOGLE_SEARCH_PROTOCOL][GSA::RESULTS]
    end

    def self.result_sets_from(results)
      (results.keep_if {|key, value| key == GSA::RESULT })[GSA::RESULT]
    end

    def self.parse(result_sets)

      # if there is only one result, convert to the expected array.
      result_sets = [result_sets] if result_sets.is_a? Hash

      inject_a(result_sets) {|set|
        { 
          :result_number          => set[GSA::RESULT_NUMBER], 
          :url                    => set[GSA::URL],
          :title                  => set[GSA::TITLE],
          :metatags               => parse_metatags(set[GSA::METATAGS]),
          :search_result_snippet  => set[GSA::SEARCH_RESULT_SNIPPET]
        }
      }
    end

    def self.parse_metatags(metatags)
      inject_a(metatags) {|meta_pair| convert_meta_pair(meta_pair) }
    end

    def self.convert_meta_pair(meta_pair)
      {:meta_name => meta_pair[GSA::META_NAME], :meta_value => meta_pair[GSA::META_VALUE]}
    end
  end
end
