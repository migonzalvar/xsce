from settings import *

DEBUG = False
SECRET_KEY = '7ks@b7+gi^c4adff)6ka228#rd4f62v*g_dtmo*@i62k)qn=cs'
DATABASES = {
    'default': {
            'ENGINE':'django.db.backends.postgresql_psycopg2',
            'NAME': '{{ pathagar_db_name }}',
            'USER': '{{ pathagar_db_user }}',
            'PASSWORD': '{{ pathagar_db_password }}',
            'HOST': '127.0.0.1',
            'PORT': '5432',
        }
}