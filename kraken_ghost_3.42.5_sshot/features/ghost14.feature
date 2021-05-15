Feature: Search Post

  @user1 @web @version3.42.5 @scenario14
  Scenario: Search Post
    Given I login into the administrator site
    When I create a new post using random texts
    And I search the new post using the random title
    And I select the searched new post selecting the random title
    Then I should see the title for the new post
