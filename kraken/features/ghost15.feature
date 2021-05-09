Feature: Search Page

  @user1 @web
  Scenario: Search Page
    Given I login into the administrator site
    When I create a new page using random texts
    And I search the new page using the random title
    And I select the searched new page selecting the random title
    Then I should see the title for the new page
