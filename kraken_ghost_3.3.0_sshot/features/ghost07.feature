Feature: Change Password

  @user1 @web @version3.3.0 @scenario07
  Scenario: Change Password
    Given I login into the administrator site
    When I go to the user profile
    And I change my user password
    And I close session
    And I login into the administrator site using the new password
    Then I should see the link "View site"
