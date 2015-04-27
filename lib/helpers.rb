# Helper methods

def trace_print(msg)
  puts "\033[1;32m[DEBUG]\033[0m #{msg}" if Rake.application.options.trace
end

def execute(cmd)
  trace_print cmd
  system cmd
end

def save_yaml(config_file, yaml_data)
  File.open(config_file, 'w') do |out|
    YAML.dump(yaml_data, out)
  end
end

def heroku_command(account_name, apps, command)
  apps.each do |app|
    cmd = "heroku #{command} --app #{app} --account #{account_name}"
    execute cmd
  end
end

def heroku_build_ps_scale(scales, command)
  scales.inject('') { |m, v| m << "#{v}=#{command} " }
end

def heroku_stop_apps(account_name, account_apps, scales)
  heroku_command(account_name, account_apps, "ps:scale #{heroku_build_ps_scale(scales, '0')}")
end

def heroku_start_apps(account_name, account_apps, scales)
  heroku_command(account_name, account_apps, "ps:scale #{heroku_build_ps_scale(scales, '1')}")
end

def heroku_switch(name)
  cmd = "heroku accounts:set #{name}"
  execute cmd
end

def guess_env(env)
  env ||= :default
  env = env.downcase.to_sym
  case env
  when :p, :prod, :production
    :production
  when :s, :stage, :staging
    :staging
  else
    :staging
  end
end

def print_color(color, msg)
  print "\033[1;#{color}m #{msg} \033[0m\n"
end

def print_g(msg)
  print_color("32", msg)
end

def print_r(msg)
  print_color("31", msg)
end

def print_y(msg)
  print_color("33", msg)
end
