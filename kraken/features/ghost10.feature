Feature: Edit Tag

  @user1 @web
  Scenario: Edit Tag
    Given I login into the administrator site
    When I create a new tag using random texts
    And I edit the new tag using random texts
    Then I should see the link for tag with random text
