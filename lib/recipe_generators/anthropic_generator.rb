require "faraday"

module RecipeGenerators
  class AnthropicGenerator < Base
    BASE_URL = "https://api.anthropic.com/v1/complete"
    ANTHROPIC_VERSION = "2023-06-01"

    def initialize(api_key = ENV["ANTHROPIC_API_KEY"])
      @api_key = api_key
    end

    def generate(ingredients)
      recipe_response = Faraday.post(BASE_URL,
                                     recipe_request_payload(ingredients).to_json,
                                     request_headers)
      recipe_result = parse_response(recipe_response.body)
      recipe_error = recipe_result.dig(:error, :message)

      unless recipe_error
        recipe_check_response = Faraday.post(BASE_URL,
                                             recipe_check_request_payload(recipe_result[:completion]).to_json,
                                             request_headers)

        recipe_check_result = parse_response(recipe_check_response.body)
        return { recipe: recipe_result[:completion] } if recipe_check_result[:completion].include?("yes")
      end
      { error: recipe_error || "Something went wrong. Try one more time." }
    end

    private

    def recipe_request_payload(ingredients)
      prompt = <<~PROMPT
        You are a creative culinary AI assistant tasked with generating a recipe based on one or more ingredients provided by the user. Your goal is to create a delicious and feasible recipe that incorporates all or most of the given ingredients.
        Here is the list of ingredients you will be working with:
        <ingredients>
        #{ingredients}
        </ingredients>
        Follow these steps to generate a recipe:
        1. Analyze the ingredients provided and consider their flavors, textures, and common culinary uses.
        2. Determine a suitable dish that can be made using these ingredients. Be creative but practical.
        3. Create an appealing title for your recipe.
        4. List all the ingredients needed for the recipe, including the ones provided and any additional ingredients required. Include approximate quantities for each ingredient.
        5. Write a set of clear, step-by-step instructions for preparing the dish. Be specific about cooking methods, temperatures, and times where applicable.
        6. (Optional) Add any relevant cooking tips or suggestions for variations of the recipe.
      PROMPT

      {
        model: "claude-2.1",
        prompt: "\n\nHuman: #{prompt} \n\nAssistant:",
        max_tokens_to_sample: 300,
        temperature: 0.8
      }
    end

    def recipe_check_request_payload(recipe)
      prompt = "Does the provided text include both a list of ingredients and step-by-step cooking instructions? Respond only with 'yes' or 'no': '#{recipe}'"

      {
        model: "claude-2.1",
        prompt: "\n\nHuman: #{prompt} \n\nAssistant:",
        max_tokens_to_sample: 10,
        temperature: 0.2
      }
    end

    def request_headers
      {
        "X-Api-Key" => @api_key,
        "Anthropic-Version" => ANTHROPIC_VERSION,
        "Content-Type" => "application/json"
      }
    end
  end
end
