module GSA
  class RecordsConverter
    extend XMLizer
    extend Injector
    extend Filer

    def self.convert(args)
      records         = args[:records]
      file_name       = args[:file_name]
      searchable      = args[:searchable]
      datasource_name = args[:datasource_name]
      action          = args[:delete?] ? GSA::DELETE_ACTION : GSA::ADD_ACTION

      # if there is only one record, convert to the expected array.
      records = [records] if records.is_a? Hash

      build_xml_file(file_name, layout(records, searchable, datasource_name, action))
    end

    #######
    private
    #######

    def self.layout(records, searchable, datasource_name, action)
      xml(
        block(:gsafeed,
              block(:header,
                    block(:datasource, datasource_name) << 
                    block(:feedtype, GSA::FEED_TYPE)
              ) <<
              block(:group, 
                record_blocks(records, searchable), 
                {:action => action}
              )
        )
      )
    end

    def self.record_blocks(records, searchable)
      inject_s(records) {|record| record_block(record, searchable)}
    end

    def self.record_block(record, searchable)
      block(:record,
        block(:metadata, record_metadata(record)) <<
        block(:content, record_searchable(record, searchable)),
        {:url => "#{GSA::DATASOURCE_BASE_URI}/#{record[GSA::DATASOURCE_UID.to_s]}", :mimetype => GSA::MIME_TYPE} # ABSTRACT URL STRING VALUE (id)
      )
    end

    def self.record_searchable(record, searchable)
      inject_s(searchable) {|search| " #{record[search.to_s]}"}
    end

    def self.record_metadata(record)
      inject_s(record) {|key, value| tag(:meta, {:name => key, :content => value})}
    end
  end
end
