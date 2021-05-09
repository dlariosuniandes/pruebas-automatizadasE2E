USER_NAME = "ghost.miso.uniandes@gmail.com"
PASSWORD = "N3wGh05tm1s0$"
NEW_PASSWORD = "gh05tm1s0$"
NEW_PASSWORD2 = "$0s1mt50hg"
#PASSWORD = "gh05tm1s0$"
#NEW_PASSWORD = "N3wGh05tm1s0$"
BASE_URL = "http://localhost:2368"
DEFAULT_SLEEP_TIME = 1
NEW_URL = "ghost"

if ENV["ADB_DEVICE_ARG"].nil?
  require 'kraken-mobile/steps/web/kraken_steps'
  require 'securerandom'

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
  end  

  def login_using_password(passwd)
    go_to_page ("/ghost/#/signin");
    do_event "type", "id", "ember8", USER_NAME
    do_event "type", "id", "ember10", passwd
    do_event "click", "id", "ember12", ""
    sleep 2;
  end
  
  def generate_code(number, spaces)
    charset = Array('a'..'z') + Array('0'..'9')
    
    if spaces
      charset = charset + [" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "]
    end
    
    Array.new(number) { charset.sample }.join
  end
  
  def random_text(type)
    random = ""
    if type == 'title'
      random = generate_code(32, false)
    elsif type == 'description'
      random = generate_code(128, true)
    elsif type == 'tag'
      random = generate_code(8, false)
    end
    return random
  end
  
  def validate_link_with_text(text, reverse, random_selector_file)
    sleep DEFAULT_SLEEP_TIME
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

  Given (/^I login into the administrator site$/) do
    login_using_password (PASSWORD)
  end

  When (/^I login into the administrator site using the new password$/) do
    login_using_password (NEW_PASSWORD)
  end

  When (/^I go to the user profile$/) do
    do_event "click", "class", "gh-user-name", ""
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "partial_link_text", "Profile", ""
    sleep DEFAULT_SLEEP_TIME
  end
  
  When (/^I change my user password$/) do
    do_event "type", 'id', 'user-password-old', PASSWORD
    do_event "type", 'id', 'user-password-new', NEW_PASSWORD
    do_event "type", 'id', 'user-new-password-verification', NEW_PASSWORD
    do_event "click", "class", "button-change-password", ""
    sleep 2
  end

  When (/^I change my user name with a random name$/) do
    random_text = random_text ('title')
    do_event "clear", 'id', 'user-name', ""
    do_event "type", 'id', 'user-name', random_text
    File.write('./.gh-editor-title.txt', random_text)
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "gh-btn-blue", ""
    sleep DEFAULT_SLEEP_TIME
  end


  When (/^I change my user password not matching new password and confirmation$/) do
    do_event "type", 'id', 'user-password-old', PASSWORD
    do_event "type", 'id', 'user-password-new', NEW_PASSWORD
    do_event "type", 'id', 'user-new-password-verification', NEW_PASSWORD2
    do_event "click", "class", "button-change-password", ""
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
    do_event "click", "class", "gh-publishmenu-button", ""
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "id", "ember62", ""
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
    do_event "click", "class", "gh-publishmenu-button", ""
    sleep DEFAULT_SLEEP_TIME
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
    random_text = random_text ('tag')
    do_event "type", 'id', 'tag-input', random_text, true
    File.write('./.tag-name.txt', random_text)
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "close", ""
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "gh-publishmenu-trigger", ""
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "gh-publishmenu-button", ""
    sleep DEFAULT_SLEEP_TIME
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
    do_event "click", "class", "close", ""
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "gh-publishmenu-trigger", ""
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "gh-publishmenu-button", ""
    sleep DEFAULT_SLEEP_TIME
    go_to_page ("/ghost/#/tags")
    sleep DEFAULT_SLEEP_TIME
  end

  When (/^I check the tag to see the linked post with random texts$/) do
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
    do_event "click", "class", "settings-menu-delete-button", ""
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "gh-btn-red", ""
    sleep DEFAULT_SLEEP_TIME
  end

  When (/^I delete the new page using random texts$/) do
    random_text = IO.read('./.gh-editor-title.txt')  
    do_event "click", "partial_link_text", random_text, ""
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "post-settings", ""
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "settings-menu-delete-button", ""
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "gh-btn-red", ""
    sleep DEFAULT_SLEEP_TIME
  end

  When (/^I edit the new page using random texts$/) do
    random_text = IO.read('./.gh-editor-title.txt')  
    do_event "click", "partial_link_text", random_text, ""
    sleep DEFAULT_SLEEP_TIME
    new_random_text = random_text ('title')
    do_event "clear", 'class', 'gh-editor-title', ""
    do_event "type", 'class', 'gh-editor-title', new_random_text
    File.write('./.gh-editor-title.txt', new_random_text)
    sleep DEFAULT_SLEEP_TIME
    new_random_text = random_text ('description')
    do_event "clear", 'xpath', "//p[@data-koenig-dnd-droppable='true']", ""
    do_event "type", 'xpath', "//p[@data-koenig-dnd-droppable='true']", new_random_text
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "gh-publishmenu-trigger", ""
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "gh-publishmenu-button", ""
    sleep DEFAULT_SLEEP_TIME
    go_to_page ("/ghost/#/pages")
    sleep DEFAULT_SLEEP_TIME
  end

  When (/^I edit the new post using random texts$/) do
    random_text = IO.read('./.gh-editor-title.txt')  
    do_event "click", "partial_link_text", random_text, ""
    sleep DEFAULT_SLEEP_TIME
    new_random_text = random_text ('title')
    do_event "clear", 'class', 'gh-editor-title', ""
    do_event "type", 'class', 'gh-editor-title', new_random_text
    File.write('./.gh-editor-title.txt', new_random_text)
    sleep DEFAULT_SLEEP_TIME
    new_random_text = random_text ('description')
    do_event "clear", 'xpath', "//p[@data-koenig-dnd-droppable='true']", ""
    do_event "type", 'xpath', "//p[@data-koenig-dnd-droppable='true']", new_random_text
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "gh-publishmenu-trigger", ""
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "gh-publishmenu-button", ""
    sleep DEFAULT_SLEEP_TIME
    go_to_page ("/ghost/#/posts")
    sleep DEFAULT_SLEEP_TIME
  end

  When (/^I unpublish the new post using random texts$/) do
    go_to_page ("/ghost/#/posts")
    sleep DEFAULT_SLEEP_TIME
    random_text = IO.read('./.gh-editor-title.txt')  
    do_event "click", "partial_link_text", random_text, ""
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "gh-publishmenu-trigger", ""
    sleep DEFAULT_SLEEP_TIME
    element = @driver.find_element(:xpath, '//div[@class="gh-publishmenu-radio "]/div[@class="gh-publishmenu-radio-button"]');
    element.click
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "gh-btn-blue", ""
    go_to_page ("/ghost/#/posts")
    sleep DEFAULT_SLEEP_TIME
  end

  When (/^I edit the new tag using random texts$/) do
    random_text = IO.read('./.tag-name.txt')  
    do_event "click", "partial_link_text", random_text, ""
    sleep DEFAULT_SLEEP_TIME
    new_random_text = random_text ('title')
    do_event "clear", 'id', 'tag-name', ""
    do_event "type", 'id', 'tag-name', new_random_text
    File.write('./.tag-name.txt', new_random_text)
    sleep DEFAULT_SLEEP_TIME
    new_random_text = random_text ('description')
    do_event "clear", 'id', 'tag-description', ""
    do_event "type", 'id', 'tag-description', new_random_text
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "gh-btn-blue", ""
    sleep DEFAULT_SLEEP_TIME
    go_to_page ("/ghost/#/tags")
    sleep DEFAULT_SLEEP_TIME
  end

  When (/^I delete the new tag using random texts$/) do
    random_text = IO.read('./.tag-name.txt')  
    do_event "click", "partial_link_text", random_text, ""
    sleep DEFAULT_SLEEP_TIME
    do_event "click", "class", "gh-btn-red", ""
    sleep DEFAULT_SLEEP_TIME
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
    element = @driver.find_element(:xpath, '//div[@class="ember-power-select-search"]/input[@type="search"]');
    element.clear
    element.send_keys(random_text)
    sleep DEFAULT_SLEEP_TIME
  end

  When (/^I search the new page using the random title$/) do
    random_text = IO.read('./.gh-editor-title.txt')  
    do_event "click", "class", "gh-nav-btn-search", ""
    sleep DEFAULT_SLEEP_TIME
    element = @driver.find_element(:xpath, '//div[@class="ember-power-select-search"]/input[@type="search"]');
    element.clear
    element.send_keys(random_text)
    sleep DEFAULT_SLEEP_TIME
  end

  When (/^I search the new tag using the random title$/) do
    random_text = IO.read('./.tag-name.txt')  
    do_event "click", "class", "gh-nav-btn-search", ""
    sleep DEFAULT_SLEEP_TIME
    element = @driver.find_element(:xpath, '//div[@class="ember-power-select-search"]/input[@type="search"]');
    element.clear
    element.send_keys(random_text)
    sleep DEFAULT_SLEEP_TIME
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
    text_to_validate = IO.read('./.gh-editor-title.txt')
    raise 'ERROR: Text "' + text_to_validate + '" not found' if not @driver.page_source.include?(text_to_validate)
  end

  Then (/^I should see the new main menu entry with random text$/) do
    text_to_validate = IO.read('./.gh-editor-title.txt')
    raise 'ERROR: Text "' + text_to_validate + '" not found' if not @driver.page_source.include?(text_to_validate)
  end

  Then (/^I should see the title for the new post$/) do
    text_to_validate = IO.read('./.gh-editor-title.txt')
    raise 'ERROR: Text "' + text_to_validate + '" not found' if not @driver.page_source.include?(text_to_validate)
  end

  Then (/^I should see the title for the new page$/) do
    text_to_validate = IO.read('./.gh-editor-title.txt')
    raise 'ERROR: Text "' + text_to_validate + '" not found' if not @driver.page_source.include?(text_to_validate)
  end

  Then (/^I should see the title for the new tag$/) do
    text_to_validate = IO.read('./.tag-name.txt')
    raise 'ERROR: Text "' + text_to_validate + '" not found' if not @driver.page_source.include?(text_to_validate)
  end

  Then (/^I should see the random text in the Site Footer$/) do
    text_to_validate = IO.read('./.gh-editor-title.txt')
    raise 'ERROR: Text "' + text_to_validate + '" not found' if not @driver.page_source.include?(text_to_validate)
  end

  Then (/^I should see the text "([^\"]*)"$/) do |text|
    raise 'ERROR: Text "' + text + '" not found' if not @driver.page_source.include?(text)
  end

  Then (/^I should see the new user name with a random name$/) do
    text_to_validate = IO.read('./.gh-editor-title.txt')
    raise 'ERROR: Text "' + text_to_validate + '" not found' if not @driver.page_source.include?(text_to_validate)
  end

end
