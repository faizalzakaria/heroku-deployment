require 'rake'
require_relative 'config'
require_relative 'lib/helpers'

$DIR = {}
$config = load_config('config.yml')

namespace :deploy do
  $config[:tasks].each do |service|
    service = service.to_sym
    desc "deploy #{service}"
    task service, [:env] do |_, args|

      config = $config[service]
      env = guess_env(args[:env])
      print_g "MODE: #{env}"
      accounts = config[env][:accounts]

      # Deploy the code
      dir = '/tmp/deploy'
      project_dir = "#{dir}/#{service}"
      FileUtils.rm_rf(dir)
      FileUtils.mkdir_p dir

      # Clone the project in dir
      Dir.chdir(dir) do
        branch = config[:branch]
        github = config[:github]

        unless File.directory?(project_dir)
          cmd = "git clone #{github} #{service}"
          fail unless execute(cmd)
        end

        Dir.chdir(project_dir) do

          # Stop all workers
          accounts.each do |account|
            account[:apps].each do |app|
              cmd = "git pull"
              execute(cmd)

              cmd = "git remote add #{app} git@heroku.com:#{app}.git"
              execute(cmd)
              fail unless heroku_switch(account[:name])

              cmd = "git push #{app} #{branch}:refs/heads/#{branch} -f"
              fail unless execute(cmd)
            end
            fail unless heroku_stop_apps(account[:name], account[:apps], config[:scales])
            fail unless heroku_start_apps(account[:name], account[:apps], config[:scales])
          end
        end
      end
      FileUtils.rm_rf(dir)
    end
  end
end

namespace :config do
  $config[:tasks].each do |service|
    service = service.to_sym
    desc "config for #{service}"
    task service, [:env] do |_, args|

      config = $config[service]
      env = guess_env(args[:env])
      print_g "MODE: #{env}"
      accounts = config[env][:accounts]

      accounts.each do |account|
        fail unless heroku_command(account[:name], account[:apps], :config)
      end
    end
  end

  namespace :set do
    $config[:tasks].each do |service|
      service = service.to_sym
      desc "config for #{service}"
      task service, [:env] do |_, args|

        config = $config[service]
        env = guess_env(args[:env])
        print_g "MODE: #{env}"
        accounts = config[env][:accounts]

        def envs(envs)
          output = ""
          return output if envs.nil?
          envs.each_pair do |key, val|
            output << " #{key}=\"#{val}\""
          end
          output
        end

        accounts.each do |account|
          fail unless heroku_command(account[:name], account[:apps], "config:set #{envs(config[env][:envs])}")
        end
      end
    end
  end
end

[:stop, :start, :restart, :status].each do |action|
  namespace action do
    $config[:tasks].each do |service|
      service = service.to_sym

      desc "#{action} for #{service}"
      task service, [:env] do |_, args|
        config = $config[service]
        env = guess_env(args[:env])
        print_g "MODE: #{env}"
        accounts = config[env][:accounts]

        accounts.each do |account|
          fail unless heroku_stop_apps(account[:name], account[:apps], config[:scales]) if action == :stop || action == :restart
          fail unless heroku_start_apps(account[:name], account[:apps], config[:scales]) if action == :start || action == :restart
          fail unless heroku_command(account[:name], account[:apps], "ps") if action == :status
        end
      end
    end
  end
end
