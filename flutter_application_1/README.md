# Smart Task Manager Flutter Frontend

## Features
- Clean Architecture structure
- Login page
- Register page
- Dashboard page
- Add / Edit / Delete task
- Analytics cards
- Mobile-first UI
- WebSocket notifications
- Secure token storage

## Important backend requirement
Your Flask backend must accept JWT from headers:

```python
JWT_TOKEN_LOCATION = ["headers", "cookies"]
```

Login must return `access_token` in JSON. This Flutter app stores it securely and sends:

```http
Authorization: Bearer <token>
```

## API base URL
Default:
- Android emulator: `http://10.0.2.2:5000`

For iOS simulator:
```bash
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:5000
```

For real device:
```bash
flutter run --dart-define=API_BASE_URL=http://YOUR_MAC_IP:5000
```

## Run
```bash
flutter pub get
flutter run
```
