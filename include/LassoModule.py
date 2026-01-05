import os
class LassoModule:
    def __init__(self, name,filename,version,execby = "python3"):
        self.name = name
        self.filename = filename
        self.version = version
        self.execby = execby

    def get_name(self):
        return self.name

    def get_filename(self):
        return self.filename

    def get_version(self):
        return self.version

    def get_execby(self):
        return self.execby
    
class LassoModuleFactory:
    module_load_path = "undefined"
    
    @staticmethod 
    def get_module_load_paths():
        if (LassoModuleFactory.module_load_path == "undefined"):
            LassoModuleFactory.module_load_path = os.path.join(os.getcwd(), "modules")
        return LassoModuleFactory.module_load_path.split(";")
    
    @staticmethod
    def create_module(name, filename, version, execby = "python3"):
        return LassoModule(name, filename, version, execby) 
    
    @staticmethod
    def to_json(module:LassoModule):
        return {
            "name": module.get_name(),
            "filename": module.get_filename(),
            "version": module.get_version(),
            "execby": module.get_execby()
        }
    
    @staticmethod 
    def from_json(data):
        return LassoModule(
            data["name"],
            data["filename"],
            data["version"],
            data.get("execby", "python3")
        )
        
class LassoModuleLoader:
    loaded_modules = {}
    @staticmethod
    def load_all_modules(module_list):
        for module in module_list:
                LassoModuleLoader.load_module(module)
        return LassoModuleLoader.loaded_modules   

    @staticmethod
    def load_module(module:LassoModule):
        if(module.get_name() in LassoModuleLoader.loaded_modules):
            module = LassoModuleLoader.loaded_modules[module.get_name()]
        else:
            for path in LassoModuleFactory.get_module_load_paths():
                module_path = os.path.join(path, module.get_filename())
                if os.path.isfile(module_path):
                    LassoModuleLoader.loaded_modules[module.get_name()] = module
        return module
            
