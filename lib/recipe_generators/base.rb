module RecipeGenerators
  class Base
    def generate(_)
      raise NotImplementedError
    end

    private

    def parse_response(responce)
      JSON.parse(responce, symbolize_names: true)
    end
  end
end
