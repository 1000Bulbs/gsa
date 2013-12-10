module GSA
  class Searcher
    def self.search(query, args={}, xml=false)
      query           = clean_query(query)
      filter          = args[:filter]    || GSA::DEFAULT_FILTER
      getfields       = args[:getfields] || GSA::DEFAULT_GETFIELDS
      sort            = args[:sort]      || GSA::DEFAULT_SORT
      num             = args[:num]       || GSA::DEFAULT_NUM  
      output          = args[:output]    || GSA::DEFAULT_OUTPUT
      start           = args[:start]     || GSA::DEFAULT_START
      client          = args[:client]    || GSA::DEFAULT_CLIENT
      requiredfields  = args[:filters]   || nil

      search = "#{GSA.base_uri}/search?q=#{query}&filter=#{filter}&getfields=#{getfields}&sort=#{sort}&num=#{num}&start=#{start}&output=#{output}&client=#{client}"
      search = "#{search}&requiredfields=#{clean_query(requiredfields)}" if requiredfields

      if xml
        search_results = RestClient.get(search)
        search_results = search_results.include?(GSA::RESULTS) ? search_results : GSA::NO_RESULTS
      else
        search_results = parsed_json( RestClient.get(search) )
        search_results = results_found?(search_results) ? search_results : GSA::NO_RESULTS
      end

      search_results
    end

    def self.clean_query(query)
      query.tr(' ', '+')
    end

    def self.parsed_json(xml)
      JSON.parse(Hash.from_xml(xml).to_json)
    end

    def self.results_found?(search_results)
      search_results[GSA::GOOGLE_SEARCH_PROTOCOL].has_key? GSA::RESULTS
    end
  end
end
