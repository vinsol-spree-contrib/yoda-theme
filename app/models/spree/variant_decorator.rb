module Spree
  Variant.class_eval do

    def color_options_text
      value = self.option_values.joins(:option_type).where(spree_option_types: { presentation: 'Size' }).sort do |a, b|
        a.option_type.position <=> b.option_type.position
      end[0]
      value.try(:presentation)
    end

  end
end
