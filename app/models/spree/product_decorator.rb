module Spree
  Product.class_eval do

    def uniq_color_options
      _uniq_options = {}
      variants.map do |v|
        value = v.option_values.joins(:option_type).where(spree_option_types: { presentation: 'Color' }).sort do |a, b|
          a.option_type.position <=> b.option_type.position
        end[0]
        _uniq_options[value.id] = value.presentation
      end
      _uniq_options
    end

  end
end
