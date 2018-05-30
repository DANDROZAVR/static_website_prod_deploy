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
Let's break up this script into parts.  
* `@echo OFF` - first we just turning off script output, we don't need it.  
* `pause` - pause before processing html file is required, because we need to give some time for html minification which is being done before running this script (commands in powershell are being run asynchronously). Pause just simply stops the script and wait for user input (any key).  
* `powershell -Command` - this statement is needed when running regular powershell commands in batch script. All powershell commands must be wrapped into double quotes.  
* `(Get-Content prod/index.html)` - we just simply getting content of index.html file of our production folder.  
* `-replace '/dist/bundle.js', 'bundle.js'` - replace flag receives two arguments separated by comma. First one is text to replace and second is substitude.  
* `| Out-File -encoding ASCII prod/index.html"` - we are using pipe to pass altered content to command `Out-File` which fills up specified file with input. Encoding set to ASCII to avoid possible errors.  


**...This readme is not finished yet...**
