## Setup

copy config.yml.dist to config.yml and update it to use the settings you want

rackup -p 4567 -D
ruby deploy_track_socket.rb start
