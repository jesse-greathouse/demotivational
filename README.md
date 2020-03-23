Demotivational
====
A simple demonstration of how to integrate google and facebook Oauth2 login functionality.

# How to Install
* Download the git repository
*  `git clone https://github.com/jesse-greathouse/demotivational`
* Change to the demotivational directory
*  `cd demotivational`

## Docker Installation
* The easiest way to run the application is with Docker. If you don't have Docker installed You will need to install docker on your host. Check the [Official Docker Site](https://docs.docker.com/engine/installation/) on how to install Docker on your host.
* Run the configuration script
	*  `bin/configure-docker.sh`
		* The configuration script is interactive.
		* Leave the options blank if you don't want to change them
![Interactive configuration](https://i.imgur.com/1iP0rBY.png)
		* For this demonstration, I have created defaults for the google and facebook key strings, if you leave them blank, they will revert to safe defaults.
![leave things blank to accept the default](https://i.imgur.com/Bun5Udk.png)
		* Once you have the proper configuration, press Y to accept
* Run the "run" script
	*  `bin/run-docker.sh`
* check [http://localhost:3000/](http://localhost:3000/)
	* You may have changed the designated port during configuration. If that's the case, use the port you specified.

### Don't want to use Docker?
Alternatively there are scripts to install the application, directly, on OSX or Linux brands.
* Check the bin/ folder for an installation script on your platform
* e.g.: bin/install-osx.sh

# Using the application

## Login
When you first load the application in your web browser, it will redirect you to the /login screen because you do not yet have a session token.
![login screen](https://i.imgur.com/Q68drBa.png)

When you select a provider a pop-up window will direct you to login at the provider of your choice.
 - Please disable pop-up blockers for the purpose of this demonstration

## Main Screen
Once you have logged in, the application will redirect you to the home page. A search will be conducted in the Google API, and a random demotivational image will be selected just for you!
![demotivational image](https://i.imgur.com/aZ4NgMM.png)

## Logout
When you press the logout button, you will be taken to the logout screen. Not much can be said about this. It will simply destroy your session and redirect you to the login page.
![logout](https://i.imgur.com/XogkeC6.png)

# The Code
## Openresty
 - The application uses a framework called [Openresty.](https://openresty.org/en/) 
 - It puts [Nginx](https://www.nginx.com/) together with [LuaJIT](https://luajit.org/) to allow powerful [Lua](https://www.lua.org/about.html) scripting from directly inside the Nginx workers.
 - You can see from the source code [of this file](https://github.com/jesse-greathouse/demotivational/blob/master/etc/nginx/nginx.dist.conf#L136) that this enables Lua scripting in the Nginx configuration.
 - ![Lua code in the Nginx configuration](https://i.imgur.com/GA8yHUj.png)
 
 ## The Views
 - Under [src/jgreathouse/demotivational/views.lua](https://github.com/jesse-greathouse/demotivational/blob/master/src/jgreathouse/demotivational/views.lua) I have created methods for generating the application's views.
 - I have created functions for handling [sessions](https://github.com/jesse-greathouse/demotivational/blob/master/src/jgreathouse/demotivational/views.lua#L10).
 - I have also created endpoints for handling authentication via [google](https://github.com/jesse-greathouse/demotivational/blob/master/src/jgreathouse/demotivational/views.lua#L79) or [facebook](https://github.com/jesse-greathouse/demotivational/blob/master/src/jgreathouse/demotivational/views.lua#L103).

## The Models
 - When the application receives authentication information, about the [user](https://github.com/jesse-greathouse/demotivational/blob/master/src/jgreathouse/demotivational/models.lua#L11) and the user's [token](https://github.com/jesse-greathouse/demotivational/blob/master/src/jgreathouse/demotivational/models.lua#L21), it creates models of those domain objects, and saves them to the session.
 - Because there are two available authentication providers, the application also uses [adapters](https://github.com/jesse-greathouse/demotivational/blob/master/src/jgreathouse/demotivational/adapters.lua) to conform the provider's domain models to its native domain models.

## The Templates
 - The application uses a templating library made by [Bungle](https://github.com/bungle/lua-resty-template)
 - The template files can be found under the [web/](https://github.com/jesse-greathouse/demotivational/tree/master/web) folder. There is a layout, and a simple content template for every view. [It's fairly standard](https://github.com/jesse-greathouse/demotivational/blob/master/web/index.html) just like other templating engines.

## The UI
 - The UI uses standard [jQuery](https://jquery.com/) and [Bootstrap](https://getbootstrap.com/) assets. I chose these UI tools because they can be accessed by a CDN and they aren't demanding in terms of setup.
 - I have also included the standard JavaScript SDK's for [Google](https://developers.google.com/identity/sign-in/web/sign-in) and [Facebook](https://developers.facebook.com/docs/facebook-login/web/) Oauth2.
 - The JavaScript code that I used to handle this functionality was very boilerplate, taken directly from the docs of the respective SDKs.
 - The method of Authentication is all on the front end. Once the front-end receives authentication information from the provider, the application signals that information to the back-end with xhr calls to the handler endpoints.
 - ![UI authentication handling](https://i.imgur.com/wzJ2sgy.png)
