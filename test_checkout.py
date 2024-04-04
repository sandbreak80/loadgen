import json
import pytest
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

        # Initialize WebDriver
        self.driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)

    def test_checkout(self):
      for _ in range(1000):  # Loop the test 1000 times
        start_time = time.time()  # Start time measurement
        self.driver.get("https://localhost:8783/konakart/Welcome.action")
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
        self.driver.find_element(By.ID, "loginUsername").send_keys("doe@konakart.com")
        self.driver.find_element(By.ID, "password").send_keys("password")
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
        print(f"Iteration {i+1}: Time taken: {time_taken:.2f} seconds")
        #self.driver.close()

    def tearDown(self):
        # Close the browser window
        self.driver.quit()

# Example usage
if __name__ == "__main__":
    unittest.main()