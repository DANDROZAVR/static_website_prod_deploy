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

**...This readme is not finished yet...**
