class DefaultConfig(object):
    DEBUG = False
    DEVELOPMENT = False
    TESTING = False
    CSRF_ENABLED = True
    # secret key for flask sessions http://flask.pocoo.org/docs/1.0/quickstart/#sessions
    #SECRET_KEY = 'this-really-needs-to-be-changed'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    #TWITTER_CONSUMER_KEY = ''
    #TWITTER_CONSUMER_SECRET = ''
    INSTAGRAM_CLIENT_ID = ''
    INSTAGRAM_SECRET = ''
    # define in config.py
    # SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://moa:moa@localhost/moa'
    # SQLALCHEMY_DATABASE_URI = 'sqlite:///moa.db'
    SEND = True
    SENTRY_DSN = 'https://3e96c064de2044dc8d8fd7ccec6d85bd@o559172.ingest.sentry.io/5733551'
    HEALTHCHECKS = []
    MAIL_SERVER = None
    MAIL_PORT = 587
    MAIL_USE_TLS = True
    MAIL_USERNAME = ''
    MAIL_PASSWORD = ''
    MAIL_TO = ''
    MAIL_DEFAULT_SENDER = ''
    MAX_MESSAGES_PER_RUN = 5

    # This option prevents Twitter replies and mentions from occuring when a toot contains @user@twitter.com. This
    # behavior is against Twitter's rules.
    SANITIZE_TWITTER_HANDLES = True

    SEND_DEFERRED_EMAIL = False
    SEND_DEFER_FAILED_EMAIL = False
    MAINTENANCE_MODE = False

    STATS_POSTER_BASE_URL = None
    STATS_POSTER_ACCESS_TOKEN = None

    TRUST_PROXY_HEADERS = False

    SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://moa:moapartyforall@localhost/moa'
    TWITTER_BLACKLIST = [r'andri000me_.*']
    MASTODON_BLACKLIST = [
        r'spinster.xyz', r'gab.com', r'kag.social', r'social.quodverum.com'
    ]
    SECRET_KEY = '1Cl7ET1t3MKQb3kGEkiAy'
    TWITTER_CONSUMER_KEY = '4qJKzkQK4FcXYCiiiHKjB2cSE'
    TWITTER_CONSUMER_SECRET = 'vahm3TpA0TKfBilJbrUsEz5ABvpUKuJPWTtNCWGLrMNLVDHVwUP'
    WORKER_JOBS = 10


class ProductionConfig(DefaultConfig):
    SECRET_KEY = open("/run/secrets/services/moa/secret").read()
    TWITTER_CONSUMER_KEY = open(
        "/run/secrets/services/moa/twitter_consumer_key").read()
    TWITTER_CONSUMER_SECRET = open(
        "/run/secrets/services/moa/twitter_consumer_secret").read()
    SANITIZE_TWITTER_HANDLES = False
    SQLALCHEMY_DATABASE_URI = "postgresql+pyscopg2://moa@/moa?host=/run/postgresql"


class DevelopmentConfig(DefaultConfig):
    DEBUG = True
    DEVELOPMENT = True
    SEND = False


class TestingConfig(DefaultConfig):
    TESTING = True
