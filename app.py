#!/usr/bin/env python3
from include.LassoApp import LassoApp

def main():
    try:
        app = LassoApp()
        if app.Init() == True:
            app.Run()
            if app.is_lasso_running != True:
                print("failed to start lasso")
            else:
                print("started lasso")
        else:
            print("failed to initialize lasso")
    except:
        print("a fatal error has occured and was caught by the global exception handler in lasso. please check the lasso logs for more information.")
    finally:
        print("exiting lasso, goodbye!")
    

if __name__ == "__main__":
    main()
else:
    print("configuraiton error: missing __main__")
    
