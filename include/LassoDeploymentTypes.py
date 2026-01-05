from enum import Enum

class LassoDeploymentTypes(Enum):
    Unknown = "none"
    PRODUCTION = "production"
    DEVELOPMENT = "development"
    TESTING = "testing"