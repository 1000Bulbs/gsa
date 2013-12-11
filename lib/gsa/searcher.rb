module GSA
  class Searcher
    def self.search(query, args={})
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

      search_results = parsed_json( RestClient.get(search) )

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
