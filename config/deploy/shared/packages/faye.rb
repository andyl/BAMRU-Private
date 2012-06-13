Capistrano::Configuration.instance(:must_exist).load do
  
  after "keys:upload", "faye:update"

  namespace :faye do

    desc "Update .rbenv-vars with the faye server"
    task :update do
      run <<-END
        cd #{release_path}
        if [ -f .rbenv-vars-private] ; then
          cat .rbenv-vars | sed -e s/localhost:9292/#{vhost_names.first}:9292/g > /tmp/vars ;
          mv /tmp/vars .rbenv-vars-private ;
        fi
      END
    end

  end

end
