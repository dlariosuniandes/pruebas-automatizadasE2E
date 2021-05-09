Feature: Add a new main menu entry

  @user1 @web
  Scenario: Add a new main menu entry
    Given I login into the administrator site
    When I go to the design settings
    #And I modify title and description of website with random texts
    And I add a new main menu entry with random text
    And I close session
    And I go to the frontend site
    Then I should see the new main menu entry with random text
