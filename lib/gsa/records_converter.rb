module GSA
  class RecordsConverter
    extend XMLizer
    extend Injector

    def self.convert(args)
      records         = args[:records]
      file_name       = args[:file_name]
      searchable      = args[:searchable]
      datasource_name = args[:datasource_name]
      datasource_uri  = args[:datasource_uri]
      datasource_uid  = args[:datasource_uid]
      action          = args[:delete?] ? GSA::DELETE_ACTION : GSA::ADD_ACTION

      # if there is only one record, convert to the expected array.
      records = [records] if records.is_a? Hash

      layout(records, searchable, datasource_name, datasource_uri, datasource_uid, action)
    end

    #######
    private
    #######

    def self.layout(records, searchable, datasource_name, datasource_uri, datasource_uid, action)
      xml(
        block(:gsafeed,
              block(:header,
                    block(:datasource, datasource_name) << 
                    block(:feedtype, GSA::FEED_TYPE)
              ) <<
              block(:group, 
                record_blocks(records, searchable, datasource_uri, datasource_uid), 
                {:action => action}
              )
        )
      )
    end

    def self.record_blocks(records, searchable, datasource_uri, datasource_uid)
      inject_s(records) {|record| record_block(record, searchable, datasource_uri, datasource_uid)}
    end

    def self.record_block(record, searchable, datasource_uri, datasource_uid)
      block(:record,
        block(:metadata, record_metadata(record)) <<
        block(:content, record_searchable(record, searchable)),
        {:url => "#{datasource_uri}/#{record[datasource_uid]}", :mimetype => GSA::MIME_TYPE} # ABSTRACT URL STRING VALUE (id)
      )
    end

    def self.record_searchable(record, searchable)
      inject_s(searchable) {|search| " #{record[search.to_s]}"}
    end

    def self.record_metadata(record)
      inject_s(record) {|key, value| tag(:meta, {:name => key.to_s, :content => value.to_s})}
    end
  end
end
