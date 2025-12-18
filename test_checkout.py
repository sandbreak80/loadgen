import json
import pytest
import subprocess
import time
import unittest
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.by import By
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support import expected_conditions
from selenium.webdriver.support.wait import WebDriverWait
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


class MyTestCase(unittest.TestCase):

    def setUp(self):
        # Setup Chrome options
        chrome_options = Options()
        chrome_options.add_argument("--headless")
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")
        chrome_options.add_argument("--ignore-certificate-errors")  # Ignore SSL certificate errors
        chrome_options.add_argument("--disable-gpu")  # Disable GPU hardware acceleration
        chrome_options.add_argument("--window-size=1920,1080")  # Set window size

        # Initialize WebDriver with configured ChromeDriver path or auto-detect
        if config.CHROMEDRIVER_PATH:
            self.driver = webdriver.Chrome(service=Service(config.CHROMEDRIVER_PATH), options=chrome_options)
        else:
            self.driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)
        
        # Determine target URL: use EC2 local instance if available, otherwise use config
        ec2_public_hostname = get_ec2_public_hostname()
        if ec2_public_hostname:
            # Running on AWS - test itself via public hostname (avoids localhost SSL issues)
            self.target_url = f"https://{ec2_public_hostname}:8783/konakart/Welcome.action"
            print(f"Running on EC2, testing instance via public hostname: {self.target_url}")
        else:
            # Running locally - use configured URL from config.py
            self.target_url = config.TARGET_URL
            print(f"Testing against configured target: {self.target_url}")

    def test_checkout(self):
      # Infinite loop for continuous load generation
      iteration = 0
      while True:
        iteration += 1
        try:
            start_time = time.time()  # Start time measurement
            self.driver.get(self.target_url)
            WebDriverWait(self.driver, 10).until(expected_conditions.presence_of_element_located((By.CSS_SELECTOR, ".item-area:nth-child(4) .item-area-title")))
            #self.driver.set_window_size(1414, 819)
            self.driver.find_element(By.LINK_TEXT, "Acctim Metal Clock").click()
            element = self.driver.find_element(By.CSS_SELECTOR, "#AddToCartForm .add-to-cart-button-big")
            actions = ActionChains(self.driver)
            actions.move_to_element(element).perform()
            self.driver.find_element(By.CSS_SELECTOR, "#AddToCartForm .add-to-cart-button-big").click()
            element = self.driver.find_element(By.CSS_SELECTOR, "body")
            actions = ActionChains(self.driver)
            actions.move_to_element(element).perform()
            WebDriverWait(self.driver, 10).until(expected_conditions.presence_of_element_located((By.CSS_SELECTOR, "#AddToCartForm .add-to-cart-button-big")))
            self.driver.find_element(By.CSS_SELECTOR, ".shopping-cart-title").click()
            self.driver.execute_script("window.scrollTo(0,117)")
            self.driver.find_element(By.CSS_SELECTOR, "#continue-button > span").click()
            WebDriverWait(self.driver, 10).until(expected_conditions.presence_of_element_located((By.CSS_SELECTOR, "#continue-button > span")))
            self.driver.find_element(By.CSS_SELECTOR, "#continue-button > span").click()
            self.driver.find_element(By.ID, "loginUsername").send_keys(config.USERNAME)
            self.driver.find_element(By.ID, "password").send_keys(config.PASSWORD)
            self.driver.find_element(By.CSS_SELECTOR, "#continue-button > span").click()
            WebDriverWait(self.driver, 10).until(expected_conditions.presence_of_element_located((By.ID, "page-title")))
            self.driver.find_element(By.ID, "continue-button").click()
            WebDriverWait(self.driver, 10).until(expected_conditions.presence_of_element_located((By.ID, "page-title")))
            element = self.driver.find_element(By.CSS_SELECTOR, "#continue-button > span")
            actions = ActionChains(self.driver)
            actions.move_to_element(element).perform()
            self.driver.find_element(By.CSS_SELECTOR, "#continue-button > span").click()
            self.driver.find_element(By.LINK_TEXT, "Log Off").click()
            end_time = time.time()  # End time measurement
            time_taken = end_time - start_time  # Calculate the time taken for this iteration
            print(f"Iteration {iteration}: Time taken: {time_taken:.2f} seconds")
        except Exception as e:
            # Handle errors gracefully - log and continue to next iteration
            end_time = time.time()
            time_taken = end_time - start_time
            print(f"Iteration {iteration}: ERROR after {time_taken:.2f}s - {type(e).__name__}: {str(e)[:100]}")
            # Try to recover by navigating back to home
            try:
                self.driver.get(self.target_url)
            except:
                pass  # If recovery fails, the next iteration will try again

    def tearDown(self):
        # Close the browser window
        self.driver.quit()

# Example usage
if __name__ == "__main__":
    unittest.main()