Feature: Portfolio dashboard

  Scenario: Investor sees portfolio overview on app launch
    Given the portfolio app is running
    Then I see {'Total Value'} text
    And I see {'Cash management'} text
