Feature: Change title and description of the web site

  @user1 @web
  Scenario: Change title and description of the web site
    Given I login into the administrator site
    When I go to the general settings
    And I modify title and description of website with random texts
    And I close session
    And I go to the frontend site
    Then I should see the new title on website
