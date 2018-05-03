# encoding: UTF-8

# Commons steps definition

module CommonSteps

	# Stop the test execution for a while
	# To secure the page was load correctly 
	#
	# @param seconds [Integer] Seconds for wait
	def CommonSteps.wait(seconds)
	  sleep(seconds.to_i)
	end
	
end