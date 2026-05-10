# Smart Task Manager React Frontend

This ZIP converts the frontend to React + Vite and keeps the same dashboard UI style.

## Included
- React pages for Login and Register
- React dashboard
- Add / Edit / Delete task
- Analytics cards
- WebSocket notifications
- Bootstrap Icons via class names
- Responsive UI

## Run
```bash
npm install
npm run dev
```

Backend:
```bash
python app.py
```

React runs on:
- http://127.0.0.1:5173

Backend runs on:
- http://127.0.0.1:5000

## Backend routes expected
- POST /api/auth/register
- POST /api/auth/login
- POST /api/auth/logout
- GET /api/auth/me
- GET /api/tasks
- POST /api/tasks
- PUT /api/tasks/<id>
- DELETE /api/tasks/<id>
- GET /api/analytics
