module GSA
  class SearchConverter

    def self.convert(convertable)

      results     = GSA::ReadableResults.extract(convertable)

      result_sets = GSA::ReadableResultSets.extract(results)
      result_sets = GSA::ReadableResultSets.parse(result_sets)
      
      if results.include?(GSA::FACETS)
        facets    = GSA::ReadableFacets.extract(results)
        facets    = GSA::ReadableFacets.parse(facets)
      end

      { :result_sets => result_sets, :facets => (facets || GSA::NO_RESULTS) }
    end
  end
end
