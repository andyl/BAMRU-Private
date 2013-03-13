Capistrano::Configuration.instance(:must_exist).load do

  # ----- keys -----
  before 'deploy:assets:precompile',  'keys:upload'

  namespace :keys do

    desc "upload keys"
    task :upload do
      if File.exist? ".rbenv-vars-private"
        txt = File.read(".rbenv-vars-private")
        put txt, "#{release_path}/.rbenv-vars-private"
      else
        puts " NOTICE - no private keyfile ".center(80, '*')
      end

    end

  end

end

