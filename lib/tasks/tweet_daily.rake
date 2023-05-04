namespace :tweet_daily do
  desc "Tweet twice a day"
  task :start_tweeting_loop => :environment do
    BotController.new.start_tweeting_loop
  end
end