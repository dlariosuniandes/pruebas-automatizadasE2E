USER_NAME = "ghost.miso.uniandes@gmail.com"
PASSWORD = "gh05tm1s0$"
NEW_PASSWORD = "N3wGh05tm1s0$"
#PASSWORD = "N3wGh05tm1s0$"
#NEW_PASSWORD = "gh05tm1s0$"
NEW_PASSWORD2 = "$0s1mt50hg"
BASE_URL = "http://localhost:2368"
DEFAULT_SLEEP_TIME = 1
NEW_URL = "ghost"
GEN_SCREENSHOST = false
SCREENSHOT_PATH = 'screenshot/'

if ENV["ADB_DEVICE_ARG"].nil?
  require 'kraken-mobile/steps/web/kraken_steps'
  require 'securerandom'
  require 'csv'
  require 'faker'
  
  def reset_screenshot_numbering()
    File.write('./.screenshot_numbering.txt', 1)
  end
  
  def get_screenshot_number()
    number_str = IO.read('./.screenshot_numbering.txt')  
    return number_str
  end
  
  def advance_screenshot_numbering()
    number_str = IO.read('./.screenshot_numbering.txt')  
    number = number_str.to_i + 1
    File.write('./.screenshot_numbering.txt', number)
  end

  def generate_screenshot ()
    if GEN_SCREENSHOST
      tag_version = @scenario_tags.grep(/@version/).first
      version = tag_version.delete_prefix('@version')
      tag_scenario = @scenario_tags.grep(/@scenario/).first
      scenario = tag_scenario.delete_prefix('@scenario')
      screenshot_number = get_screenshot_number
      directory_name = SCREENSHOT_PATH + 'ghost-' + version + '.scenario-' + scenario
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      path = directory_name + '/' + screenshot_number + '.png'
      @driver.save_screenshot(path)
      embed(path, 'image/png', File.basename(path))
      advance_screenshot_numbering
    end
  end
  

  def do_event(event, type, selector, text, enter = false)
    if event == 'type'
      if type == 'id'
        @driver.find_element(:id, selector).send_keys(text)
        if enter
          @driver.find_element(:id, selector).send_keys("\ue007")
        end
      elsif type == 'class'
        @driver.find_element(:class, selector).send_keys(text)
        if enter
          @driver.find_element(:class, selector).send_keys("\ue007")
        end
      elsif type == 'xpath'
        @driver.find_element(:xpath, selector).send_keys(text)
        if enter
          @driver.find_element(:xpath, selector).send_keys("\ue007")
        end
      end
    elsif event == 'clear'
      if type == 'id'
        @driver.find_element(:id, selector).clear
        @driver.find_element(:id, selector).click;
        @driver.action.key_down(:control).send_keys("a").key_up(:control).perform
          @driver.find_element(:id, selector).send_keys("")
      elsif type == 'class'
        @driver.find_element(:class, selector).clear
      elsif type == 'xpath'
        @driver.find_element(:xpath, selector).clear
      end
    elsif event == 'click'
      if type == 'id'
        @driver.find_element(:id, selector).click;
      elsif type == 'class'
        @driver.find_element(:class, selector).click;
      elsif type == 'xpath'
        @driver.find_element(:xpath, selector).click;
      elsif type == 'partial_link_text'
        @driver.find_element(:partial_link_text, selector).click;
      end
    end
  end

  def go_to_page(path)
    @driver.navigate.to BASE_URL + path
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
  end  
  
  def get_current_password
    passwd = PASSWORD
    if File.exist?('./.current-password.txt')
      passwd = IO.read('./.current-password.txt')  
    end
    return passwd
  end

  def upd_current_password (new_passwd)
    File.write('./.current-password.txt', new_passwd)
  end

  def login_using_password(passwd, use_current = true)
    reset_screenshot_numbering
    
    if use_current
      passwd = get_current_password
    end
    
    go_to_page ("/ghost/#/signin")
    do_event "type", "id", "ember8", USER_NAME
    do_event "type", "id", "ember10", passwd
    generate_screenshot
    do_event "click", "id", "ember12", ""
    sleep 2;
    generate_screenshot
  end

  def generate_spaces(number)
    charset = [" "]
    
    if number == -1
      number = rand(10..64)
    end
    
    Array.new(number) { charset.sample }.join
  
  end

  def generate_code(number, spaces)
    charset = Array('a'..'z') + Array('0'..'9')
    
    if spaces
      charset = charset + [" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "]
    end
    
    Array.new(number) { charset.sample }.join
  end
  
  def random_text(type, value_length = -1, value_case = 'none' )
    random = ""

    case type
      when 'title', 'sentence'
        if value_case == 'none'
          if value_length == -1
            random = Faker::Lorem.sentence
          else
            random = generate_code value_length, true
          end
        elsif value_case == 'only spaces'
          random = generate_spaces value_length
        elsif value_case == 'bad formed'
        end
      when 'description'
        random = Faker::Lorem.paragraph_by_chars(number: 128, supplemental: false)
      when 'tag'
        random = Faker::Lorem.characters(number: 8)
      when 'slug'
        if value_case == 'none'
          if value_length == -1
            random = Faker::Internet.slug
          else
            random = Faker::Lorem.characters(number: value_length)
          end
        elsif value_case == 'only spaces'
          random = generate_spaces value_length
        elsif value_case == 'bad formed'
        end
      when 'email'
        if value_case == 'none'
          if value_length == -1
            random = Faker::Internet.free_email
          else
            available_length = value_length - 5
            domain_length = available_length - 64
            random = Faker::Lorem.characters(number: 64) + '@' +Faker::Lorem.characters(number: domain_length) + '.com'
          end
        elsif value_case == 'only spaces'
          random = generate_spaces value_length
        elsif value_case == 'bad formed'
          random = Faker::Lorem.characters(number: 64)
        end
      when 'url'
        if value_case == 'none'
          if value_length == -1
            random = Faker::Internet.url
          else
            available_length = value_length - 17
            domain_length = rand(1..available_length)
            available_length = available_length - domain_length
            random = "http://" + Faker::Lorem.characters(number: domain_length) + ".com/" + Faker::Lorem.characters(number: available_length) + ".html"
          end
        elsif value_case == 'only spaces'
          random = generate_spaces value_length
        elsif value_case == 'bad formed'
          random = Faker::Lorem.characters(number: 64)
        end
      when 'facebook', 'twitter'
        if value_case == 'none'
          if value_length == -1
            random = Faker::Lorem.characters(number: rand(10..32))
          else
            random = Faker::Lorem.characters(number: value_length)
          end
        elsif value_case == 'only spaces'
          random = generate_spaces value_length
        elsif value_case == 'bad formed'
          random = '%%%%%%%%'
        end
      end
    return random
  end

  
  def validate_link_with_text(text, reverse, random_selector_file)
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    text_to_validate = text
    if (random_selector_file.length > 0)
      text_to_validate = IO.read(random_selector_file)  
    end
    if reverse
      raise 'ERROR: Text link "' + text_to_validate + '" found' if @driver.find_elements(:partial_link_text, text_to_validate).size() > 0
    else
      raise 'ERROR: Text link "' + text_to_validate + '" not found' if @driver.find_elements(:partial_link_text, text_to_validate).size() == 0
    end
  end
  
  def go_to_user_profile
    do_event "click", "class", "gh-user-name", ""
    generate_screenshot
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "partial_link_text", "Profile", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
  end

  Given (/^I login into the administrator site$/) do
    login_using_password (PASSWORD)
  end

  When (/^I login into the administrator site using the new password$/) do
    login_using_password (NEW_PASSWORD)
  end

  When (/^I go to the user profile$/) do
    go_to_user_profile
  end
  
  When (/^I change my user password$/) do
    do_event "type", 'id', 'user-password-old', PASSWORD
    do_event "type", 'id', 'user-password-new', NEW_PASSWORD
    do_event "type", 'id', 'user-new-password-verification', NEW_PASSWORD
    do_event "click", "class", "button-change-password", ""
    sleep 2
    generate_screenshot
    upd_current_password NEW_PASSWORD
  end

  When (/^I change my user name with a random name$/) do
    random_text = random_text ('title')
    do_event "clear", 'id', 'user-name', ""
    do_event "type", 'id', 'user-name', random_text
    File.write('./.gh-editor-title.txt', random_text)
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "gh-btn-blue", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
  end


  When (/^I change my user password not matching new password and confirmation$/) do
    do_event "type", 'id', 'user-password-old', PASSWORD
    do_event "type", 'id', 'user-password-new', NEW_PASSWORD
    do_event "type", 'id', 'user-new-password-verification', NEW_PASSWORD2
    do_event "click", "class", "button-change-password", ""
    generate_screenshot
    sleep 2
  end

  When (/^I close session$/) do
    go_to_page ("/ghost/#/signout")
  end

  When (/^I go to the frontend site$/) do
    go_to_page ("")
  end
  
  When (/^I go to the general settings$/) do
    go_to_page ("/ghost/#/settings/general")
  end
  
  When (/^I go to the code injection settings$/) do
    go_to_page ("/ghost/#/settings/code-injection")
  end

  When (/^I go to the design settings$/) do
    go_to_page ("/ghost/#/settings/design")
  end
  
  When (/^I modify title and description of website with random texts$/) do
    do_event "click", "xpath", "//div[@class='gh-setting-first']/div[@class='gh-setting-action']/button[@class='gh-btn']", ""
    sleep DEFAULT_SLEEP_TIME
    random_text = random_text ('title')
    element = @driver.find_element(:xpath, '//div[@class="gh-setting-content-extended"]/div[@class="form-group ember-view"]/input[@type="text"]');
    element.clear
    element.send_keys(random_text)
    File.write('./.gh-editor-title.txt', random_text)
    sleep DEFAULT_SLEEP_TIME
    random_text = random_text ('description')
    element = @driver.find_element(:xpath, '//div[@class="gh-setting-content-extended"]/div[@class="description-container form-group ember-view"]/input[@type="text"]');
    element.clear
    element.send_keys(random_text)
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "gh-btn-blue", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
  end

  When (/^I add a new main menu entry with random text$/) do
    random_text = random_text ('tag')
    elements = @driver.find_elements(:xpath, '//div[@class="gh-blognav-line"]/span[@class="gh-blognav-label ember-view"]/input[@placeholder="Label"]');
    elements[elements.length - 2].click
    elements[elements.length - 2].clear
    elements[elements.length - 2].send_keys(random_text)
    File.write('./.gh-editor-title.txt', random_text)
    sleep DEFAULT_SLEEP_TIME
    elements = @driver.find_elements(:xpath, '//div[@class="gh-blognav-line"]/span[@class="gh-blognav-url ember-view"]/input[@type="text"]');
    elements[elements.length - 2].send_keys(NEW_URL)
    do_event "click", "class", "gh-btn-blue", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
  end

  When (/^I modify the Site Footer with a random text$/) do
    random_text = random_text ('description')
    elements = @driver.find_elements(:xpath, '//div[@id="ghost-foot"]/textarea');
    @driver.execute_script("arguments[0].innerHTML = '<span role=\"presentation\">xxxxxx</span>';", elements[0] )
    sleep 4
    go_to_page ("/ghost")
    #sleep 10
    #do_event "click", "class", "gh-btn-blue", ""
    #elements[1].send_keys('xxx')
    #elements[0].clear
    #sleep 2
    ###############Pending
    #sleep DEFAULT_SLEEP_TIME
  end

  When (/^I create a new post using random texts$/) do
    random_text = random_text ('title')
    do_event "click", "class", "gh-nav-new-post", ""
    sleep DEFAULT_SLEEP_TIME
    do_event "type", 'class', 'gh-editor-title', random_text
    File.write('./.gh-editor-title.txt', random_text)
    sleep DEFAULT_SLEEP_TIME
    random_text = random_text ('description')
    do_event "type", 'xpath', "//p[@data-koenig-dnd-droppable='true']", random_text
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "gh-publishmenu-trigger", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    do_event "click", "class", "gh-publishmenu-button", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    go_to_page ("/ghost/#/posts")
    sleep DEFAULT_SLEEP_TIME
  end

  When (/^I create a new tag using random texts$/) do
    go_to_page ("/ghost/#/tags/new")
    sleep DEFAULT_SLEEP_TIME
    random_text = random_text ('title')
    do_event "type", 'id', 'tag-name', random_text
    File.write('./.tag-name.txt', random_text)
    sleep DEFAULT_SLEEP_TIME
    random_text = random_text ('description')
    do_event "type", 'id', 'tag-description', random_text
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "gh-btn-blue", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    go_to_page ("/ghost/#/tags")
    sleep DEFAULT_SLEEP_TIME
  end

  When (/^I create a new page using random texts$/) do
    random_text = random_text ('title')
    go_to_page ("/ghost/#/editor/page")
    sleep DEFAULT_SLEEP_TIME
    do_event "type", 'class', 'gh-editor-title', random_text
    File.write('./.gh-editor-title.txt', random_text)
    sleep DEFAULT_SLEEP_TIME
    random_text = random_text ('description')
    do_event "type", 'xpath', "//p[@data-koenig-dnd-droppable='true']", random_text
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "gh-publishmenu-trigger", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    do_event "click", "class", "gh-publishmenu-button", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    go_to_page ("/ghost/#/pages")
    sleep DEFAULT_SLEEP_TIME
  end

  When (/^I create a new post using random texts with a random tag$/) do
    random_text = random_text ('title')
    do_event "click", "class", "gh-nav-new-post", ""
    sleep DEFAULT_SLEEP_TIME
    do_event "type", 'class', 'gh-editor-title', random_text
    File.write('./.gh-editor-title.txt', random_text)
    sleep DEFAULT_SLEEP_TIME
    random_text = random_text ('description')
    do_event "type", 'xpath', "//p[@data-koenig-dnd-droppable='true']", random_text
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "post-settings", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    random_text = random_text ('tag')
    do_event "type", 'id', 'tag-input', random_text, true
    File.write('./.tag-name.txt', random_text)
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    do_event "click", "class", "close", ""
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "gh-publishmenu-trigger", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    do_event "click", "class", "gh-publishmenu-button", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    go_to_page ("/ghost/#/tags")
    sleep DEFAULT_SLEEP_TIME
  end

  When (/^I link the tag with the post with random texts$/) do
    go_to_page ("/ghost/#/posts")
    sleep DEFAULT_SLEEP_TIME
    random_text = IO.read('./.gh-editor-title.txt')  
    do_event "click", "partial_link_text", random_text, ""
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "post-settings", ""
    sleep DEFAULT_SLEEP_TIME
    random_text = IO.read('./.tag-name.txt')  
    do_event "type", 'id', 'tag-input', random_text, true
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    do_event "click", "class", "close", ""
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "gh-publishmenu-trigger", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    do_event "click", "class", "gh-publishmenu-button", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    go_to_page ("/ghost/#/tags")
    sleep DEFAULT_SLEEP_TIME
  end

  When (/^I check the tag to see the linked post with random texts$/) do
    generate_screenshot
    random_text = IO.read('./.tag-name.txt')
    do_event "click", "xpath", "//a[@title=\"List posts tagged with '" + random_text + "'\"]", ""
    sleep DEFAULT_SLEEP_TIME
  end
  
  When (/^I delete the new post using random texts$/) do
    random_text = IO.read('./.gh-editor-title.txt')  
    do_event "click", "partial_link_text", random_text, ""
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "post-settings", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    do_event "click", "class", "settings-menu-delete-button", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    do_event "click", "class", "gh-btn-red", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
  end

  When (/^I delete the new page using random texts$/) do
    random_text = IO.read('./.gh-editor-title.txt')  
    do_event "click", "partial_link_text", random_text, ""
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "post-settings", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    do_event "click", "class", "settings-menu-delete-button", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    do_event "click", "class", "gh-btn-red", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
  end

  When (/^I edit the new page using random texts$/) do
    random_text = IO.read('./.gh-editor-title.txt')  
    do_event "click", "partial_link_text", random_text, ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    new_random_text = random_text ('title')
    do_event "clear", 'class', 'gh-editor-title', ""
    do_event "type", 'class', 'gh-editor-title', new_random_text
    File.write('./.gh-editor-title.txt', new_random_text)
    sleep DEFAULT_SLEEP_TIME
    new_random_text = random_text ('description')
    do_event "clear", 'xpath', "//p[@data-koenig-dnd-droppable='true']", ""
    do_event "type", 'xpath', "//p[@data-koenig-dnd-droppable='true']", new_random_text
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    do_event "click", "class", "gh-publishmenu-trigger", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    do_event "click", "class", "gh-publishmenu-button", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    go_to_page ("/ghost/#/pages")
    sleep DEFAULT_SLEEP_TIME
  end

  When (/^I edit the new post using random texts$/) do
    random_text = IO.read('./.gh-editor-title.txt')  
    do_event "click", "partial_link_text", random_text, ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    new_random_text = random_text ('title')
    do_event "clear", 'class', 'gh-editor-title', ""
    do_event "type", 'class', 'gh-editor-title', new_random_text
    File.write('./.gh-editor-title.txt', new_random_text)
    sleep DEFAULT_SLEEP_TIME
    new_random_text = random_text ('description')
    do_event "clear", 'xpath', "//p[@data-koenig-dnd-droppable='true']", ""
    do_event "type", 'xpath', "//p[@data-koenig-dnd-droppable='true']", new_random_text
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    do_event "click", "class", "gh-publishmenu-trigger", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    do_event "click", "class", "gh-publishmenu-button", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    go_to_page ("/ghost/#/posts")
    sleep DEFAULT_SLEEP_TIME
  end

  When (/^I unpublish the new post using random texts$/) do
    go_to_page ("/ghost/#/posts")
    sleep DEFAULT_SLEEP_TIME
    random_text = IO.read('./.gh-editor-title.txt')  
    do_event "click", "partial_link_text", random_text, ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    do_event "click", "class", "gh-publishmenu-trigger", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    element = @driver.find_element(:xpath, '//div[@class="gh-publishmenu-radio "]/div[@class="gh-publishmenu-radio-button"]');
    element.click
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    do_event "click", "class", "gh-btn-blue", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    go_to_page ("/ghost/#/posts")
    sleep DEFAULT_SLEEP_TIME
  end

  When (/^I edit the new tag using random texts$/) do
    random_text = IO.read('./.tag-name.txt')  
    do_event "click", "partial_link_text", random_text, ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    new_random_text = random_text ('title')
    do_event "clear", 'id', 'tag-name', ""
    do_event "type", 'id', 'tag-name', new_random_text
    File.write('./.tag-name.txt', new_random_text)
    sleep DEFAULT_SLEEP_TIME
    new_random_text = random_text ('description')
    do_event "clear", 'id', 'tag-description', ""
    do_event "type", 'id', 'tag-description', new_random_text
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    do_event "click", "class", "gh-btn-blue", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    go_to_page ("/ghost/#/tags")
    sleep DEFAULT_SLEEP_TIME
  end

  When (/^I delete the new tag using random texts$/) do
    random_text = IO.read('./.tag-name.txt')  
    do_event "click", "partial_link_text", random_text, ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    do_event "click", "class", "gh-btn-red", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    element = @driver.find_element(:xpath, '//div[@class="modal-footer"]/button[@class="gh-btn gh-btn-red gh-btn-icon ember-view"]');
    element.click
    go_to_page ("/ghost/#/tags")
    sleep DEFAULT_SLEEP_TIME
  end

  When (/^I see the link for post with random text$/) do
    validate_link_with_text '', false, './.gh-editor-title.txt'
  end
  
  When (/^I search the new post using the random title$/) do
    random_text = IO.read('./.gh-editor-title.txt')  
    do_event "click", "class", "gh-nav-btn-search", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    element = @driver.find_element(:xpath, '//div[@class="ember-power-select-search"]/input[@type="search"]');
    element.clear
    element.send_keys(random_text)
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
  end

  When (/^I search the new page using the random title$/) do
    random_text = IO.read('./.gh-editor-title.txt')  
    do_event "click", "class", "gh-nav-btn-search", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    element = @driver.find_element(:xpath, '//div[@class="ember-power-select-search"]/input[@type="search"]');
    element.clear
    element.send_keys(random_text)
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
  end

  When (/^I search the new tag using the random title$/) do
    random_text = IO.read('./.tag-name.txt')  
    do_event "click", "class", "gh-nav-btn-search", ""
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
    element = @driver.find_element(:xpath, '//div[@class="ember-power-select-search"]/input[@type="search"]');
    element.clear
    element.send_keys(random_text)
    sleep DEFAULT_SLEEP_TIME
    generate_screenshot
  end

  When (/^I select the searched new post selecting the random title$/) do
    do_event "click", "class", "ember-power-select-option", ""
    sleep DEFAULT_SLEEP_TIME
  end

  When (/^I select the searched new page selecting the random title$/) do
    do_event "click", "class", "ember-power-select-option", ""
    sleep DEFAULT_SLEEP_TIME
  end

  When (/^I select the searched new tag selecting the random title$/) do
    do_event "click", "class", "ember-power-select-option", ""
    sleep DEFAULT_SLEEP_TIME
  end

  Then (/^I should see the link "([^\"]*)"$/) do |linkText|
    validate_link_with_text linkText, false, ''
  end

  Then (/^I should see the link for post with random text$/) do
    validate_link_with_text '', false, './.gh-editor-title.txt'
  end
  
  Then (/^I should see the linked post of tag with random text$/) do
    validate_link_with_text '', false, './.gh-editor-title.txt'
  end


  Then (/^I should see the link for tag with random text$/) do
    validate_link_with_text '', false, './.tag-name.txt'
  end

  Then (/^I should see the link for page with random text$/) do
    validate_link_with_text '', false, './.gh-editor-title.txt'
  end
  
  Then (/^I should not see the link for post with random text$/) do
    validate_link_with_text '', true, './.gh-editor-title.txt'
  end

  Then (/^I should not see the link for page with random text$/) do
    validate_link_with_text '', true, './.gh-editor-title.txt'
  end

  Then (/^I should not see the link for tag with random text$/) do
    validate_link_with_text '', true, './.tag-name.txt'
  end

  Then (/^I should see the new title on website$/) do
    generate_screenshot
    text_to_validate = IO.read('./.gh-editor-title.txt')
    raise 'ERROR: Text "' + text_to_validate + '" not found' if not @driver.page_source.include?(text_to_validate)
  end

  Then (/^I should see the new main menu entry with random text$/) do
    generate_screenshot
    text_to_validate = IO.read('./.gh-editor-title.txt')
    raise 'ERROR: Text "' + text_to_validate + '" not found' if not @driver.page_source.include?(text_to_validate)
  end

  Then (/^I should see the title for the new post$/) do
    generate_screenshot
    text_to_validate = IO.read('./.gh-editor-title.txt')
    raise 'ERROR: Text "' + text_to_validate + '" not found' if not @driver.page_source.include?(text_to_validate)
  end

  Then (/^I should see the title for the new page$/) do
    generate_screenshot
    text_to_validate = IO.read('./.gh-editor-title.txt')
    raise 'ERROR: Text "' + text_to_validate + '" not found' if not @driver.page_source.include?(text_to_validate)
  end

  Then (/^I should see the title for the new tag$/) do
    generate_screenshot
    text_to_validate = IO.read('./.tag-name.txt')
    raise 'ERROR: Text "' + text_to_validate + '" not found' if not @driver.page_source.include?(text_to_validate)
  end

  Then (/^I should see the random text in the Site Footer$/) do
    generate_screenshot
    text_to_validate = IO.read('./.gh-editor-title.txt')
    raise 'ERROR: Text "' + text_to_validate + '" not found' if not @driver.page_source.include?(text_to_validate)
  end

  Then (/^I should see the text "([^\"]*)"$/) do |text|
    generate_screenshot
    raise 'ERROR: Text "' + text + '" not found' if not @driver.page_source.include?(text)
  end

  Then (/^I should see the new user name with a random name$/) do
    generate_screenshot
    text_to_validate = IO.read('./.gh-editor-title.txt')
    raise 'ERROR: Text "' + text_to_validate + '" not found' if not @driver.page_source.include?(text_to_validate)
  end
#==================================================================================
  When (/^I load and execute test scenarios from file "([^\"]*)"$/) do |filename|
    table = CSV.parse(File.read(filename), headers: true)
    filename_n_error = './.' + filename + '.n_errors'
    filename_error_logs = './.' + filename + '.error_logs'
    
    n_rows = table.length()
    
    i = 0
    
    File.write(filename_n_error, 0)
    File.write(filename_error_logs, "")
    
    while i < n_rows
      form_type = table[i][0]
      
      case form_type
        when "User profile"
          go_to_user_profile
          field_type = table[i][1]
          value_type = table[i][2]
          length = table[i][3]
          special_case = table[i][4]
          expected = table[i][5]
          
          random_text = random_text value_type, length.to_i, special_case
          do_event "clear", 'id', field_type, ""
          do_event "type", 'id', field_type, random_text
          File.write('./.'+filename, random_text)
          do_event "click", "class", "gh-btn-blue", ""
          
          n_errors = @driver.find_elements(:class, 'error').size()
          
          sleep DEFAULT_SLEEP_TIME
          if expected == 'pass'
            if n_errors > 0
              number_str = IO.read(filename_n_error)  
              number = number_str.to_i + 1
              File.write(filename_n_error, number)
              File.open(filename_error_logs,"a") do |file|
                file.write form_type + "," + field_type + "," + value_type + "," + length + "," + special_case + "," + expected + "\n"
              end
            end
          else
            if n_errors == 0
              number_str = IO.read(filename_n_error)  
              number = number_str.to_i + 1
              File.write(filename_n_error, number)
              File.open(filename_error_logs,"a") do |file|
                file.write form_type + "," + field_type + "," + value_type + "," + length + "," + special_case + "," + expected + "\n"
              end
            end
          end
          
          if field_type == 'user-email'
            do_event "clear", 'id', field_type, ""
            do_event "type", 'id', field_type, USER_NAME
            do_event "click", "class", "gh-btn-blue", ""
          end
          
        end
      
      i = i + 1
    end

  end

  Then (/^I should not see any failed scenario for file "([^\"]*)"$/) do |filename|
    filename_n_error = './.' + filename + '.n_errors'
    filename_error_logs = './.' + filename + '.error_logs'
    number_str = IO.read(filename_n_error)  
    number = number_str.to_i + 1
    raise 'ERROR: there are errors in file "' + filename + '".  Please check the failed ones in "' + filename_error_logs + '" file.'  if number > 0
  end


end


