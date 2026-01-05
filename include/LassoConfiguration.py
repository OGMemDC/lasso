import os
import json
from LassoModule import LassoModule
from LassoDeploymentTypes import LassoDeploymentTypes

class LassoConfiguration:
	paths = {}
	deployment_type = LassoDeploymentTypes.Unknown
	verbose = 0
	logs = {}
	modules = {}
  
	__instance = None

	@staticmethod
	def get_instance():
		if LassoConfiguration.__instance is None:
			LassoConfiguration.__instance = LassoConfiguration()
		return LassoConfiguration.__instance

	def initialize(self):
		self.paths = {}
		self.deployment_type = LassoDeploymentTypes.Unknown
		self.verbose = 0
		self.logs = {}
		self.modules = {}
		config_path = []
		# Load configuration from lasso-conf.json
		if( os.path.exists('/etc/lasso/lasso-conf.json') ):
			config_path.append('/etc/lasso/lasso-conf.json')
		if( os.path.exists(os.path.join(os.getcwd(), 'lasso-conf.json')) ):
			config_path.append(os.path.join(os.getcwd(), 'lasso-conf.json'))
		if( os.path.exists(os.path.join(os.path.expanduser('~'), '.local/lasso-conf.json')) ):
			config_path.append(os.path.join(os.path.expanduser('~'), '.local/lasso-conf.json'))
   
		for path in config_path:
			try:
				with open(path,'r') as jsonFile:
					data=json.load(jsonFile)
					print("read successful from "+path)

					paths_data=data["lasso"]["paths"]
					for key in paths_data:
						value=paths_data[key]
						# Expand environment variables
						value=os.path.expandvars(value)
						# Replace INSTALL_PATH if present
						if "${INSTALL_PATH}" in value:
							install_path=data["lasso"]["paths"].get("install", "")
							value=value.replace("${INSTALL_PATH}", install_path)
						elif "${LIST_PATH}" in value:
							list_path=data["lasso"]["paths"].get("lists", "")
							value=value.replace("${LIST_PATH}", list_path)
						LassoConfiguration.get_instance().paths[key]=value
				
					deployment=data["lasso"].get("deployment", "none").lower()
					if deployment == "production":
						self.deployment_type = LassoDeploymentTypes.PRODUCTION
					elif deployment == "development":
						self.deployment_type = LassoDeploymentTypes.DEVELOPMENT
					elif deployment == "testing":
						self.deployment_type = LassoDeploymentTypes.TESTING
					else:
						self.deployment_type = LassoDeploymentTypes.Unknown
						print("Unknown deployment type, set to Unknown")

					LassoConfiguration.get_instance().verbose=data["lasso"][deployment].get("verbose", 0)
					LassoConfiguration.get_instance().logs=data["lasso"][deployment].get("logs", {})
					modules_data=data["lasso"][deployment].get("modules", [])
					for module_json in modules_data:
						module=LassoModule.LassoModuleFactory.from_json(module_json)
						LassoConfiguration.get_instance().modules[module.get_name()]=module	
      
			except FileNotFoundError:
				print("The config file was not found")
			except json.JSONDecodeError:
				print("Error failed to decode the json file")
			except Exception as e:
				print(e)



