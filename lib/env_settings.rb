BNET_ENVIRONMENT_FILE = '/home/aleak/.bnet_environment.yaml'

abort "MISSING ENVIRONMENT FILE" unless File.exist?(BNET_ENVIRONMENT_FILE)

yaml_env = YAML.load(File.read(BNET_ENVIRONMENT_FILE))

GOOGLE_CONSUMER_KEY    = yaml_env[:google_consumer_key]
GOOGLE_CONSUMER_SECRET = yaml_env[:google_consumer_secret]
FAYE_TOKEN             = yaml_env[:faye_token]
FAYE_SERVER            = yaml_env[:faye_server]
GMAIL_USER             = yaml_env[:gmail_user]
GMAIL_PASS             = yaml_env[:gmail_pass]