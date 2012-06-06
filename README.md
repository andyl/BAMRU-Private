## BAMRU Private

This is the code for the BAMRU Private website.

## Maintaing and Contributing 

### Bootstrap & Run in Development Mode

This app has been developed on Ubuntu 12.04.  It will probably work on a Mac.
It won't run on a vanilla PC, but may work with Cygwin.

To bootstrap the app:
- get the application datafiles from Andy (database, image directory, environment file)
- clone the repo & install the datafiles
- install postgres and/or sqlite
- edit database.yml to use the appropriate database engine
- run `bundle install`

To run the app in development:
- run `rails server` to run just the web app
- run `foreman -p 3000 -e .rbenv-vars` to run the full stack 

### Provisioning a Server

We use a combination of shell scripts and Puppet manifests to auto-configure
the staging and production servers.  Main elements of the stack include:
- nginx - reverse proxy
- passenger-standalone - web server
- monit - monitoring and alerting
- upstart - application init and auto-restart on failure
- foreman - process initiation
- postgres - database
- queue-classic - background job manager
- faye - ruby/javascript pub-sub
- rbenv - ruby version manager

See the Vagrantfile and the "bootstrap-base" shell script to learn how
auto-provisioning is done.

### Deploying the App

This app is built to use four deployment environments:
- vagrant - for development (requires vagrant/virtualbox)
- devstage - local staging server for integration testing
- pubstage - public staging server for integration testing
- production - the live system

Deploying to Vagrant:
- edit your Capfile to set the default stage to 'vagrant'
- create and provision the VM using `vagrant up`
- setup ssh using `vagrant ssh-config >> ~/.ssh/config`
- add 'dns lookup' using `sudo echo '192.168.33.12 vagrant' >> /etc/hosts`
- initialze the app using `cap deploy:setup ; cap deploy:cold`
- upload the image directory using `cap data:upload:sysdir`
- upload the database using `cap data:upload:db`
- import the database using `cap data:import:db`
- deploy the working system using `cap deploy`
- run a tmux-dashboard using `cap ops:console`

Deploying to Staging and Production: ask Andy for instructions

### Git Organization

The Git repo is organized to roughly follow the 
[nvie guidelines](http://nvie.com/posts/a-successful-git-branching-model/).

Main Branches:
- master - used for production deploy
- dev    - default branch for vagrant & staging deploys
- dev-feature - feature branch

### Contributing to the App

Contributions are encouraged!
- fork the app
- clone & edit your fork
- make your edits in a separate development branch
- include tests!
- send pull-requests to Andy

## License

Copyright (c) 2011-2012 Andy Leak 

Permitted Use

Permission is hereby granted, free of charge, to any BAMRU member obtaining a
copy of this software and associated documentation files (the "Software"), to
deal in the Software for non-commercial purposes associated with BAMRU
adminstration and operations.  Within this context, the rights to use, copy,
modify, merge, publish, and distribute are provided, subject to the following
conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Non-Permitted Use

Non-Permitted Use is any use of the Software for purposes other than BAMRU
administration and operations.  For Non-Permitted Use, rights to copy, modify,
distribute, or reuse the Software are denied.  For all Uses, rights to
sublicense and/or sell copies of the Software, to permit persons to whom the
Software is furnished to do so, or to create derivitave works, whether
commercial or non-commercial, are denied.
