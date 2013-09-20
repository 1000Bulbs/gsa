module GSA
  class Feeder
    def self.feed(xml, datasource_name)
      RestClient.post(
        "#{GSA.base_uri}#{GSA::FEED_EXTENSION}", 
        {
          :feedtype   => GSA::FEED_TYPE, 
          :datasource => datasource_name, 
          :data       => xml
        }
      )
    end
  end
end
