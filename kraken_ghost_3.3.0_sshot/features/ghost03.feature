Feature: Remove Post

  @user1 @web @version3.3.0 @scenario03
  Scenario: Remove Post
    Given I login into the administrator site
    When I create a new post using random texts
    And I delete the new post using random texts
    Then I should not see the link for post with random text
