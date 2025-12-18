"""
Configuration file for LoadGen
Set target URLs for student instances here or via environment variables
"""
import os

# Student instance URLs - can be overridden by KONAKART_URL environment variable
STUDENT_INSTANCES = [
    "https://34.216.65.98:8783/konakart/Welcome.action",
    "https://18.146.19.241:8783/konakart/Welcome.action",
    "https://54.229.79.78:8783/konakart/Welcome.action",
    "https://35.92.144.61:8783/konakart/Welcome.action"
]

# Get target URL from environment or use first student instance as default
TARGET_URL = os.getenv('KONAKART_URL', STUDENT_INSTANCES[0])

# Login credentials - can be overridden by environment variables
USERNAME = os.getenv('KONAKART_USER', 'doe@konakart.com')
PASSWORD = os.getenv('KONAKART_PASSWORD', 'password')

# ChromeDriver path - auto-detect or use environment variable
CHROMEDRIVER_PATH = os.getenv('CHROMEDRIVER_PATH', None)  # None = auto-detect

# Load generation settings
CRAWLER_INSTANCES = int(os.getenv('CRAWLER_INSTANCES', '10'))
CHECKOUT_INSTANCES = int(os.getenv('CHECKOUT_INSTANCES', '10'))

# Note: Checkout tests now run indefinitely (infinite loop)
# This setting is kept for backwards compatibility but not used on AWS
CHECKOUT_ITERATIONS = int(os.getenv('CHECKOUT_ITERATIONS', '1000'))

# Timeouts
PAGE_LOAD_TIMEOUT = int(os.getenv('PAGE_LOAD_TIMEOUT', '10'))

