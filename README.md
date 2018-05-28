# static_website_prod_deploy :zap:
This repo contains code snippets and scripts for easy deploy of static website.  
Snippets and scripts is suited for Windows environment.

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
del prod/q - first we need to delete existing code from production directory before putting new one.

**...This readme is not finished yet...**
