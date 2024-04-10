# ligne très importante qui appelle les gems.
require 'http'
require 'json'
require 'dotenv'
Dotenv.load('.env')

def converse_with_ai(api_key, conversation_history)
  url = "https://api.openai.com/v1/chat/completions"

  # un peu de json pour faire la demande d'autorisation d'utilisation à l'api OpenAI
  headers = {
    "Content-Type" => "application/json",
    "Authorization" => "Bearer #{api_key}"
  }

  puts "Entrez votre message (ou 'stop' pour arrêter) :"
  user_input = gets.chomp

  # vérifier si l'utilisateur veut arrêter
  return if user_input == 'stop'

  data = {
    "messages" => conversation_history + [{"role" => "user", "content" => user_input}],
    "max_tokens" => 500,
    "temperature" => 0,
    "model" => "gpt-3.5-turbo"
  }
  response = HTTP.post(url, headers: headers, body: data.to_json)
  response_body = JSON.parse(response.body.to_s)

  # vérifier si la réponse est valide
  if response_body.key?('choices') && response_body['choices'][0].key?('message') && response_body['choices'][0]['message'].key?('content')
    response_string = response_body['choices'][0]['message']['content'].strip

    # affichage de la réponse
    puts "Réponse de mon super bot :"
    puts response_string

    # appeler récursivement pour continuer la conversation
    converse_with_ai(api_key, data['messages'])
  else
    puts "Erreur: la structure de la réponse est invalide."
  end
end

# méthode pour commencer la conversation
def start_conversation(api_key)
  puts "Appuie sur Entrée pour démarrer la conversation avec mon super bot:"
  initial_input = gets.chomp
  return if initial_input.downcase == 'stop'

  # appel de la méthode converse_with_ai pour commencer la conversation
  converse_with_ai(api_key, [{"role" => "system", "content" => initial_input}])
end

# démarrer la conversation en appelant la méthode start_conversation
start_conversation(ENV["OPENAI_API_KEY"])

puts "Conversation terminée."
