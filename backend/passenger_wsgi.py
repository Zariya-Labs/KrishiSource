import sys
import os

# Include the current directory in the Python search path
sys.path.insert(0, os.path.dirname(__file__))

# Import the ASGI-to-WSGI adapter
from a2wsgi import ASGIMiddleware
from main import app

# cPanel Phusion Passenger expects a global variable named 'application'
application = ASGIMiddleware(app)
