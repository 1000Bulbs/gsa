module Facade
  def feed(args)
    xml = records_to_xml(args)
    feed_to_gsa(xml, args[:datasource_name])
  end

  def search(query, filters={}, xml=false)
    raw_results = search_gsa_index(query, filters, xml)
    return raw_results if raw_results == GSA::NO_RESULTS
    return beautify_search_results(raw_results) unless xml
    raw_results
  end

  def uids(pretty_search_results, uid)
    GSA::UIDExtractor.extract(pretty_search_results, uid)
  end

  def feed_to_gsa(xml_file, datasource_name)
    if GSA.base_uri
      GSA::Feeder.feed(xml_file, datasource_name)
    else
      raise GSA::URINotSetError, GSA::NO_URI_TEXT
    end
  end

  def search_gsa_index(query, filters={}, xml=false)
    if GSA.base_uri
      GSA::Searcher.search(query, filters, xml)
    else
      raise GSA::URINotSetError, GSA::NO_URI_TEXT
    end
  end

  def beautify_search_results(search_results)
    GSA::SearchConverter.convert(search_results)
  end

  def records_to_xml(args)
    GSA::RecordsConverter.convert(args)
  end
end
