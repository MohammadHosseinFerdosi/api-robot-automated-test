import yaml
import os
from selenium import webdriver
from selenium.webdriver.chrome.service import Service as ChromeService
from selenium.webdriver.edge.service import Service as EdgeService
from selenium.webdriver.firefox.service import Service as FirefoxService
from webdriver_manager.chrome import ChromeDriverManager
from webdriver_manager.microsoft import EdgeChromiumDriverManager
from webdriver_manager.firefox import GeckoDriverManager

            
def download_browser(browser):
    # get current working directory
    cwd = os.getcwd()
    constant_file = 'src/data/CONSTANTS.yaml'

    # Construct the full path to the YAML file
    file_path = os.path.join(cwd, constant_file)
        
    # Load the YAML file
    with open(file_path, 'r') as file:
        data = yaml.load(file, Loader=yaml.FullLoader)
        
    if browser in [data['CHROME'], data['HEADLESS_CHROME']]:
        webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()))
        
    elif browser in [data['FIREFOX'], data['HEADLESS_FIREFOX']]:
        webdriver.Firefox(service=FirefoxService(GeckoDriverManager().install()))
        
    elif browser in [data['EDGE'], data['HEADLESS_EDGE']]:
        webdriver.Edge(service=EdgeService(EdgeChromiumDriverManager().install()))
        
    else:
        raise ValueError(f"Unsupported browser: {browser}")
    

