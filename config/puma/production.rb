app_dir = File.expand_path("../../..", __FILE__)
puts app_dir
system 'mkdir -p tmp/sockets'
system 'mkdir -p tmp/pids'

_port = 9020 # ENV.fetch("PORT") { 3004 } TODO

puts "rails_env:" + ENV['RAILS_ENV'].to_s
puts "port:" + _port.to_s
port _port
environment "production"
# directory '/data/xxxx'

rackup "#{app_dir}/config.ru"

bind "unix://#{app_dir}/tmp/sockets/puma.sock"
pidfile "#{app_dir}/tmp/pids/puma.pid"
state_path "#{app_dir}/tmp/pids/puma.state"
stdout_redirect nil, "#{app_dir}/log/puma.stderr.log", true

# daemonize true
workers 1
threads 4, 32

preload_app!
# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
