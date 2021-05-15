Feature: Create Tag

  @user1 @web @version3.42.5 @scenario02
  Scenario: Create Tag
    Given I login into the administrator site
    When I create a new tag using random texts
    Then I should see the link for tag with random text
