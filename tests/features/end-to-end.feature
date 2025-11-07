Feature: End-to-End Workflows
  As a soccer team manager
  I want to perform complete workflows across multiple features
  So that I can accomplish real-world tasks efficiently

  Background:
    Given the application is loaded
    And the API is configured and connected
    And I am logged in to the application

  # Complete Team Setup Workflow
  Scenario: Create a new team and add players to it
    Given I am on the dashboard
    When I click the "Add Team" quick action
    And I create a new team "FC Barcelona" with all details
    And I submit the team form
    Then the team should be created successfully
    When I navigate to the players section
    And I click "New Player"
    And I create a player "Lionel Messi" for team "FC Barcelona"
    And I submit the player form
    Then the player should be created and assigned to "FC Barcelona"
    When I navigate to the dashboard
    Then the total teams count should include "FC Barcelona"
    And the total players count should include the new player

  Scenario: Complete team management workflow
    Given I have created a team "Manchester United"
    When I add 5 players to "Manchester United"
    And I navigate to teams section
    And I search for "Manchester United"
    Then I should see "Manchester United" in the results
    When I click edit for "Manchester United"
    And I update the team value to "600000000"
    And I save the changes
    Then the updated value should be reflected
    When I navigate to reports
    And I generate a team composition report for "Manchester United"
    Then the report should show 5 players
    And the report should display the updated team value

  # Player Injury Management Workflow
  Scenario: Track player injury from healthy to injured and back
    Given player "Cristiano Ronaldo" exists and is healthy
    When I navigate to players section
    And I edit "Cristiano Ronaldo"
    And I change injury status to "Injured"
    And I add injury details "Hamstring strain"
    And I save the changes
    Then the player should show as injured in the list
    When I navigate to the dashboard
    Then the injured players count should increase by 1
    When I navigate to reports
    And I generate an injury report for the player's team
    Then "Cristiano Ronaldo" should appear in the injured list
    And the injury details should show "Hamstring strain"
    When I navigate to players
    And I edit "Cristiano Ronaldo"
    And I change injury status to "Not Injured"
    And I save the changes
    And I navigate to the dashboard
    Then the injured players count should decrease by 1

  # Report Generation and Export Workflow
  Scenario: Generate multiple reports and export data
    Given team "Liverpool" exists with 11 players
    When I navigate to reports section
    And I generate a team composition report for "Liverpool"
    Then the report should be displayed with composition data
    When I export the report to CSV
    Then a CSV file should be downloaded with composition data
    When I change report type to "Player Performance"
    And I generate the report for "Liverpool"
    Then the performance report should be displayed
    When I export this report to CSV
    Then a CSV file with performance data should be downloaded
    When I change report type to "Value Report"
    And I generate the report for "Liverpool"
    Then the value report should be displayed
    And I should see players sorted by value

  # Search and Filter Workflow
  Scenario: Find specific players using multiple filters
    Given the database contains 50 players across 5 teams
    When I navigate to the players section
    And I enter "Silva" in the search box
    Then I should see only players with "Silva" in their name
    When I clear the search
    And I select "Manchester City" from the team filter
    Then I should see only players from "Manchester City"
    When I additionally select "Midfielder" from position filter
    Then I should see only midfielders from "Manchester City"
    When I select "Injured" from injury filter
    Then I should see only injured midfielders from "Manchester City"

  # Data Validation Workflow
  Scenario: Attempt invalid operations and recover
    Given I am creating a new team
    When I submit the form without required fields
    Then I should see validation errors
    When I fill in all required fields correctly
    And I submit the form
    Then the team should be created successfully
    When I try to create another team with the same name
    Then I should see a duplicate name warning or it should be allowed
    When I navigate to players
    And I try to create a player with rating "15"
    Then I should see a validation error
    When I change the rating to "9"
    And I submit the form
    Then the player should be created successfully

  # Settings and Configuration Workflow
  Scenario: Change API settings and verify connectivity
    Given I am using the default API configuration
    When I click the settings icon
    And I see the current API status
    Then it should show as connected
    When I change the API type to "C# API"
    And I update the API URL
    And I test the connection
    Then the connection test should run
    When I save the settings
    And I navigate to teams
    Then teams should be loaded from the new API endpoint
    When I navigate to players
    Then players should be loaded from the new API endpoint

  # Cross-Section Navigation Workflow
  Scenario: Navigate across all sections and perform actions
    Given I start on the dashboard
    When I click the "Add Team" quick action
    Then I should be on the teams section with modal open
    When I close the modal
    And I click the "Add Player" quick action
    Then I should be on the players section with modal open
    When I close the modal
    And I navigate to reports
    Then the reports section should be displayed
    When I navigate to dashboard
    Then dashboard statistics should be current
    When I open settings
    And I close settings
    Then I should return to the dashboard

  # Bulk Operations Workflow
  Scenario: Create multiple teams and players efficiently
    Given I am on the teams section
    When I create the following teams:
      | name          | country | league         |
      | Real Madrid   | Spain   | La Liga        |
      | Barcelona     | Spain   | La Liga        |
      | Bayern Munich | Germany | Bundesliga     |
    Then all 3 teams should be created successfully
    When I navigate to players
    And I create 3 players for "Real Madrid"
    And I create 3 players for "Barcelona"
    And I create 3 players for "Bayern Munich"
    Then all 9 players should be created successfully
    When I filter by team "Real Madrid"
    Then I should see exactly 3 players

  # Team Deletion and Cleanup Workflow
  Scenario: Delete team and verify cascade effects
    Given team "Test Team" exists with 5 players
    When I navigate to teams
    And I delete "Test Team"
    And I confirm the deletion
    Then "Test Team" should be removed from the list
    When I navigate to players
    And I filter by all teams
    Then the 5 players from "Test Team" should also be deleted
    When I navigate to dashboard
    Then the statistics should reflect the deletion

  # Performance Monitoring Workflow
  Scenario: Monitor team performance over time
    Given team "Chelsea" exists with players having various ratings
    When I generate a player performance report for "Chelsea"
    Then I note the average rating
    When I navigate to players
    And I improve the rating of 3 players
    And I navigate to reports
    And I regenerate the performance report for "Chelsea"
    Then the average rating should have increased
    And the highest rated player may have changed

  # Value Tracking Workflow
  Scenario: Track and update team value composition
    Given team "Arsenal" exists with known player values
    When I generate a value report
    Then I note the total team value
    When I navigate to players
    And I update player values for market changes
    And I navigate to reports
    And I regenerate the value report
    Then the total team value should reflect the updates
    And the most valuable player may have changed

  # Multi-League Management Workflow
  Scenario: Manage teams across different leagues
    Given I have teams from multiple leagues:
      | league          | count |
      | Premier League  | 3     |
      | La Liga         | 2     |
      | Bundesliga      | 2     |
    When I navigate to teams
    And I filter by "Premier League"
    Then I should see 3 teams
    When I change filter to "La Liga"
    Then I should see 2 teams
    When I clear filters
    Then I should see all 7 teams

  # Injury Management Across Multiple Teams
  Scenario: Monitor injuries across entire organization
    Given multiple teams have injured players:
      | team            | injured_count |
      | Team A          | 2             |
      | Team B          | 1             |
      | Team C          | 3             |
    When I navigate to the dashboard
    Then the total injured count should be 6
    When I generate injury reports for each team
    Then each report should show correct injury counts
    And injury rates should be calculated correctly

  # Complete Data Entry and Reporting Workflow
  Scenario: Full workflow from setup to reporting
    Given the database is initially empty
    When I create team "New FC" with complete details
    And I add 11 players with full information including:
      | positions   | count |
      | Goalkeeper  | 1     |
      | Defender    | 4     |
      | Midfielder  | 4     |
      | Forward     | 2     |
    And I set appropriate values for all players
    And I mark 2 players as injured
    And I navigate to reports
    Then I should be able to generate all 4 report types
    And team composition should show correct position distribution
    And injury report should show 2 injured players
    And value report should show total team value
    And performance report should show all players ranked

  # Error Recovery Workflow
  Scenario: Recover from API failures gracefully
    Given the application is running normally
    When the API becomes unavailable
    And I try to load teams
    Then I should see an error message
    And the application should remain functional
    When the API becomes available again
    And I refresh the teams list
    Then teams should load successfully
    And I should be able to continue working normally

  # Accessibility Workflow
  @accessibility
  Scenario: Complete workflow using keyboard only
    Given I am using only keyboard navigation
    When I press Tab to navigate to "Teams" link
    And I press Enter to activate it
    Then the teams section should be displayed
    When I press Tab until I reach "New Team" button
    And I press Enter to open the modal
    Then the team modal should open with focus on first field
    When I fill the form using Tab and typing
    And I press Enter to submit
    Then the team should be created
    And focus should return appropriately

  # Data Consistency Workflow
  Scenario: Verify data consistency across sections
    Given I create team "Consistency FC" with value "1000000"
    And I add player "John Doe" with value "50000"
    When I view the dashboard
    Then the team count should include "Consistency FC"
    When I navigate to teams and search for "Consistency FC"
    Then I should see team value "1000000"
    When I filter players by team "Consistency FC"
    Then I should see "John Doe" with value "50000"
    When I generate a value report for "Consistency FC"
    Then the total value should match the sum of player values

  # Quick Actions Efficiency Workflow
  Scenario: Use quick actions for rapid data entry
    Given I am on the dashboard
    When I use the "Add Team" quick action
    And I quickly enter team details and submit
    Then I should return to the teams section with new team
    When I navigate to dashboard
    And I use the "Add Player" quick action
    And I quickly enter player details and submit
    Then I should return to the players section with new player
    When I navigate to dashboard
    Then both new entries should be reflected in statistics
