module GSA
  class UIDExtractor
    def self.extract(search_results, uid)
      uids = []
      search_results.map do |search_result|
        search_result[:metatags].map {|m| uids << m[:meta_value] if m[:meta_name] == uid }
      end
      uids
    end
  end
end
