module Facade
  def feed(args)
    xml = records_to_xml(args)
    feed_to_gsa(xml, args[:datasource_name])
  end

  def search(query, filters={})
    check_base_uri
    raw_results = GSA::Searcher.search(query, filters)
    return raw_results if raw_results == GSA::NO_RESULTS
    if filters[:embedded]
      raw_results
    else
      beautify_search_results(raw_results)
    end
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

  def check_base_uri
    raise GSA::URINotSetError, GSA::NO_URI_TEXT unless GSA.base_uri
  end

  def beautify_search_results(search_results)
    GSA::SearchConverter.convert(search_results)
  end

  def records_to_xml(args)
    GSA::RecordsConverter.convert(args)
  end
end
