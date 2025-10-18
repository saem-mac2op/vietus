# config/puma.rb

app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"

threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count
environment ENV.fetch("RAILS_ENV") { "production" }

pidfile "#{shared_dir}/tmp/pids/puma.pid"
state_path "#{shared_dir}/tmp/pids/puma.state"
stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

bind "unix://#{shared_dir}/tmp/sockets/puma.sock"

workers ENV.fetch("WEB_CONCURRENCY") { 2 }
preload_app!

plugin :tmp_restart
