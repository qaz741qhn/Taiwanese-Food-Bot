class BotController < ApplicationController
  # Authenticate with Twitter API using your API keys and access tokens
  def twitter_client
    @twitter_client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_API_KEY']
      config.consumer_secret     = ENV['TWITTER_API_KEY_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
  end

  # Get a random Taiwanese food photo and description from a website
  def get_random_taiwanese_food
    cx = ENV['GOOGLE_SEARCH_ENGINE_ID']
    api_key = ENV['GOOGLE_CUSTOM_SEARCH_API_KEY']

    uri = URI("https://www.googleapis.com/customsearch/v1?q=taiwanese+food&cx=#{cx}&key=#{api_key}&searchType=image")
    response = Net::HTTP.get(uri)

    result = JSON.parse(response)

    # select random image from results
    num_results = result['items'].length
    random_index = Random.rand(num_results)
    random_image = result['items'][random_index]

    # get image URL and description
    image_url = random_image['link']
    image_description = random_image['title']

    { image_url: image_url, description: image_description }
  end

  # Tweet a random Taiwanese food photo and description
  def tweet_taiwanese_food
    food = get_random_taiwanese_food
    # tweet = "🍴 #{food['description']} #TaiwaneseFood #TaiwanFood #台灣美食"
    test_tweet = "Test tweet! #{Time.zone.now}"
    twitter_client.update(test_tweet)
  end

  # Tweet twice a day
  def start_tweeting_loop
    loop do
      tweet_taiwanese_food
      sleep(12.hours)
    end
  end

end