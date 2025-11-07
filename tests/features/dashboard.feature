Feature: Dashboard Management
  As a soccer team manager
  I want to view dashboard statistics and quick actions
  So that I can quickly access key metrics and perform common tasks

  Background:
    Given the application is loaded
    And the API is configured and connected
    And the dashboard section is active

  Scenario: View dashboard statistics with data
    Given the database contains 5 teams
    And the database contains 50 players
    And 5 players are injured
    When I navigate to the dashboard
    Then I should see "5" total teams
    And I should see "50" total players
    And I should see "5" injured players
    And I should see the average player value displayed

  Scenario: View dashboard with no data
    Given the database is empty
    When I navigate to the dashboard
    Then I should see "0" total teams
    And I should see "0" total players
    And I should see "0" injured players
    And I should see "$0" as average player value

  Scenario: Quick action - Add Team
    When I click the "Add Team" quick action button
    Then I should be redirected to the teams section
    And the team modal should be displayed
    And the modal title should be "Add Team"

  Scenario: Quick action - Add Player
    When I click the "Add Player" quick action button
    Then I should be redirected to the players section
    And the player modal should be displayed
    And the modal title should be "Add Player"

  Scenario: Quick action - Generate Report
    When I click the "Generate Report" quick action button
    Then I should be redirected to the reports section
    And the report configuration options should be displayed

  Scenario: Dashboard statistics calculation accuracy
    Given the database contains players with the following values:
      | player_name | value    |
      | Player 1    | 1000000  |
      | Player 2    | 2000000  |
      | Player 3    | 3000000  |
      | Player 4    | 4000000  |
    When I navigate to the dashboard
    Then the average player value should be "$2,500,000"

  Scenario: Dashboard real-time updates after adding a team
    Given I am on the dashboard
    When I add a new team through the API
    And I refresh the dashboard
    Then the total teams count should increase by 1

  Scenario: Dashboard accessibility - keyboard navigation
    Given I am on the dashboard
    When I press the Tab key repeatedly
    Then I should be able to focus on all interactive elements
    And I should be able to activate quick action buttons with Enter key

  @accessibility
  Scenario: Dashboard screen reader support
    Given I am using a screen reader
    When I navigate to the dashboard
    Then each stat card should have an accessible label
    And the stat values should be announced correctly
    And quick action buttons should have descriptive labels
