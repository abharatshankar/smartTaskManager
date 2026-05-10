
# Smart Task Management System

This version keeps the original dashboard UI and fixes authentication + CRUD.

## Behavior
- `/` redirects to login
- `/login` always shows login page
- `/register` always shows register page
- `/dashboard` shows protected dashboard only when logged in

## Setup
```bash
python3.11 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python app.py
```

## Database
Create a PostgreSQL database named `smart_tasks`.

## Endpoints
- POST `/api/auth/register`
- POST `/api/auth/login`
- POST `/api/auth/logout`
- GET `/api/auth/me`
- GET `/api/tasks`
- POST `/api/tasks`
- PUT `/api/tasks/<id>`
- DELETE `/api/tasks/<id>`
- GET `/api/analytics`
