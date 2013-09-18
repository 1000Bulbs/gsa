module GSA
  class UIDExtractor
    def self.extract(search_results)
      iterate_results([], search_results)
    end

    def self.iterate_results(uids, search_results)
      search_results.each {|result| get_uids_from_record(uids, result)}
      uids
    end

    def self.get_uids_from_record(uids, record)
      record[:metatags].each {|tag| add_uid(uids, tag) if uid?(tag)}
    end

    def self.add_uid(uids, meta_tag)
      uids << meta_tag[:meta_value]
    end

    def self.uid?(tag)
      tag[:meta_name] == GSA::DATASOURCE_UID
    end
  end
end
