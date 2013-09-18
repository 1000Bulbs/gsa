module GSA
  class UIDExtractor
    def self.extract(search_results, uid)
      iterate_results([], search_results, uid)
    end

    def self.iterate_results(uids, search_results, uid)
      search_results.each {|result| get_uids_from_record(uids, result, uid)}
      uids
    end

    def self.get_uids_from_record(uids, record, uid)
      record[:metatags].each {|tag| add_uid(uids, tag) if uid?(tag, uid)}
    end

    def self.add_uid(uids, meta_tag)
      uids << meta_tag[:meta_value]
    end

    def self.uid?(tag, uid)
      tag[:meta_name] == uid
    end
  end
end
