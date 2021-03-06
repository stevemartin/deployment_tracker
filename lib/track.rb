$:.unshift File.dirname(__FILE__)
require 'sinatra'
require 'rugged'
require 'haml'
require 'active_support/core_ext'
require 'yaml'

@config = YAML.load_file(File.join(File.dirname(__FILE__), '../config.yml'))

get '/track_deploys' do
  @config = YAML.load_file(File.join(File.dirname(__FILE__), '../config.yml'))
  repo = Rugged::Repository.new(File.join(File.dirname(__FILE__), "#{@config["repo"]}_ready"))
  tags = repo.tags
  tag_groups = tags.group_by { |t| t.match(/deploy_\w*_/).to_s }
  tag_groups.delete("")
  last_tags = []
  tag_groups.keys.each { |k| last_tags << tag_groups[k].sort.last }
  @table_data = last_tags.compact.map do |tag|
    date = DateTime.parse(tag.match(/\d.*/).to_s)
    environment = tag.match(/deploy_(\w.*)_\d.*/)[1]
    [environment, date.strftime('%e %b %Y %H:%m:%S %p'), date]
  end
  haml :index

end

get '/status' do
  `cat #{File.join(File.dirname(__FILE__),'.updating_repo')}`
end

get '/updating.js' do
  File.read(File.join(File.dirname(__FILE__),'updating.js'))
end
