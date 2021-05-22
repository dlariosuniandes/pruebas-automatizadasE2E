Feature: Profile form data validation

@user1 @web @version3.42.5 @scenario21
Scenario: Profile form data validation
  Given I login into the administrator site
  When I load and execute test scenarios from file "user_profile_form_cases.csv"
  Then I should not see any failed scenario for file "user_profile_form_cases.csv"
