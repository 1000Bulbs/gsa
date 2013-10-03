module GSA
  module XMLizer
    include Injector

    def xml(content)
      "#{GSA::XML_TYPE}\n#{GSA::DOC_TYPE}\n#{content}"
    end

    # for single-line tags
    def tag(tag, attributes={})
      "<#{tag.to_s}#{attributor(attributes)}/>\n"
    end

    # for container tags
    def block(tag, value, attributes={})
      "<#{tag.to_s}#{attributor(attributes)}>\n" << value.to_s << "</#{tag.to_s}>\n"
    end

    # for creating attributes on tags
    def attributor(attributes)
      inject_s(attributes) {|key, value| " #{key.to_s}=\"#{value.to_s}\""}
    end
  end
end
