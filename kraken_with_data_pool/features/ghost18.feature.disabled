Feature: Change Password

  @user1 @web @version3.42.5 @scenario18
  Scenario: Change Password
    Given I login into the administrator site
    When I go to the user profile
    And I change my user password not matching new password and confirmation
    Then I should see the text "Your new passwords do not match"
