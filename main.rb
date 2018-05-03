require './TestCases/find_freelancer_testcase'
require './Assertions/browser_steps'


# Main URL 
BASE_URL = 'https://www.upwork.com'

# GLOBAL VARIABLES
#
# $pages contains all URLs 
  	$pages = Hash.new
  	$pages['upwork'] = "#{BASE_URL}/"
  	$pages['profilePage'] = "#{BASE_URL}/" + "o/profiles/users"

# $variables contain all variables used to keed data saved among the steps
	$variables = Hash.new
	$variables['keyword'] = "" 
	$variables['freelancersList'] = Hash.new  

# Execute test case
	find_freelancer = FindFreelancer.new
	find_freelancer.find_freelancer("firefox", "vito")


# Close the browser and save the last page visited after execution test. 
END{	
	$driver.save_screenshot('Screenshots/screenshot.png')

	# Driver exit: Just in case reCaptcha is disabled.
	#$driver.quit
}