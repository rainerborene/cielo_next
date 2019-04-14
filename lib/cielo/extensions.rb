module Cielo
  module Extensions
    refine Hash do
      def camelize_keys!
        deep_transform_keys! { |k| k.to_s.camelize }
      end

      def seek(*args)
        args.each do |path|
          value = dig(*Array(path)) rescue nil
          return value unless value.nil?
        end
        nil
      end
    end
  end
end
