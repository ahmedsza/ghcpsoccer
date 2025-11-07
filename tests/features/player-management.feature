Feature: Player Management
  As a soccer team manager
  I want to manage player information
  So that I can track player details, injuries, and performance

  Background:
    Given the application is loaded
    And I am on the players section
    And the API is configured and connected
    And at least one team exists in the database

  # Happy Path Scenarios
  Scenario: Create a new player with complete information
    Given a team "Manchester United" exists
    When I click the "New Player" button
    And I fill in the player form with:
      | field         | value              |
      | Full Name     | Cristiano Ronaldo  |
      | Date of Birth | 1985-02-05         |
      | Nationality   | Portugal           |
      | Position      | Forward            |
      | Jersey Number | 7                  |
      | Height        | 187                |
      | Weight        | 84                 |
      | Team          | Manchester United  |
      | Player Value  | 50000000           |
      | Injury Status | Not Injured        |
      | Rating        | 9                  |
    And I submit the player form
    Then a new player should be created successfully
    And I should see "Cristiano Ronaldo" in the players list
    And the player modal should close

  Scenario: Create an injured player with injury details
    When I click the "New Player" button
    And I fill in the required player fields
    And I select "Injured" for injury status
    And I enter "Knee ligament tear" as injury details
    And I submit the player form
    Then the player should be created with injury status set to injured
    And the injury details should be saved

  Scenario: View list of all players
    Given the database contains the following players:
      | name           | team           | position   | rating |
      | Lionel Messi   | PSG            | Forward    | 10     |
      | Kevin De Bruyne| Manchester City| Midfielder | 9      |
      | Virgil van Dijk| Liverpool      | Defender   | 9      |
    When I navigate to the players section
    Then I should see 3 players in the list
    And each player should display name, team, position, rating, value, and injury status

  Scenario: Edit an existing player
    Given a player "Mohamed Salah" exists with rating "8"
    When I click the edit button for "Mohamed Salah"
    And I change the rating to "9"
    And I submit the player form
    Then the player "Mohamed Salah" should have rating "9"
    And the updated information should be displayed

  Scenario: Delete a player
    Given a player "Test Player" exists
    When I click the delete button for "Test Player"
    And I confirm the deletion
    Then the player "Test Player" should be removed from the list
    And the player should no longer exist in the database

  # Search and Filter Scenarios
  Scenario: Search players by name
    Given the database contains players with names:
      | name              |
      | Harry Kane        |
      | Erling Haaland    |
      | Kylian Mbappe     |
    When I enter "Kane" in the player search box
    Then I should see only 1 player
    And I should see "Harry Kane" in the results

  Scenario: Filter players by team
    Given the database contains players from different teams:
      | name          | team       |
      | Player A      | Team One   |
      | Player B      | Team One   |
      | Player C      | Team Two   |
    When I select "Team One" from the team filter
    Then I should see 2 players
    And all displayed players should be from "Team One"

  Scenario: Filter players by position
    Given the database contains players with different positions:
      | name      | position   |
      | Player 1  | Goalkeeper |
      | Player 2  | Defender   |
      | Player 3  | Midfielder |
      | Player 4  | Forward    |
    When I select "Midfielder" from the position filter
    Then I should see only players with position "Midfielder"

  Scenario: Filter players by injury status - show only injured
    Given the database contains:
      | name      | injured |
      | Player A  | true    |
      | Player B  | false   |
      | Player C  | true    |
      | Player D  | false   |
    When I select "Injured" from the injury filter
    Then I should see 2 players
    And all displayed players should have injury status "Injured"

  Scenario: Filter players by injury status - show only healthy
    Given the database contains injured and healthy players
    When I select "Healthy" from the injury filter
    Then I should see only players who are not injured

  Scenario: Combine multiple filters
    Given the database contains multiple players
    When I enter "John" in the search box
    And I select a specific team from the team filter
    And I select "Forward" from the position filter
    And I select "Healthy" from the injury filter
    Then I should see only players matching all criteria

  # Edge Cases
  Scenario: Create player with minimum required fields
    When I click the "New Player" button
    And I fill in only the required fields:
      | field         | value           |
      | Full Name     | Minimal Player  |
      | Date of Birth | 2000-01-01      |
      | Nationality   | USA             |
      | Position      | Midfielder      |
      | Jersey Number | 10              |
      | Height        | 180             |
      | Weight        | 75              |
      | Team          | Test Team       |
      | Player Value  | 1000000         |
      | Rating        | 5               |
    And I submit the player form
    Then a new player should be created successfully

  Scenario: View players when no players exist
    Given the database contains no players
    When I navigate to the players section
    Then I should see "No players found" or empty list message

  Scenario: Player form populates team dropdown
    When I click the "New Player" button
    Then the team dropdown should contain all available teams
    And each team should be selectable

  Scenario: Update player from healthy to injured
    Given a healthy player "Test Player" exists
    When I edit the player
    And I change injury status to "Injured"
    And I enter injury details
    And I submit the form
    Then the player should be marked as injured
    And injury details should be visible

  Scenario: Update player from injured to healthy
    Given an injured player "Test Player" exists with injury details
    When I edit the player
    And I change injury status to "Not Injured"
    And I submit the form
    Then the player should be marked as healthy
    And injury details should be cleared

  # Validation and Error Scenarios
  Scenario: Attempt to create player without required fields
    When I click the "New Player" button
    And I leave the full name field empty
    And I attempt to submit the form
    Then I should see a validation error
    And the form should not be submitted

  Scenario: Create player with invalid date of birth
    When I try to create a player with birth date "2025-01-01"
    Then I should see a validation error about future dates

  Scenario: Create player with invalid rating
    When I click the "New Player" button
    And I fill in required fields
    And I enter "15" as the rating
    And I attempt to submit the form
    Then I should see a validation error indicating rating must be between 1-10

  Scenario: Create player with rating below minimum
    When I enter "0" as the rating
    Then I should see a validation error

  Scenario: Create player with invalid jersey number
    When I enter "-1" as the jersey number
    Then I should see a validation error

  Scenario: Create player with duplicate jersey number on same team
    Given a player exists on "Team A" with jersey number "10"
    When I try to create another player on "Team A" with jersey number "10"
    Then I should see a warning or validation message about duplicate jersey numbers

  Scenario: Handle API failure when loading players
    Given the API is not available
    When I navigate to the players section
    Then I should see an error message
    And the players list should indicate a loading failure

  Scenario: Handle API failure when creating player
    Given the API will return an error
    When I attempt to create a new player
    Then I should see an error notification
    And the player should not be added to the list

  # Position-specific Scenarios
  Scenario Outline: Create players for each position
    When I create a player with position "<position>"
    Then the player should be created successfully
    And the position should be displayed as "<position>"
    
    Examples:
      | position   |
      | Goalkeeper |
      | Defender   |
      | Midfielder |
      | Forward    |

  # Performance Rating Scenarios
  Scenario Outline: Create players with various ratings
    When I create a player with rating <rating>
    Then the player should be created successfully
    And the rating should be displayed correctly
    
    Examples:
      | rating |
      | 1      |
      | 5      |
      | 10     |

  # Accessibility Scenarios
  @accessibility
  Scenario: Navigate player form with keyboard
    When I click the "New Player" button
    And I use Tab to navigate through form fields
    Then I should be able to reach all form inputs
    And I should be able to toggle injury status with keyboard
    And I should be able to submit using Enter key

  @accessibility
  Scenario: Screen reader announces player information
    Given players exist in the database
    When I navigate to the players section using a screen reader
    Then each player's information should be announced
    And injury status should be clearly communicated
    And action buttons should have descriptive labels

  @accessibility
  Scenario: Injury details field conditional visibility
    When I am on the new player form
    And I select "Not Injured" for injury status
    Then the injury details field should not be visible
    When I select "Injured" for injury status
    Then the injury details field should become visible
    And it should be accessible via keyboard

  # Boundary Tests
  Scenario: Create player with maximum height value
    When I create a player with height "250" cm
    Then the player should be created successfully

  Scenario: Create player with minimum height value
    When I create a player with height "150" cm
    Then the player should be created successfully

  Scenario: Create player with very large value
    When I create a player with value "200000000"
    Then the player should be created successfully
    And the value should be displayed with proper formatting

  Scenario: Player name with special characters
    When I create a player with name "Müller-Öğüt"
    Then the player should be created successfully
    And the name should be displayed correctly

  # Team Association Scenarios
  Scenario: View players associated with a specific team
    Given team "Barcelona" has 3 players
    When I filter by team "Barcelona"
    Then I should see exactly 3 players
    And all should be associated with "Barcelona"

  Scenario: Update player's team assignment
    Given a player "Test Player" is assigned to "Team A"
    When I edit the player
    And I change the team to "Team B"
    And I submit the form
    Then the player should be associated with "Team B"
    And the change should be reflected in the players list
