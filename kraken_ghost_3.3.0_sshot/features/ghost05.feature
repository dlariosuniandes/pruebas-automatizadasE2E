Feature: Remove Page

  @user1 @web @version3.3.0 @scenario05
  Scenario: Remove Page
    Given I login into the administrator site
    When I create a new page using random texts
    And I delete the new page using random texts
    Then I should not see the link for page with random text
