import subprocess
import time
from urllib.parse import urljoin, urlparse
from selenium import webdriver
from selenium.common.exceptions import TimeoutException, StaleElementReferenceException
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
import config


# Function to get the EC2 public hostname
def get_ec2_public_hostname():
    try:
        result = subprocess.check_output(['ec2metadata', '--public-hostname'], timeout=2)
        return result.decode('utf-8').strip()
    except (subprocess.CalledProcessError, FileNotFoundError, subprocess.TimeoutExpired) as e:
        print(f"Not running on EC2 or ec2metadata not available: {e}")
        return None

# Use the EC2 public hostname as the base URL (for AWS deployments)
# Otherwise use the configured target URL
ec2_public_hostname = get_ec2_public_hostname()
if ec2_public_hostname:
    # Use public hostname to test itself - avoids localhost SSL issues
    base_url = f"https://{ec2_public_hostname}:8783/konakart/Welcome.action"
    print(f"Running on EC2, testing instance via public hostname: {base_url}")
else:
    # Use configured URL from config.py
    base_url = config.TARGET_URL
    print(f"Using configured target URL: {base_url}")

# Configuration
chrome_options = Options()
chrome_options.add_argument("--headless")
chrome_options.add_argument("--no-sandbox")
chrome_options.add_argument("--disable-dev-shm-usage")
chrome_options.add_argument("--ignore-certificate-errors")  # For HTTPS student instances

# Use configured ChromeDriver path or auto-detect
if config.CHROMEDRIVER_PATH:
    service = Service(config.CHROMEDRIVER_PATH)
else:
    # Auto-detect ChromeDriver using webdriver-manager
    service = Service(ChromeDriverManager().install())

# Initialize the driver
driver = webdriver.Chrome(service=service, options=chrome_options)

# Keep track of visited URLs
visited_urls = set()

def crawl(url, base_domain):
    try:
        # Normalize the URL and avoid visiting the same URL twice
        url = urljoin(base_url, url)
        if url in visited_urls or urlparse(url).netloc != base_domain:
            return
        visited_urls.add(url)

        # Navigate to the page
        driver.get(url)

        # Get the performance timing JSON
        navigation_timings = driver.execute_script("return window.performance.timing;")
        
        # Wait for the page to load completely
        WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.TAG_NAME, 'body')))

        # Time when the navigation started
        navigation_start = driver.execute_script("return window.performance.timing.navigationStart;")
        
        # Wait for the load event to complete
        WebDriverWait(driver, 10).until(lambda d: d.execute_script("return window.performance.timing.loadEventEnd;") > 0)
        load_event_end = driver.execute_script("return window.performance.timing.loadEventEnd;")
        
        # Calculate the page load time
        page_load_time = load_event_end - navigation_start
        
        # Gather the data

        # Calculate the performance metrics
        dns_lookup_time = navigation_timings['domainLookupEnd'] - navigation_timings['domainLookupStart']
        tcp_connection_time = navigation_timings['connectEnd'] - navigation_timings['connectStart']
        ttfb = navigation_timings['responseStart'] - navigation_timings['navigationStart']
        dom_interactive = navigation_timings['domInteractive'] - navigation_timings['navigationStart']
        dom_content_loaded = navigation_timings['domContentLoadedEventEnd'] - navigation_timings['navigationStart']
        dom_complete = navigation_timings['domComplete'] - navigation_timings['navigationStart']
        load_event_end = navigation_timings['loadEventEnd'] - navigation_timings['navigationStart']        
        page_size = len(driver.page_source.encode('utf-8'))
        page_title = driver.title
        
        print(f"URL: {url}")
        print(f"Full Page Load Time: {page_load_time}ms")
        print(f"Page Title: {page_title}")
        print(f"Page Size: {page_size} bytes")
        print(f"DNS Lookup Time: {dns_lookup_time}ms")
        print(f"TCP Connection Time: {tcp_connection_time}ms")
        print(f"Time to First Byte (TTFB): {ttfb}ms")
        print(f"DOM Interactive Time: {dom_interactive}ms")
        print(f"DOM Content Loaded Time: {dom_content_loaded}ms")
        print(f"DOM Complete Time: {dom_complete}ms")
        print(f"Full Page Load Time: {load_event_end}ms\n")


        # Find all the links on the current page
        all_links = driver.find_elements(By.TAG_NAME, "a")
        hrefs = set()
        for link in all_links:
            try:
                href = link.get_attribute('href')
                if href:
                    # Convert relative link to absolute
                    href = urljoin(url, href)
                    # Ensure the link is part of the same domain
                    if urlparse(href).netloc == base_domain:
                        hrefs.add(href)
            except StaleElementReferenceException:
                continue  # Skip this link and move to the next

        # Now that we have collected all hrefs, crawl them
        for href in hrefs:
            crawl(href, base_domain)

    except TimeoutException:
        print(f"Timeout occurred while loading {url}")
    except Exception as e:
        print(f"An error occurred with {url}: {e}")

# Get the domain of the base URL
base_domain = urlparse(base_url).netloc

# Start crawling the website
crawl(base_url, base_domain)

# Close the driver
driver.quit()