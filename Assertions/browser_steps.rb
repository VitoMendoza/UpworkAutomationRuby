# encoding: UTF-8

require 'selenium-webdriver'


class BrowserSteps

# Selenium::WebDriver::Chrome.driver_path = ""
# caps = Selenium::WebDriver::Remote::Capabilities.chrome(:chrome_options => {detach: true})
# $driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps 
# driver.get ("https://www.upwork.com")

# Select one browser to run the test
# 
# This step is required to run any test. Make sure to have the driver for all browsers.
# It should be executed in Backgrond section.
# @param browser [String] Name of the browser using lowercase
 def run_browser(browser)
 	puts "1. Run '#{browser}'."
 	if "#{browser}" == "chrome"
    	Selenium::WebDriver::Chrome.driver_path = "./Drivers/chromedriver.exe"
		caps = Selenium::WebDriver::Remote::Capabilities.chrome(:chrome_options => {detach: true})
		$driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps 
		
	elsif "#{browser}" == "firefox"
		Selenium::WebDriver::Firefox.driver_path = "./Drivers/geckodriver.exe"
		caps = Selenium::WebDriver::Remote::Capabilities.firefox(:firefox_options => {detach: true})
		$driver = Selenium::WebDriver.for :firefox, desired_capabilities: caps 
		
	elsif "#{browser}" == "edge"
		Selenium::WebDriver::Edge.driver_path = "../Drivers/MicrosoftWebDriver.exe"
		caps = Selenium::WebDriver::Remote::Capabilities.explorer(:explorer_options => {detach: true})
		$driver = Selenium::WebDriver.for :edge, desired_capabilities: caps
		
	elsif "#{browser}" == "opera"
		Selenium::WebDriver::Opera.driver_path = "../Drivers/operadriver.exe"
		caps = Selenium::WebDriver::Remote::Capabilities.opera(:opera_options => {detach: true})
		$driver = Selenium::WebDriver.for :opera, desired_capabilities: caps
		
	elsif
		caps = Selenium::WebDriver::Remote::Capabilities.poltergeist(:poltergeist_options => {detach: true})
		$driver = Selenium::WebDriver.for :poltergeist, desired_capabilities: caps
	    
	end
	# browser = Capybara.current_session.driver.browser
	$driver.manage.window.maximize
 end


# Clear or delete browser cache
# 
# Get the actual browser and clear or delete cookies, it depends web driver.
def clear_cookies
	browser = $driver
	puts "2. Clear browser cookies."
	if browser.respond_to?(:clear_cookies)
	  # Rack::MockSession
	  browser.clear_cookies
	elsif browser.respond_to?(:manage) and browser.manage.respond_to?(:delete_all_cookies)
	  # Selenium::WebDriver
	  browser.manage.delete_all_cookies
	else
	  raise "Don't know how to clear cookies. Weird driver?"
	end
	puts "- Cookies deleted"
end

def navigate_to(url,stepNum)
	puts "#{stepNum}. Go to #{url}."
	$driver.navigate.to(url)
end

end