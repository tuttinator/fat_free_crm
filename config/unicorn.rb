app_path  = File.expand_path(File.join(File.dirname(__FILE__), ".."))
# not in the /current symlink, so it's relative path is ../../.. to shared
pids_path = File.expand_path(File.join(File.dirname(__FILE__), "../../../shared/pids"))

listen "#{pids_path}/unicorn.sock" # by default Unicorn listens on port 8080
worker_processes 2 # this should be >= nr_cpus
pid "#{pids_path}/unicorn.pid"
stderr_path "#{app_path}/log/unicorn.error.log"
stdout_path "#{app_path}/log/unicorn.log"


# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30


# Preload our app for more speed
preload_app true


before_fork do |server, worker|
  # Disconnect since the database connection will not carry over
  if defined? ActiveRecord::Base
    ActiveRecord::Base.connection.disconnect!
  end

  # Quit the old unicorn process
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  # Start up the database connection again in the worker
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
