module GSA
  module Injector
    
    def inject_s(items, &block)
      inject("", items, &block)
    end

    def inject_a(items, &block)
      inject([], items, &block)
    end

    def inject(injected, items, &block)
      items.each.inject(injected) {|result, item| result << block.call(item)}
    end
  end
end
