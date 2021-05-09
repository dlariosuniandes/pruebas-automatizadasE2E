Feature: Search Tag

  @user1 @web
  Scenario: Search Tag
    Given I login into the administrator site
    When I create a new tag using random texts
    And I search the new tag using the random title
    And I select the searched new tag selecting the random title
    Then I should see the title for the new tag
