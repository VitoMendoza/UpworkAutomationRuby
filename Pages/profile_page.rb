require './Assertions/UpworkCoreMethods'

class ProfilePage



  # Verify if actual url is profile url
  #
  # Expect to get into freelancer's profile.
  # Log action.
  def verify_profile_page_url(stepNum)
    puts "#{stepNum}. Get into that freelancer's profile."
    if $driver.current_url.include? $pages['profilePage']
      puts "- Yes, it is the profile page."
    else
      puts "- It looks the url has change."
    end

  end


  # This step was made to compare the actual profile with the stored profiles from search results
  #
  # Stored profiles should be saved in $variables["freelancersList"] and the actual browser page should be freelancer profile
  # @return stdout text
  # - true: Yes it is, the profile of #{name} contains the keyword '#{keyword}'.
  # - false: This profile does not contain the keyword '#{keyword}'.
  # - null: There's no saved data to compare.
  def compare_profile_with_results(stepNum)
    begin
      puts "#{stepNum}. Check that each attribute value is equal to one of those stored inthe structure."
      freelancerProfile = Hash.new

      if $driver.find_elements(:xpath, "//*[@id='optimizely-header-container-default']/div[1]/div[1]/div/div[2]/h2/span/span").any?

        freelancerProfile["Name"] = $driver.find_element(:xpath, "//*[@id='optimizely-header-container-default']/div[1]/div[1]/div/div[2]/h2/span/span").text
        freelancerProfile["JobTitle"] = $driver.find_element(:xpath, "//*[@id='optimizely-header-container-default']/div[2]/div[1]/h3/span/span[1]").text
        freelancerProfile["Overview"] = $driver.find_element(:xpath, "//*[@id='optimizely-header-container-default']/div[2]/div[2]/o-profile-overview/div/p").text.gsub(/\n\n+/, '\n').gsub("\\n", " ").gsub("\n", " ").gsub("  "," ")
        freelancerProfile["Country"] = $driver.find_element(:xpath, "//*[@id='optimizely-header-container-default']/div[1]/div[1]/div/div[2]/div/fe-profile-map/span/ng-transclude/strong[2]").text

        # Getting all skills from freelancer profile
        skillListLength = $driver.find_elements(:xpath, '//*[@id="oProfilePage"]/div[1]/div/cfe-profile-skills-integration/div/div/section/div/up-skills-public-viewer/div/a').length
        skills = ""
        for i in 1..skillListLength
          newSkills = ""
          newSkills = $driver.find_element(:xpath, "//*[@id='oProfilePage']/div[1]/div/cfe-profile-skills-integration/div/div/section/div/up-skills-public-viewer/div/a[#{i}]").text
          skills = UpworkCoreMethods::merge_skills(skills, newSkills)
        end
        freelancerProfile["Skills"] = skills

        # There is 2 different cases to get the Rate and Earned from the profile page
        if !$driver.find_elements(:xpath, "//*[@id='optimizely-header-container-default']/div[3]/ul/li[1]/div[1]/div/h3/cfe-profile-rate/span/span").empty?
          freelancerProfile["Rate"] = $driver.find_element(:xpath, "//*[@id='optimizely-header-container-default']/div[3]/ul/li[1]/div[1]/div/h3/cfe-profile-rate/span/span").text
          freelancerProfile["Earned"] = $driver.find_element(:xpath, "//*[@id='optimizely-header-container-default']/div[3]/ul/li[2]/h3/span").text
        else
          freelancerProfile["Rate"] = $driver.find_element(:xpath, "//*[@id='optimizely-header-container-default']/div[4]/ul/li[1]/div[1]/div/h3/cfe-profile-rate/span/span").text		            														  # //*[@id="optimizely-header-container-default"]/div[4]/ul/li[1]/div[1]/div/h3/cfe-profile-rate/span/span
          freelancerProfile["Earned"] = $driver.find_element(:xpath, "//*[@id='optimizely-header-container-default']/div[4]/ul/li[2]/h3/span").text
        end

      else
        freelancerProfile["Name"] = $driver.find_element(:xpath, "//*[@id='main']/div[2]/div/div/div[3]/div[1]/div[1]/section[1]/div/div/div[1]/div[1]/h2").text	        														  # //*[@id="main"]/div[2]/div/div/div[3]/div[1]/div[1]/section[1]/div/div/div[1]/div[1]/h2
        freelancerProfile["JobTitle"] = $driver.find_element(:xpath, "//*[@id='main']/div[2]/div/div/div[3]/div[1]/div[1]/section[1]/div/div/div[1]/div[1]/h4").text
        freelancerProfile["Overview"] = $driver.find_element(:xpath, "//*[@id='main']/div[2]/div/div/div[3]/div[1]/div[1]/section[2]/div/span/span[2]").text.gsub(/\n\n+/, '\n').gsub("\\n", " ").gsub("\n", " ").gsub("  "," ")
        freelancerProfile["Country"] = $driver.find_element(:xpath, "//*[@id='main']/div[2]/div/div/div[3]/div[1]/div[1]/section[1]/div/div/div[2]/span[3]").text
        freelancerProfile["Skills"] = ""
        freelancerProfile["Rate"] = $driver.find_element(:xpath, "//*[@id='main']/div[2]/div/div/div[3]/div[1]/div[1]/section[1]/div/div/div[1]/div[2]/h3/span[1]").text
        freelancerProfile["Earned"] = $driver.find_element(:xpath, "//*[@id='main']/div[2]/div/div/div[3]/div[2]/ul/li[6]/span").text
      end

      freelancerProfile["ContainsKeyword"] = nil

      # Saving profile information in to $variables["FreelancerProfile"] to be use it later
      $variables["FreelancerProfile"] = freelancerProfile

      # Comparing actual profile and profiles from saved freelancersList
      if UpworkCoreMethods::compare_profile($variables["freelancersList"], $variables["FreelancerProfile"] )
        puts "- Actual profile is EQUAL to one of the stored profiles."
      else
        puts "- Actual profile is NOT EQUAL to one of the stored profiles."
      end
    rescue Exception => e
      puts " - Update this step."
      puts e.message
      puts e.backtrace.inspect
    end

  end


  # This step was made to search the keyword in the freelancer profile
  #
  # @return stdout text
  # - true: Yes it is, the profile of #{name} contains the keyword '#{keyword}'.
  # - false: This profile does not contain the keyword '#{keyword}'.
  # - null: There's no saved data to compare.
  def search_keywork_on_profile(stepNum)
    begin
      puts "#{stepNum}. I check whether at least one attribute contains the keyword."
      keyword = $variables['keyword']
      name = $variables["FreelancerProfile"]["Name"]
      # Searching keyword in $variables["FreelancerProfile"]
      if UpworkCoreMethods::verify_keyword($variables["FreelancerProfile"], $variables['keyword'])
        puts "- Yes it is, the profile of #{name} contains the keyword '#{keyword}'."
      else
        puts "- This profile of #{name} does not contains the keyword '#{keyword}'."
      end
    rescue Exception => e
      puts " - Update this step."
      puts e.message
      puts e.backtrace.inspect
    end
  end

end