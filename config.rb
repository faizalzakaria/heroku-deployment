
# Load YAML file

require 'yaml'

def config_file_missing
  msg = "\033[1;31m\nConfig file is missing\n"
  msg += "Please do as below :\n"
  msg += "cp config.yml.sample config.yml\n\n\033[0m"
  msg
end

def load_config(config_file)
  fail config_file_missing unless File.exist? config_file
  $config = YAML.load(File.read(config_file))
end
