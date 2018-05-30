# static_website_prod_deploy :zap:
This repo contains code snippets and scripts for easy deploy of static website.  
Snippets and scripts are suited for Windows environment.

# What is this? :icecream:

Using these tools you can push your static website code to server only with two commmands - 
`npm run build_prod`
and 
`npm run deploy`

> Why two but not one? Because sometimes there is need of checking builded code before pushing to production. If you do not have this need, > code can be easily modified for only one command to deploy.

# Let's drill one by one :flashlight:

## package.json
In this file we have two scripts which can be called via npm.  
  
First one is **build_prod**:  
Let's break the script into parts.  
* `del prod/q` - first we need to delete existing code from production directory before putting new one. *q* parameter used for not asking delete permission.  
* `html-minifier --collapse-whitespace src/index.html -o prod/index.html` - there is nothing much we can do with html, but still we can get rid of whitespace. Input is `src/index.html` and output `prod/index.html`. Output is being specified with -o flag.  
* `xcopy images prod\\images /Y` - to copy images from source folder to production we are using *xcopy* powershell utility. /y parameter supresses  confirmation prompt of destination files override.  
* `uglifyjs --compress --mangle -o prod/bundle.js -- dist/bundle.js` - to minify js we are using *uglifyjs* utility. Input is `dist/bundle.js` and output marked with the -o flag `prod/bundle.js`.
* `postcss src/styles.css > prod/styles.css` - to minify CSS we are using post css. Input is `src/styles.css` and output `prod/styles.css`.  
* `CALL prepare-html.bat` - calling powershell script which can be found in this repository, we will review it soon.  
  
Second script is **deploy**:  
It just simply call `deploy.bat` powershell script which sends our production directory content to server, we will review it in details soon.  

## prepare-html.bat  
This file used to change bundle.js script retrieving destination.  
Let's break down this script into parts.  
* `@echo OFF` - first we just turning off script output, we don't need it.  
* `pause` - pause before processing html file is required, because we need to give some time for html minification which is being done before running this script (commands in powershell are being run asynchronously). Pause just simply stops the script and wait for user input (any key).  
* `powershell -Command` - this statement is needed when running regular powershell commands in batch script. All powershell commands must be wrapped into double quotes.  
* `(Get-Content prod/index.html)` - we just simply getting content of index.html file of our production folder.  
* `-replace '/dist/bundle.js', 'bundle.js'` - replace flag receives two arguments separated by comma. First one is text to replace and second is substitude.  
* `| Out-File -encoding ASCII prod/index.html"` - we are using pipe to pass altered content to command `Out-File` which fills up specified file with input. Encoding set to ASCII to avoid possible errors.  
  
## deploy.bat
This script does two things - triggers backup in server and sends production files to server.  
Let's break this script into parts to get more perception about it.  
  
* `@echo OFF` - first just simply turning off the output.  
* `powershell -Command` - telling batch script that we are going to execute regular powershell commands.  
* `plink -ssh` - to execute commands remotely on the server we are using `plink` utility (it's putty for cmd). With -ssh flag we specifying that connection must be SSH protocol, this protocol is most secure and most convenient at the moment.  
* `-i D:\your\path\to\private\key\id_rsa.ppk` - with -i flag we are specifying private key for our SSH connection. Of course you can authenticate with password, but I prefer keys for security and convenience.  
* `-noagent` - this prevents opening putty client, we don't need to deal with GUI when we seek for most automated deploy process.  
* `root@11.111.111.11` - here we are specifying username of user for which we want to authenticate in the server, after @ symbol goes ip address of the server.  
Now we can specify commands for our remote server!  
* `/root/scripts/yourScriptInServer.sh yourwebsitename"` - here we just lauching our backup script located in the server and passing one parameter to it "yourwebsitename". If you want to know more about the script check out my other repository https://github.com/ignasposka/make_website_backup  
  
We still have second part of *deploy.bat* script, let's inspect it now.  
  
* `WinSCP.exe /console /script='D:\\your\\path\\to\\winscp\\script\\prod_to_server.txt'` - here we just using WinSCP utility which is ftp client for powershell. /console parameter is being used because we seek only for CLI solutions here. Here we just simply firing up script which does all the work of moving our production code to the server, we will review it shortly.  
  
## prod_to_server.txt  
This script connects to the server by SFTP protocol and transfers files from our local production folder to `/var/www/` of the server.  
Let's break it down to see what's happening.  
  
* `open sftp://root@11.111.111.11` - we are opening connection by SFTP protocol for server user `root` and server's ip address `11.111.111.11`.  
* `-privatekey=D:\your\path\to\private\key\id_rsa.ppk` - just simply specifying path to our private key for secure connection to server. If you authenticating with password key is not needed.  
* `-hostkey="*"` - hostkey is set to any, because I was facing the problems with WinSCP comparing the keys, more information about this issue can be found here: https://winscp.net/forum/viewtopic.php?p=83999#83999 . Anyway, in my case this is not security vulnerability, because code going over the wire is open source, published in github, **if your code is more confidential please consider this part as security vulnerability.**  
* `put "D:\your\path\to\folder\prod" /var/www/yourwebsite` - put command just simply sends content of your local folder to remote machine folder. First argument is local, second is remote.  
* `exit` - after transfering we closing SFTP connection.  

If you find any discrepancies, errors in readme or code, do not hesitate to make pull request or just reach out me with the comments.   Your help is highly appreciated. :heart:
