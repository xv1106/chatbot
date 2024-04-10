# ligne très importante qui appelle les gems.
require 'http'
require 'json'
require 'dotenv'
Dotenv.load('.env')

# création de la clé d'api et indication de l'url utilisée.
api_key = ENV["OPENAI_API_KEY"]
url = "https://api.openai.com/v1/chat/completions"

# un peu de json pour faire la demande d'autorisation d'utilisation à l'api OpenAI
headers = {
  "Content-Type" => "application/json",
  "Authorization" => "Bearer #{api_key}"
}

# boucle principale
loop do
  # demande à l'utilisateur de saisir un message
  puts "Entrez votre message (ou 'stop' pour arrêter) :"
  user_input = gets.chomp

  # vérifier si l'utilisateur veut arrêter
  break if user_input.downcase == 'stop'

  # envoyer la demande à l'API OpenAI
  data = {
    "messages" => [{"role" => "user", "content" => user_input}],
    "max_tokens" => 50,
    "temperature" => 0.5,
    "model" => "gpt-3.5-turbo"
  }
  response = HTTP.post(url, headers: headers, body: data.to_json)
  response_body = JSON.parse(response.body.to_s)

  # vérifier si la réponse est valide
  if response_body.key?('choices') && response_body['choices'][0].key?('message') && response_body['choices'][0]['message'].key?('content')
    response_string = response_body['choices'][0]['message']['content'].strip

    # affichage de la réponse
    puts "Réponse de l'IA :"
    puts response_string
  else
    puts "Erreur: la structure de la réponse est invalide."
  end
end

puts "conversation terminée."
