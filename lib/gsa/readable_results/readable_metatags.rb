module GSA
  class ReadableMetatags < ReadableResults

    def self.parse(metatags)
      puts metatags.inspect
      exit
      parse_core(metatags) {|meta_pair| convert(meta_pair) }
    end

    def self.convert(meta_pair)
      {
        :meta_name => meta_pair[GSA::META_NAME], 
        :meta_value => meta_pair[GSA::META_VALUE]
      }
    end
  end
end
