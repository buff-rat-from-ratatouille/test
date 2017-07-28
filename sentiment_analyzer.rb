require 'sentimental'
require 'monkeylearn'
class Analyzer
  def initialize
    Monkeylearn.configure do |c|
      c.token = "16c0a0d58f2072942e27a825cb95f978449d4c41"
    end
    $analyzer = Sentimental.new
    $analyzer.load_defaults
    $all_tweet_list = {}
    $neutral_tweet_list = {}
    $positive_tweet_list = {}
    $negative_tweet_list = {}
    $average_sentiment
    $total_score = 0
  end

  def monkey tweet_list
    puts "THIS IS MONKEY"
    puts "#{tweet_list}"
    tweet_list.each {|tweet|
      r = Monkeylearn.classifiers.classify('cl_qkjxv9Ly', [%{"#{tweet}"}], sandbox: true)
      analyze_monkey r.result
      puts "#{tweet} \n #{r.result}"}
  end
  def analyze_monkey result
    organize result, result["label"], result["probability"]
  end
#$analyzer.threshold = 0.0

  def analyze_sentiment tweet_list
    puts "THIS IS SENTIMENTAL"
    tweet_list.each {|tweet|
      #puts "#{tweet.full_text}"
      puts "#{tweet}"
      puts $analyzer.sentiment tweet
      puts $analyzer.score tweet
      organize tweet, $analyzer.sentiment(tweet).to_s, $analyzer.score(tweet)}
  end

#parse tweet and analysis for useful info
  def organize tweet, sentiment, score
    positive_tweet_list tweet, score if sentiment == "positive"
    negative_tweet_list tweet, score if sentiment == "negative"
    neutral_tweet_list tweet, score if sentiment == "neutral"
    all_tweet_list tweet, sentiment
    calculate_average_tweet_sentiment get_positive_tweet_list, get_negative_tweet_list, get_neutral_tweet_list
  end

#TODO make get all tweets method
  def all_tweet_list tweet, sentiment
    $all_tweet_list[tweet] = sentiment
  end
  def get_all_tweet_list
    $all_tweet_list
  end
#all the good tweets
  def positive_tweet_list tweet, score
    $positive_tweet_list[tweet] = score
    puts $positive_tweet_list
  end

  def get_positive_tweet_list
    return $positive_tweet_list
  end

#gather all the bad tweets
  def negative_tweet_list tweet, score
    $negative_tweet_list[tweet] = score #should these be hashmaps
    puts $negative_tweet_list
  end

  def get_negative_tweet_list
    return $negative_tweet_list
  end

#all the neutral tweets
  def neutral_tweet_list tweet, score
    $neutral_tweet_list[tweet] = score
    puts $neutral_tweet_list
  end

  def get_neutral_tweet_list
    return $neutral_tweet_list
  end

  def calculate_average_tweet_sentiment positive_list, negative_list, neutral_list

    positive_list.each {|tweet, score|
      $total_score = $total_score+score}
    negative_list.each {|tweet, score|
      $total_score = $total_score+score}
    neutral_list.each {|tweet, score|
      $total_score = $total_score+score}
    number_of_tweets = positive_list.length + negative_list.length + neutral_list.length
    $average_sentiment = $total_score/number_of_tweets
    puts "THE AVERAGE SENTIMENT IS: #{$average_sentiment}"
  end

#average rating of tweets
  def get_average_tweet_sentiment tweet, score
    $average_sentiment
  end
end
