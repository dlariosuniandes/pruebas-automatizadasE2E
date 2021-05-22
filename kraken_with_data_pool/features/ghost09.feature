Feature: Edit Post

  @user1 @web @version3.42.5 @scenario09
  Scenario: Edit Post
    Given I login into the administrator site
    When I create a new post using random texts
    And I edit the new post using random texts
    Then I should see the link for post with random text
