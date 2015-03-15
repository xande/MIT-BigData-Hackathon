
require 'rubygems'

require 'pismo'
require 'uri'
require 'indico'
require 'json'
require 'curl'
require 'google-search'
require 'csv'

KEY_WORD = 'Ukraine' # 
ROSETTE_API_KEY = 'cc31795098e06510e955a47253798cda'

##
# search_news method searches news on Google for the last week using specified keyword.
# It returns an array of news URLs along whith the dates when those where published.
#
# = Example
# search_news('Ukraine')

def search_news(key)
	 queue = []

	 Google::Search::News.new(:query => key, :tbs => 'sbd:1,qdr:w', 'tbm' => 'nws').each do |s|
	    queue.push({:url => s.uri, :date_published => s.published})
	  end
	  queue
end

##
# parse_articles method takes an array of URLs and fetches theirs content. Then, using Pismo gem it extracts news body
# and other article attributes such as Title and Author. 
#
# The method returns an array of parsed articles along whith the dates when those where published.
#

def parse_articles(queue)
	articles = []
	queue.each do |item|
		begin
			doc = Pismo::Document.new(item[:url])
		rescue
			# no error handling here, sorry 8)
		end

		# Save result for further processing if article was succesfully parsed and body length is more than 200 characters
		if doc 
			print '.'
			articles.push({:article => doc, :date_published => item[:date_published]}) if doc.body.length > 200
		else
			print '!'
		end
	end
    puts ""

	articles
end

##
# rosette_sentiment uses Rosette API by Basis Technology (http://www.basistech.com/text-analytics/rosette/) to get
# sentiment score for the provided article
#

def rosette_sentiment(article) 
	req = {'content' => article}
	c = Curl::Easy.http_post("https://api.rosette.com/rest/v1/sentiment", req.to_json) do |http|
		http.headers['user_key'] = ROSETTE_API_KEY
		http.headers['Accept'] = 'application/json'
		http.headers['Content-Type'] = 'application/json'
	end

	response = JSON.parse(c.body_str)

	if response && response['sentiment']
		pos_confidence = response['sentiment'].select {|s| s["label"] == 'pos' }
	end

	pos_confidence ? pos_confidence[0]['confidence'] : nil
end

puts "Serching for #{KEY_WORD}-related articles on Google News..."
url_queue = search_news(KEY_WORD)
puts "Fetching and parsing articles..."
articles = parse_articles(url_queue)

results = []

puts "Running sentiment analysis for the articles..."
articles.each do |a|
	puts "===================="
	puts a[:article].title
	puts a[:date_published]
	puts a[:article].url

	indico_sentiment = Indico.sentiment(a[:article].body) # Calling Indico API to get the score http://indico.readme.io/v1.0/docs/sentiment
	rosette_sentiment = rosette_sentiment(a[:article].body) # Getting Basis Tech sentiment score

	puts "* indico sentiment score: " + indico_sentiment.to_s
	puts "* rosette sentiment score: " + rosette_sentiment.to_s

	results.push([a[:article].title, 
				  a[:date_published], 
				  a[:article].url, 
				  indico_sentiment,
				  rosette_sentiment])

end

puts "Saving results.csv ..."
CSV.open("output/results.csv", "wb") do |csv|
  csv << ['title', 'date', 'url', 'indico_sentiment', 'roseta_sentiment']
  results.each {|r| csv << r}
end

puts "DONE."


