module GSA
  class Searcher
    FIELDS = [
      :tlen, :proxyreload, :proxystylesheet, :emmain, :emsingleres, :emdstyle, :dnavs, :entqr, :entsp,
      :query, :filter, :getfields, :sort, :num, :output, :start, :client, :site, :requiredfields
    ]

    def self.search(query, args = {})
      query                  = clean_query(query)
      args[:site]            = args[:collection] || GSA::DEFAULT_COLLECTION
      args[:requiredfields]  = args[:filters] || nil

      search = "#{GSA.base_uri}/search?q=#{query}"

      FIELDS.each do |field|
        begin
          value = args[field] || GSA.send("DEFAULT_#{field.capitalize}")
          search = "#{search}&#{field.to_s}=#{value}"
        rescue NoMethodError
          # The argument was not set, no worries.
        end
      end

      puts "URL = #{search}"

      results = RestClient.get(search)
      return results if args[:embedded]

      search_results = parsed_json(results)
      results_found?(search_results) ? search_results : GSA::NO_RESULTS
    end

    def self.clean_query(query)
      query.tr(' ', '+')
    end

    def self.parsed_json(xml)
      Hash.from_xml(xml)
    end

    def self.results_found?(search_results)
      search_results[GSA::GOOGLE_SEARCH_PROTOCOL].has_key? GSA::RESULTS
    end
  end
end
