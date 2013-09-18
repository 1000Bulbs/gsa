module GSA
  class Feeder
    extend Filer
    
    def self.feed(file_name, datasource_name)
      file = open_file(file_name)

      RestClient.post(
        GSA::FEED_URL, 
        {
          :feedtype   => GSA::FEED_TYPE, 
          :datasource => datasource_name, 
          :data       => file.read
        }
      )
    end
  end
end
