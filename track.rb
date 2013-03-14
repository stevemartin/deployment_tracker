require 'sinatra'
require 'rugged'
require 'haml'
require 'resque'
require './git_clone'
require './web-socket'


get '/track_deploys' do
  repo = Rugged::Repository.new('funding_circle_app_ready')
  tags = repo.tags
  tag_groups = tags.group_by { |t| t.match(/deploy_\w*_/).to_s }
  tag_groups.delete("")
  last_tags = []
  tag_groups.keys.each { |k| last_tags << tag_groups[k].sort.last }
  # tag_groups.to_s
  @table_data = last_tags.compact.map do |tag|
    date = tag.match(/\d.*/).to_s
    year, month, day, time = date[0..3], date[4..5], date[6..7], date[8..13]
    environment = tag.match(/deploy_(\w.*)_\d.*/)[1]
    [environment, [year, month, day, time]]
  end
  # table_data.to_s
  haml :index

end

get '/update_repo' do
  `echo 'updating' > .updating_repo`
  Resque.enqueue(GitClone)
end

get '/status' do
  `cat .updating_repo`
end

get '/updating.js' do
  File.read('updating.js')
end
