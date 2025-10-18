rails_env = "production"
environment rails_env

app_dir = File.expand_path("../../..", __FILE__)	# /home/deploy/vietus

bind  "unix://#{app_dir}/shared/tmp/sockets/puma.sock"
pidfile "#{app_dir}/shared/tmp/pids/puma.pid"
state_path "#{app_dir}/shared/tmp/pids/puma.state"
directory "#{app_dir}"

stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

workers 1
threads 1,2

daemonize true

activate_control_app "unix://#{app_dir}/pumactl.sock"

prune_bundler
