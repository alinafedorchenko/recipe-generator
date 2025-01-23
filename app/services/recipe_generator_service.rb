class RecipeGeneratorService
  def initialize(ingredients, source: :anthropic)
    @ingredients = ingredients
    @generator = select_generator(source)
  end

  def call
    @generator.generate(@ingredients)
  end

  private

  def select_generator(source)
    case source
    when :anthropic
      RecipeGenerators::AnthropicGenerator.new
    else
      raise ArgumentError, "Unknown recipe generator source: #{source}"
    end
  end
end
