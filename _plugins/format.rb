module Jekyll::CustomFilter
    # Each method of the module creates a custom Jekyll filter
    def fmt(input, f)
        return format("%#{f}", input);
    end
  end
  
  Liquid::Template.register_filter(Jekyll::CustomFilter)