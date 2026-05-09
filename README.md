
# Smart Task Management System

Production-ready Flask Task Management System with:
- JWT Authentication
- REST APIs
- PostgreSQL Integration
- Flask-SocketIO WebSockets
- Pandas & NumPy Analytics
- Responsive HTML/CSS Frontend

## Features
- User Registration/Login
- CRUD Task APIs
- Live Task Updates via WebSockets
- Analytics Dashboard
- PostgreSQL Database
- Clean Modular Architecture

## Tech Stack
- Python 3.11+
- Flask
- PostgreSQL
- SQLAlchemy
- Flask-SocketIO
- Pandas & NumPy
- HTML/CSS/JS

## Project Structure

```
smart_task_manager/
├── app.py
├── config.py
├── requirements.txt
├── .env.example
├── database/
│   └── schema.sql
├── app/
│   ├── __init__.py
│   ├── extensions.py
│   ├── models/
│   ├── routes/
│   ├── services/
│   ├── templates/
│   └── static/
```

## Setup Instructions

### 1. Clone / Extract
```bash
unzip smart_task_manager.zip
cd smart_task_manager
```

### 2. Create Virtual Environment
```bash
python -m venv venv
```

### 3. Activate Environment

Mac/Linux:
```bash
source venv/bin/activate
```

Windows:
```bash
venv\Scripts\activate
```

### 4. Install Dependencies
```bash
pip install -r requirements.txt
```

### 5. PostgreSQL Setup

Create database:
```sql
CREATE DATABASE smart_tasks;
```

### 6. Configure Environment

Rename `.env.example` to `.env`

Update:
```
DATABASE_URL=postgresql://postgres:password@localhost:5432/smart_tasks
SECRET_KEY=supersecretkey
```

### 7. Run Application
```bash
python app.py
```

App URL:
```
http://127.0.0.1:5000
```

## API Endpoints

### Auth
- POST `/api/auth/register`
- POST `/api/auth/login`

### Tasks
- GET `/api/tasks`
- POST `/api/tasks`
- PUT `/api/tasks/<id>`
- DELETE `/api/tasks/<id>`

### Analytics
- GET `/api/analytics`

## WebSocket Event
Real-time task updates are broadcast automatically.

## Assignment Coverage
✔ Flask  
✔ REST APIs  
✔ PostgreSQL  
✔ Pandas & NumPy  
✔ WebSockets  
✔ HTML/CSS  
✔ Authentication  
✔ Clean Code Architecture  
