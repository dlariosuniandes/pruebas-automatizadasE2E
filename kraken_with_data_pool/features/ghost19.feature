Feature: Link a Tag with a Post

  @user1 @web @version3.42.5 @scenario19
  Scenario: Link a Tag with a Post
    Given I login into the administrator site
    When I create a new post using random texts
    And I create a new tag using random texts
    And I link the tag with the post with random texts
    And I check the tag to see the linked post with random texts
    Then I should see the linked post of tag with random text
