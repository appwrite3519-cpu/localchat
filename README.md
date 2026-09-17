# LocalChat

Phone-number messenger. Chat history is stored in an **encrypted Hive database on each phone**. Firebase is only used for OTP, a user directory, a short-lived inbox relay, and push wake-up.

Repository: https://github.com/appwrite3519-cpu/localchat

## Features

- Phone OTP login
- Profile name + photo
- Start 1-to-1 chat by E.164 phone number
- Text chat
- Encrypted on-device store (AES key in Keystore / Keychain)
- Offline compose (`pending` → outbox retry)
- Auto-sync every 20s and when the network returns
- FCM hook via Cloud Function

## Run

```bash
git clone https://github.com/appwrite3519-cpu/localchat.git
cd localchat
flutter create . --project-name localchat --org com.example
flutter pub get
dart pub global activate flutterfire_cli
flutterfire configure
```

Firebase console:

1. Authentication → Phone
2. Firestore + Storage
3. Publish `firebase/firestore.rules`
4. Add a test phone number
5. Add Android SHA-1 for real-device OTP
6. Optional: deploy `firebase/functions/index.js`

```bash
flutter run
```

## Message path

1. Send writes locally first (works offline).
2. Outbox copies the message to `inboxes/{peer}/events/{id}`.
3. Receiver drains that inbox into local Hive and deletes the relay row.
4. Push only wakes the app; history is never the server copy.
