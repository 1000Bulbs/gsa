module GSA
  class ReadableResultSets < ReadableResults

    def self.extract(search_results)
      (search_results.select {|key, value| key == GSA::RESULT })[GSA::RESULT]
    end

    def self.parse(results_sets)
      parse_core(results_sets) {|set| convert(set) }
    end

    def self.convert(set)
      {
        :result_number         => set[GSA::RESULT_NUMBER], 
        :url                   => set[GSA::URL],
        :title                 => set[GSA::TITLE],
        :metatags              => GSA::ReadableMetatags.parse(set[GSA::METATAGS]),
        :search_result_snippet => set[GSA::SEARCH_RESULT_SNIPPET]
      } 
    end
  end
end
