module GSA
  class Faceter
    def self.facet(search_results, facetables=[])
      faceted = build_faceted(facetables)

      faceted = populate_faceted(search_results, facetables, faceted)

      faceted = group_faceted(facetables, faceted)
    end

    def self.build_faceted(facetables)
      faceted = {}
      facetables.each {|facetable| faceted[facetable] = []}
      faceted
    end

    def self.populate_faceted(search_results, facetables, faceted)
      search_results.each {|result| handle_metatags(result, facetables, faceted)}
      faceted
    end

    def self.handle_metatags(result, facetables, faceted)
      result[:metatags].each {|metatag| add_value_to_group(facetables, faceted, metatag)}
    end

    def self.add_value_to_group(facetables, faceted, metatag)
      if facetables.include? metatag[:meta_name].to_sym
        faceted[metatag[:meta_name].to_sym] << metatag[:meta_value]
      end
    end

    def self.group_faceted(facetables, faceted)
      facetables.each {|facetable| faceted[facetable] = sub_groups(faceted, facetable)}
      faceted
    end

    def self.sub_groups(faceted, facetable)
      faceted[facetable].group_by(&:capitalize).map {|k,v| [k, v.length]} # change capitalize to something less invasive (don't alter the original form)
    end
  end
end
