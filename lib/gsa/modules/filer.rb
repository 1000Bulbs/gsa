module GSA
  module Filer
    
    def build_xml_file(file_name, contents)
      close_file(
        add_content_to_file(new_file(file_name), contents)
      ).path
    end

    def new_file(file_name)
      File.new("#{file_name}.xml", "w")
    end

    def open_file(file_name)
      File.open(file_name)
    end

    def add_content_to_file(file, content)
      file.puts(content); file
    end

    def close_file(file)
      file.close; file
    end
  end
end
