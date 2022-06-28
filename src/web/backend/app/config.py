class Config:
    pass

class Development(Config):
    ENV = "development"
    DEBUG = True

class Production(Config):
    ENV = "production"

config = {
    "development": Development,
    "production": Production,
}
