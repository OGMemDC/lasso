# Lasso
##
![lasso logo](https://github.com/OGMemDC/lasso/blob/main/include/lasso.png)
###
[Overview](#overview)  
[Installation instructions](#installing-lasso)  
[Directory and File Structure](#directory-and-file-structure)  
[Running Lasso](#running-lasso)  
###
##
## Overview
Lasso is a utility that uses dorking to build a list of target urls which can be fed into other systems for further investigation.

Lasso uses multiple methods to avoid detection by search engines such as rotating socks5 proxy requests, the tor network, and using search engine APIs. It willrotate through different techniques for avoiding detection, making it nearly impossible to be detected if used properly.

Lasso was developed on and for Ubuntu/Linux. It's possible to be run on other platforms but I have no need or interest in developing installation scripts to do so, if someone else does please do contribute back to the community.

The current application is an interactive terminal, meant to be part of a toolchain for pentesters and red teamers. By itself the tool does not do much as it doesnt actually execute any validation that the target urls are vulnerable.

In future releases my goal is to first allow the application to be run by command line arguments so that it can be called via an automation framework and could complete without any interaction from the user.

Eventually I would like to start adding in actually sending payloads to the target urls and to validate vulnerabilities. But for the moment my immediate need was to develop a solution that gathered the target urls.

Anyone who wishes to contribute, your desire to do so is welcomed and encouraged, please contact me, sending samples of your ideas and if I like them I will add you to the github repos.

**I claim no responsiblities if you use this application with nefarious intent, you are responsible for your own actions and anything that may occur from choosing to do so.**

This application is free to use by anyone and without any compensation made to me, but, as such, no support in doing so will be provided, you are free to email me at [bitbltog] at proton dot me (remove square brackets and spaces and replace the word dot with a '.', I shouldnt have to explain this but automated email scrapers really suck ass and I hate spam) and I may or may not respond to your email, if I do respond, I cant promise it will be the response you were hoping for.


*Do not believe in the collective wisdom of individual ignorance,*  

**O.G. BitBlt** - December 2025  

## Installing Lasso
1. Download the latest stable release: `TODO: insert command`
2. Uncompress it: `tar -xvf TODO: downloaded file`
3. Run the configuration script `setup/configure.sh`  
   - This will generate a bunch of scripts in the setup directory. You should look over them and modify as you wish prior to installing.  
   - `env-setup.sh`, sets required environmental variables  
   - `dependencies-check.sh`, installs python3, pip, curl, etc if missing 
   - `system-check.sh`, creates install directories and copies files to them, creates the symbolic link lasso at a location on your path, creates the folders for storing lists, and finally generates the desktop file and installs it if you wish.  
4. When happy with the above scripts run `sudo ./install.sh` to finalize install  
## Directory and File Structure
### Below is a summary of directories / files for a typical installation:
```
/opt/ or ~/.local/
    |
    -> lasso/
        |
        -> *version*/
            app.py             :   main app script
            bootstrap.py       :   handles auto-updates
            -> inc/               :   core lasso code
            -> mod/               :   plug-in code
            -> lists/             :   stores lists used by lasso
                dorks           :   stores lists of dorks
                proxies         :   stores generated proxy lists
                target-urls     :   stores the discovered urls
/etc
    |
    -> lasso/
        |
        -> *version*/
            lasso-conf.json    :   global configuration file, you can copy this
                                file to the same directory as app.py or to
                                ~/.local/lasso/*version*/, the application
                                will read the one in /etc first, overwriting
                                it with anything from the other configuration
                                files. The one stored in your home directory
                                is the final one.
            last-update.txt    :   The date that bootstrap last checked for a new
                                release from github. It checks once a week,
                                but you can delete this file and it will check
                                the next time you launch the application.
/usr/ or ~/.local/
    |  
    -> bin/
        lasso            :   this is a shell script that runs app.py
    |
    -> share/applications/
        lasso.desktop    :   the desktop file for integrating into ubuntu
                                applications menu
```
## Running Lasso
Enter `lasso` hit enter then follow the prompts.

