module Cielo
  module ReturnInfo
    module_function

    def fetch(code)
      infos[code]
    end

    def infos
      @infos ||= YAML.load_file(File.expand_path("return_infos.yml", __dir__))
    end
  end
end
