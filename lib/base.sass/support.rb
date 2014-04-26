module Sass::Script::Functions

  def browsers(prefix = nil)
    browsers = if prefix
      assert_type prefix, :String
      CanIUse.instance.browsers_data.select { |k, v| v['prefix'] == prefix.value }
    else
      CanIUse.instance.browsers_data
    end

    ruby_to_sass(browsers)
  end

  def supports(feature = nil)
    feature_supports = if feature
      assert_type feature, :String
      CanIUse.instance.supports_data[feature.value]
    else
      CanIUse.instance.supports_data
    end

    ruby_to_sass(feature_supports)
  end

end
