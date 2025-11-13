# Soccer Team Management System

A comprehensive web application for managing soccer teams, players, and generating performance reports. This application features a modern frontend interface and a Python Flask backend with SQLite database.

## Overview

The Soccer Team Management System allows users to:
- Manage soccer teams with detailed information including establishment year, home stadium, club colors, and team value
- Track player information including position, performance ratings, injury status, and player values
- Generate various reports including team composition, player performance, value reports, and injury reports
- View dashboard statistics with team and player metrics
- Export report data to CSV format

The application is built with a clean separation between frontend and backend, making it easy to extend and maintain.

## Features

- **Team Management**: Create, read, update, and delete teams with comprehensive details
- **Player Management**: Track player information, injuries, and performance ratings
- **Dashboard**: Real-time statistics showing total teams, players, injured players, and average player values
- **Reporting**: Generate customizable reports with export functionality
- **Search & Filter**: Easily find teams and players using search and filter options
- **Dad Jokes**: Daily dad joke integration for fun (powered by external API)
- **Responsive UI**: Clean, modern interface with modal dialogs for data entry

## Project Structure

```
ghcpsoccer/
├── src/
│   ├── frontend/           # Frontend HTML/CSS/JS files
│   │   ├── index.html      # Main application page
│   │   ├── css/            # Stylesheets
│   │   └── js/             # JavaScript modules
│   │       ├── app.js      # Main application logic
│   │       ├── config.js   # API configuration
│   │       ├── teams.js    # Team management
│   │       ├── players.js  # Player management
│   │       ├── reports.js  # Report generation
│   │       └── settings.js # Settings management
│   └── backend/
│       └── python_api/     # Python Flask API
│           ├── app.py      # Main Flask application
│           ├── utils.py    # Utility functions
│           ├── init_db.py  # Database initialization
│           └── requirements.txt
├── schemas/                # Database schema and sample data
│   ├── schema.sql
│   ├── sample_data.sql
│   └── README.md           # Schema documentation
└── README.md               # This file
```

## Prerequisites

- Python 3.7 or higher
- pip (Python package manager)
- A modern web browser (Chrome, Firefox, Safari, or Edge)

## Installation

### Backend Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/ahmedsza/ghcpsoccer.git
   cd ghcpsoccer
   ```

2. **Navigate to the Python API directory**
   ```bash
   cd src/backend/python_api
   ```

3. **Install Python dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Initialize the database**
   ```bash
   python init_db.py
   ```

5. **(Optional) Seed the database with sample data**
   ```bash
   python seed_api_data.py
   ```

### Frontend Setup

The frontend consists of static HTML, CSS, and JavaScript files that can be served by any web server or opened directly in a browser.

## Usage

### Starting the Backend

1. Navigate to the Python API directory:
   ```bash
   cd src/backend/python_api
   ```

2. Run the Flask application:
   ```bash
   python app.py
   ```

   The API server will start on `http://localhost:5000` by default.

### Accessing the Frontend

1. Open the frontend in your browser:
   - **Option 1**: Open `src/frontend/index.html` directly in your browser
   - **Option 2**: Use a local web server (recommended):
     ```bash
     cd src/frontend
     python -m http.server 8000
     ```
     Then navigate to `http://localhost:8000` in your browser

2. Configure the API connection:
   - Click the settings icon (⚙️) in the top right
   - Ensure the API Base URL is set to `http://localhost:5000/api`
   - Click "Test Connection" to verify the backend is running
   - Click "Save Settings"

### Using the Application

**Dashboard**
- View summary statistics for teams and players
- Access quick actions to add teams, players, or generate reports

**Teams Management**
- Click "Teams" in the navigation to view all teams
- Use the "+ New Team" button to add a team
- Search and filter teams by country or league
- Click "Edit" or "Delete" to manage existing teams

**Players Management**
- Click "Players" in the navigation to view all players
- Use the "New Player" button to add a player
- Filter by team, position, or injury status
- Track player ratings and values

**Reports**
- Click "Reports" in the navigation
- Select a report type (Team Composition, Player Performance, Value Report, or Injury Report)
- Choose filters as needed
- Click "Generate Report" to view results
- Export reports to CSV format

## API Endpoints

The Python Flask backend provides the following REST API endpoints:

- `GET /api/teams` - Get all teams
- `POST /api/teams` - Create a new team
- `GET /api/teams/<id>` - Get a specific team
- `PUT /api/teams/<id>` - Update a team
- `DELETE /api/teams/<id>` - Delete a team
- `GET /api/players` - Get all players
- `POST /api/players` - Create a new player
- `GET /api/players/<id>` - Get a specific player
- `PUT /api/players/<id>` - Update a player
- `DELETE /api/players/<id>` - Delete a player
- `GET /api/reports/<report_type>` - Generate a report
- `GET /api/health` - Health check endpoint

For detailed schema information, see [schemas/README.md](schemas/README.md).

## Database

The application uses SQLite as the database backend. The database file is created at `src/backend/python_api/instance/soccer_app.db` when you run the initialization script.

### Database Schema

- **Teams Table**: Stores team information including name, country, league, stadium, value, and more
- **Players Table**: Stores player information including name, position, team, ratings, injury status, and more

See the [schemas documentation](schemas/README.md) for complete schema details.

## Configuration

The frontend configuration can be modified in `src/frontend/js/config.js`:
- API base URL
- Default settings
- Cache busting version numbers

The backend configuration is in `src/backend/python_api/app.py`:
- Database connection string
- CORS settings
- Flask configuration

## Development

This project is designed to showcase GitHub Copilot features and demonstrate modern web development practices.

### Technology Stack

**Frontend:**
- HTML5
- CSS3 (with custom styling)
- Vanilla JavaScript (ES6+)
- Modular JavaScript architecture

**Backend:**
- Python 3
- Flask web framework
- SQLAlchemy ORM
- Flask-CORS for cross-origin requests
- SQLite database

## Contributing

Contributions are welcome! If you'd like to contribute to this project:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is available as a demonstration application. Please check with the repository owner for specific license terms.

## Contact

For questions or issues, please open an issue on the GitHub repository.

## Acknowledgments

- Built as a demonstration of GitHub Copilot capabilities
- Dad jokes provided by icanhazdadjoke API
- Inspired by modern soccer team management needs