$port = $config['port'] || 3333

$report_dir = 'robot/reports'
$test_dir = 'robot/tests'

config_path = "#{Rails.root}/config/robot.yml"
if File.exists?(config_path)
  File.open(config_path, 'r') do |file|
    $config = YAML::load(file)
  end
end

def start_rails_server(port, options = {})
  puts "Starting Rails"
  sh "RAILS_ENV=test rails server -d -p #{$port}"
rescue => e
  puts "Cannot start Rails: #{ e.message }"
end

def wait_for_server(port, timeout = 20)
  Timeout::timeout(timeout) do
    while true
      begin
        ::TCPSocket.new('127.0.0.1', port).close
        break
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
        # Ignore, server still not available
      end
      sleep 0.1
    end
  end

rescue Timeout::Error
  puts "Server startup failed"
  throw :task_has_failed
end


namespace :robot do
  desc "Prepare"
  task :prepare do
    $config['prepare'].each{ |k, v|
      puts "Preparing #{k}"
      sh "#{v}"
    }
  end

  desc "Start background services"
  task :setup => :prepare do
    $config['setup'].each{ |k, v|
      puts "Starting #{k}"
      sh "RAILS_ENV=test #{v}"
    }
  end

  desc "Start rails"
  task :start => :setup do
    begin
      start_rails_server($port)
      wait_for_server($port)
    rescue
      Rake::Task["robot:stop"].invoke
    end
  end

  desc "Stop background services"
  task :teardown do
    $config['teardown'].each{ |k, v|
      puts "Stopping #{k}"
      sh "RAILS_ENV=test #{v}"
    }
  end

  desc "Stop rails"
  task :stop => :teardown do
    rails_pid = File.read('tmp/pids/server.pid').to_i
    if rails_pid
      puts "Stopping rails with pid #{rails_pid}"
      Process.kill('TERM', rails_pid)
    end
  end

  desc "Run test cases using Robot Framework"
  task :run do
    Rake::Task["robot:start"].invoke
    begin
      sh "pybot -d #{$report_dir} #{$test_dir}/*.robot"
    ensure
      Rake::Task["robot:stop"].invoke
    end
  end
end
