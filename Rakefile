require 'rake'
require_relative 'config'
require_relative 'helpers'

$DIR = {}
$config = load_config('config.yml')

namespace :deploy do
  $config[:services].each do |service|
    desc "deploy #{service}"
    task service, [:env] do |_, args|

      config = $config[service]
      env = guess_env(args[:env])
      print_g "MODE: #{env}"
      accounts = config[env][:accounts]

      # Deploy the code
      dir = '/tmp/deploy'
      FileUtils.mkdir_p dir

      # Clone the project in dir
      Dir.chdir(dir) do
        branch = config[:branch]
        github = config[:github]
        cmd = "git clone #{github}"
        fail unless execute(cmd)

        # Stop all workers
        accounts.each do |account|
          fail unless heroku_command(account[:name], account[:apps], "ps:scale resque=0")

          account[:apps].each do |app|
            cmd = "git push #{app} #{branch}:refs/heads/#{branch}"
            fail unless execute(cmd)
          end

          fail unless heroku_command(account[:name], account[:apps], "ps:scale resque=1")
        end
      end
    end
  end
end

namespace :config do
  $config[:services].each.each do |service|
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
end

def stop_all_workers(accounts)

end

