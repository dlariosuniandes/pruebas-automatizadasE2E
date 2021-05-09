Feature: Create Post

  @user1 @web
  Scenario: Create Post
    Given I login into the administrator site
    When I create a new post using random texts
    And I close session
    And I go to the frontend site
    Then I should see the link for post with random text
