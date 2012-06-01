## BAMRU Private

This is the code for the BAMRU Private website.

## Maintaing and Contributing 

### Running the App

This app has been developed on Ubuntu 12.04.  It will probably
work on a Mac w/o changes.  It won't run on a vanilla PC, but
may work with Cygwin.

To run the app:
- ask Andy to send you the application datafiles
  - sqlite database
  - image directory
  - environment file 
- clone the app & install the datafiles
- edit database.yml to use sqlite
- run `bundle install`
- run `foreman start`
- run `rails server`

### Deploying the App

This app is built to use three deployment environments:
- vagrant - for development testing
- staging - for local integration testing
- production - the live system

Deploying to Vagrant:
- edit your Capfile to ensure the :proxy is set to 'vagrant'
- create and provision the VM using `vagrant up`
- setup ssh using `vagrant ssh-config >> ~/.ssh/config`
- add 'dns' lookup using `sudo echo '192.168.33.12 vagrant' >> /etc/hosts`
- setup the deploy directories using `cap at:setup`
- upload the database using `db/upload vagrant`
- upload the system file using `scp -r public/
- deploy the working system using `cap deploy`
- run the app dashboard using `cap at:console`

Deploying to Staging and Production: ask Andy for instructions

### Contributing to the App

Contributions are encouraged!
- fork the app
- clone & edit your fork
- make your edits in a separate branch
- include tests!
- send pull-requests to Andy

