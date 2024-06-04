-- 1683. Invalid Tweets
select distinct tweet_id from tweets where length(content) > 15
