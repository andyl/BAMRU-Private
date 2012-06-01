## BAMRU Private

This is the code for the BAMRU Private website.

## Maintaing and Contributing 

### Running the App

This app has been developed on Ubuntu 12.04.  It will probably
work on a Mac w/o changes.  It won't run on a vanilla PC, but
may work with Cygwin.

To run the app:
- get the application datafiles from Andy (sqlite database, image directory, environment file)
- clone the app & install the datafiles
- edit database.yml to use sqlite
- run `bundle install`
- run `rails server`

### Deploying the App

This app is built to use three deployment environments:
- vagrant - for development testing
- staging - for local integration testing
- production - the live system

Deploying to Vagrant:
- edit your Capfile to set the stage to 'vagrant'
- create and provision the VM using `vagrant up`
- setup ssh using `vagrant ssh-config >> ~/.ssh/config`
- add 'dns lookup' using `sudo echo '192.168.33.12 vagrant' >> /etc/hosts`
- initialze the app using `cap ops:setup`
- upload the database using `cd db && upload vagrant`
- upload the image directory using `scp -r public/system vagrant:a/BAMRU-Private/public`
- deploy the working system using `cap deploy`
- run the app dashboard using `cap ops:console`

Deploying to Staging and Production: ask Andy for instructions

### Contributing to the App

Contributions are encouraged!
- fork the app
- clone & edit your fork
- make your edits in a separate branch
- include tests!
- send pull-requests to Andy

### License

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
