# Smart Task Manager Full-Stack Monorepo

This repository contains both the Flask backend and the React frontend and mobile app frontend in one codebase.

## Structure

```text
smart_task_manager_fullstack/
├── backend/
└── flutter_application_1/
└── frontend/
```

## Development

### Terminal 1: Backend
```bash
cd backend
python3.11 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python app.py
```

### Terminal 2: Mobile application
```bash
cd flutter_application_1
flutter pub get
flutter run
```

### Terminal 3: Frontend
```bash
cd frontend
npm install
npm run dev
```

Backend: `http://127.0.0.1:5000`
Frontend: `http://localhost:5173`
flutter_application_1 : run in mobile emulator 

## Production-style option

You can also build the frontend and serve it from Flask after placing the build output in `frontend/dist`.

## Notes
- Backend uses PostgreSQL
- Frontend calls the backend through Vite proxy during development
- Cookie-based authentication is used by the Flask backend

## to run application of front end and backend you can use .sh files also 
