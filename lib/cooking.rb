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

# un peu de json pour envoyer des informations directement à l'API
data = {
  "messages" => [{"role" => "system", "content" => "Je souhaite que tu affiche une recette de cuisine simple de manière aléatoire. Peux-tu me donner une liste de quelques ingrédients ainsi que les étapes à réaliser pour réussire ma recette ? Merci d'énumérer ta réponse avec un tiret devant chaque ingrédient & étape"}],
  "max_tokens" => 50,
  "temperature" => 0.5,
  "model" => "gpt-3.5-turbo"
}

# envoi de la requête à l'API OpenAI
response = HTTP.post(url, headers: headers, body: data.to_json)
response_body = JSON.parse(response.body.to_s)

# vérifier si la réponse est valide
if response_body.key?('choices') && response_body['choices'][0].key?('message') && response_body['choices'][0]['message'].key?('content')
  response_string = response_body['choices'][0]['message']['content'].strip

  # affichage du résultat
  puts "Voici 1 recette de cuisine aléatoire :"
  puts response_string
else
  puts "Erreur: la structure de la réponse est invalide."
end