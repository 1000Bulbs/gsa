module GSA
  class ReadableFacets < ReadableResults

    def self.extract(search_results)
      (search_results[GSA::FACETS].select {|key, value| key == GSA::FACET })[GSA::FACET]
    end

    def self.parse(facets)
      parse_core(facets) {|facet| convert(facet) }
    end

    def self.convert(facet)
      {
        :facet_raw_name     => facet[GSA::FACET_RAW_NAME],
        :facet_display_name => facet[GSA::FACET_DISPLAY_NAME],
        :facet_is_range     => facet[GSA::FACET_IS_RANGE],
        :facet_type         => facet[GSA::FACET_TYPE],
        :buckets            => ReadableBuckets::parse(facet)
      }
    end
  end
end
