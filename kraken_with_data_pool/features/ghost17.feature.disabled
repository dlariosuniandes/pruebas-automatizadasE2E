Feature: Change User Name

  @user1 @web @version3.42.5 @scenario17
  Scenario: Change User Name
    Given I login into the administrator site
    When I go to the user profile
    And I change my user name with a random name
    And I close session
    And I login into the administrator site
    Then I should see the new user name with a random name
