require './Assertions/upwork_core_methods'
require './Assertions/common_steps'


class MainPage
  
  ########################################## <<< Base Methods and Web Elements Selectors >>> #################################################

  # Method used to select the freelancer option into the search field.
  #
  def select_freelancer_option()
    $driver.find_element(:xpath, '//*[@id="visitor-nav"]/div[1]/form/div/div/div[2]/span').click
    $driver.find_element(:xpath, '//*[@id="visitor-nav"]/div[1]/form/div/ul/li[1]/a').click
  end

  # Method used to enter a keyword into the search field.
  #
  # ID for search field is defined as "q".
  # @param keyword [String] keyword to search.
  def enter_keyword(keyword)
    $driver.find_element(:id, 'q').send_keys(keyword)
  end

  # Method used to press enter in to search field.
  #
  # ID for search field is defined as "q".
  def press_search_submit
    $driver.action.send_keys(:return).perform
  end

  #############################################################################################################################################

  ############################################################ <<< Steps Methods >>> ##########################################################

  # Step to choose Find Freelancers option in the search field.
  #
  # Click on down arrow and click on Find Freelancers option.
  # Log action.
  # @param stepNum [Integer] Step number to print out.
  def select_search_freelancer(stepNum)
    begin
      puts "#{stepNum}. Focus onto 'Find freelancers."
      select_freelancer_option()
    rescue Exception => e
      puts " - Error: please check this step or update it."
      puts e.message
      puts e.backtrace.inspect
    end
  end

  # Insert keyword into search field and submit.
  #
  # I save the keyword in a global variable to use later.
  # Log action.
  # @param stepNum [Integer] Step number to print out.
  def insert_text_search_field(value, stepNum)
    puts "#{stepNum}. Insert '#{value}' into the search input right from the dropdown and submit it (press enter)."
    enter_keyword(value)
    $variables['keyword'] = value
    press_search_submit()
    CommonSteps::wait(10)
  end
  #############################################################################################################################################

end