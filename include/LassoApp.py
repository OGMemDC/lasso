from include.LassoConfiguration import LassoConfiguration

class LassoApp(object):
    is_lasso_initialized=False
    is_lasso_running=False
    lasso_error_stack=[]
    
    def __init__(self):
        pass 
    
    def Init(self):
        try:
            self.__configuration = LassoConfiguration.get_instance().initialize()
            self.is_lasso_initialized=True
        except:
            self.is_lasso_initialized=False
        
        return self.is_lasso_initialized
        
        @property
        def configuration(self):
            return LassoConfiguration.get_instance()
        
    
    def Run(self):
        print("Hello World from Lasso!")
