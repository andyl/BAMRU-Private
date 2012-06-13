Capistrano::Configuration.instance(:must_exist).load do
  
  after "deploy:update", "railsenv:update"

  namespace :railsenv do

    desc "Update .rbenv-vars to include the current environment"
    task :update do
      run <<-END
        cd #{release_path}
        if [ -f .rbenv-vars] ; then
          cat .rbenv-vars | sed -e s/RAILS_ENV=development/RAILS_ENV=#{rails_env}/g > /tmp/vars ;
          mv /tmp/vars .rbenv-vars ;
        fi
      END
    end

  end

end

