Feature: Edit Page

  @user1 @web @version3.42.5 @scenario08
  Scenario: Edit Page
    Given I login into the administrator site
    When I create a new page using random texts
    And I edit the new page using random texts
    Then I should see the link for page with random text
