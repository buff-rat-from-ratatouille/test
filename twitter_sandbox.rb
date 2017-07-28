require 'twitter'
require 'yaml'
class Twitter_Scraper
  def initialize
    $client = Twitter::REST::Client.new do |config|
      config.consumer_key = "EE00gnUP1WcuqPHfuw9b1QCMt"
      config.consumer_secret = "WSI4ik3vaGpeH2XS64N93sGkl9ltMuP19MLyWymmMKP88nN0Ct"
      config.access_token = "890575433229639682-SURFyElx3x24YArVZakUMYv5nLWFyGM"
      config.access_token_secret = "m7lROYo5N5oFDOjSsAAQZS5HNUHGsMfcJiQijeMtqTany"
    end
  end

  puts "hello"
#get_tweets_from_user "buff_rat"

  def make_a_tweet tweet_text
    $client.update("#{tweet_text}")
  end

  def scrape_tweets keyword, how_many_tweets
    puts "Searching for references to #{keyword}"
    tweet_list=[]
    $client.search(%{# "#{keyword}"}).take(10).each do |tweet|
      tweet_list << tweet.full_text
      #puts tweet.full_text
    end
    tweet_list
  end

  def get_tweets_from_user user
    tweets = $client.user_timeline("#{user}")
    tweet_list = []
    tweets.each {|tweet|
      tweet_list << tweet.full_text}
      #puts tweet.full_text}
    tweet_list
  end

  def see_recent_mentions
    tweet_list = []
    $client.search("to:vanguard_group", result_type: "recent").take(40).collect do |tweet|
      puts "#{tweet.user.screen_name}: #{tweet.text}"
      tweet_list << tweet.text
    end
    tweet_list
  end
end
#get_tweets_from_user "buff_rat"
#puts $client.status(167309659198328832).text
#$client.follow("bunglez988")
