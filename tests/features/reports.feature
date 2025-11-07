Feature: Reports Generation
  As a soccer team manager
  I want to generate various reports about teams and players
  So that I can analyze team composition, performance, value, and injuries

  Background:
    Given the application is loaded
    And I am on the reports section
    And the API is configured and connected
    And at least one team with players exists in the database

  # Team Composition Report
  Scenario: Generate team composition report
    Given team "Manchester United" exists with 11 players
    And the players have various positions and nationalities
    When I select "Team Composition" report type
    And I select "Manchester United" from the team dropdown
    And I click "Generate Report"
    Then the report should be displayed
    And I should see the total number of players
    And I should see positions breakdown
    And I should see nationalities breakdown
    And I should see average rating
    And I should see total team value
    And I should see list of injured players if any

  Scenario: Team composition report shows position distribution
    Given team "Barcelona" has players:
      | name      | position   |
      | Player 1  | Goalkeeper |
      | Player 2  | Defender   |
      | Player 3  | Defender   |
      | Player 4  | Midfielder |
      | Player 5  | Forward    |
    When I generate a team composition report for "Barcelona"
    Then the positions breakdown should show:
      | position   | count |
      | Goalkeeper | 1     |
      | Defender   | 2     |
      | Midfielder | 1     |
      | Forward    | 1     |

  Scenario: Team composition report shows nationality distribution
    Given team "Real Madrid" has players from:
      | nationality |
      | Spain       |
      | Spain       |
      | Brazil      |
      | France      |
      | Spain       |
    When I generate a team composition report for "Real Madrid"
    Then the nationalities breakdown should show:
      | nationality | count |
      | Spain       | 3     |
      | Brazil      | 1     |
      | France      | 1     |

  # Player Performance Report
  Scenario: Generate player performance report
    Given team "Liverpool" has players with various ratings
    When I select "Player Performance" report type
    And I select "Liverpool" from the team dropdown
    And I click "Generate Report"
    Then the report should be displayed
    And I should see all players sorted by rating
    And I should see the highest rated player
    And I should see the lowest rated player
    And I should see the average rating

  Scenario: Player performance report sorts players by rating
    Given team "Chelsea" has players:
      | name      | rating |
      | Player A  | 7      |
      | Player B  | 9      |
      | Player C  | 5      |
      | Player D  | 8      |
    When I generate a player performance report for "Chelsea"
    Then the players should be listed in order:
      | name      | rating |
      | Player B  | 9      |
      | Player D  | 8      |
      | Player A  | 7      |
      | Player C  | 5      |

  Scenario: Player performance report identifies top and bottom performers
    Given team "Arsenal" has players with ratings from 1 to 10
    When I generate a player performance report for "Arsenal"
    Then the highest rated player should be clearly identified
    And the lowest rated player should be clearly identified
    And the average rating should be calculated correctly

  # Value Report
  Scenario: Generate value report
    Given team "Paris Saint-Germain" has players with various values
    When I select "Value Report" report type
    And I select "Paris Saint-Germain" from the team dropdown
    And I click "Generate Report"
    Then the report should be displayed
    And I should see all players sorted by value
    And I should see the most valuable player
    And I should see the least valuable player
    And I should see the total team value
    And I should see the average player value

  Scenario: Value report sorts players by market value
    Given team "Bayern Munich" has players:
      | name      | value     |
      | Player A  | 50000000  |
      | Player B  | 80000000  |
      | Player C  | 30000000  |
      | Player D  | 60000000  |
    When I generate a value report for "Bayern Munich"
    Then the players should be listed in descending order by value:
      | name      | value     |
      | Player B  | 80000000  |
      | Player D  | 60000000  |
      | Player A  | 50000000  |
      | Player C  | 30000000  |

  Scenario: Value report calculates total and average correctly
    Given team "Juventus" has players with values:
      | value     |
      | 10000000  |
      | 20000000  |
      | 30000000  |
      | 40000000  |
    When I generate a value report for "Juventus"
    Then the total value should be "$100,000,000"
    And the average value should be "$25,000,000"

  # Injury Report
  Scenario: Generate injury report
    Given team "AC Milan" has both injured and healthy players
    When I select "Injury Report" report type
    And I select "AC Milan" from the team dropdown
    And I click "Generate Report"
    Then the report should be displayed
    And I should see the total number of players
    And I should see the list of injured players
    And I should see the injury rate percentage
    And injury details should be shown for each injured player

  Scenario: Injury report calculates injury rate correctly
    Given team "Inter Milan" has 20 players
    And 4 players are injured
    When I generate an injury report for "Inter Milan"
    Then the injury rate should be "20%"

  Scenario: Injury report shows no injuries
    Given team "Atletico Madrid" has 15 players
    And no players are injured
    When I generate an injury report for "Atletico Madrid"
    Then the report should show "0" injured players
    And the injury rate should be "0%"

  Scenario: Injury report shows all injured players with details
    Given team "Test Team" has injured players:
      | name      | injury_details        |
      | Player A  | Knee ligament tear    |
      | Player B  | Hamstring strain      |
      | Player C  | Ankle sprain          |
    When I generate an injury report for "Test Team"
    Then I should see all 3 injured players listed
    And each player should have their injury details displayed

  # Report Export
  Scenario: Export report to CSV
    Given I have generated a team composition report
    When I click the "Export to CSV" button
    Then a CSV file should be downloaded
    And the CSV should contain the report data

  Scenario: Export player performance report to CSV
    Given I have generated a player performance report
    When I click the "Export to CSV" button
    Then the exported CSV should include player names and ratings

  # Edge Cases and Validation
  Scenario: Attempt to generate report without selecting a team
    When I select a report type
    And I do not select a team
    And I click "Generate Report"
    Then I should see an error message "Team ID is required"
    And no report should be displayed

  Scenario: Generate report for team with no players
    Given team "Empty Team" exists with 0 players
    When I generate any report type for "Empty Team"
    Then the report should show appropriate empty state
    And no errors should occur

  Scenario: Generate report for non-existent team
    When I attempt to generate a report for a non-existent team ID
    Then I should see an error message "Team not found"
    And no report should be displayed

  Scenario: Switch between different report types
    When I generate a team composition report
    And I change the report type to "Player Performance"
    And I click "Generate Report"
    Then the new report should be displayed
    And the previous report should be replaced

  Scenario: Report filters update based on available teams
    Given teams exist in the database
    When I navigate to the reports section
    Then the team dropdown should be populated with all teams
    And I should be able to select any team

  # Report Display and Formatting
  Scenario: Team composition report formats numbers correctly
    Given a team has a total value of 1234567890
    When I generate a team composition report
    Then the value should be displayed with proper formatting
    And currency symbols should be used appropriately

  Scenario: Reports section shows report results
    When I generate a report
    Then the report results section should become visible
    And the report content should be displayed
    And the export button should be enabled

  Scenario: Hide report results when no report generated
    Given I am on the reports section
    And no report has been generated yet
    Then the report results section should be hidden
    And the export button should not be visible

  # API Error Handling
  Scenario: Handle API failure when generating report
    Given the API is not available
    When I attempt to generate a report
    Then I should see an error notification
    And no report should be displayed

  Scenario: Handle API timeout during report generation
    Given the API takes too long to respond
    When I generate a report
    Then I should see a loading indicator
    And after timeout, an appropriate error message should be shown

  # Accessibility Scenarios
  @accessibility
  Scenario: Navigate reports section with keyboard
    When I navigate to the reports section
    And I use Tab to navigate through controls
    Then I should be able to select report type with keyboard
    And I should be able to select team with keyboard
    And I should be able to generate report with Enter key
    And I should be able to export with keyboard

  @accessibility
  Scenario: Screen reader announces report content
    Given I have generated a report
    When using a screen reader
    Then the report type should be announced
    And the selected team should be announced
    And report statistics should be announced clearly
    And table data should be accessible

  # Report Type Selection
  Scenario Outline: Generate each type of report
    Given team "Test Team" exists with players
    When I select "<report_type>" report type
    And I select "Test Team" from the team dropdown
    And I click "Generate Report"
    Then the "<report_type>" report should be displayed successfully
    
    Examples:
      | report_type        |
      | Team Composition   |
      | Player Performance |
      | Value Report       |
      | Injury Report      |

  # Performance and Data Accuracy
  Scenario: Report generation completes in reasonable time
    Given a team has 100 players
    When I generate a report for that team
    Then the report should be generated within 5 seconds

  Scenario: Report data matches database state
    Given the database has specific player data
    When I generate a report
    Then the report statistics should exactly match the database
    And calculations should be accurate

  Scenario: Report updates when team data changes
    Given I have generated a report for a team
    When the team data is updated in the database
    And I regenerate the report
    Then the report should reflect the updated data
