# LocalChat setup (do this on your computer)

This environment cannot compile an APK. The app source is complete. You run it with Flutter + Firebase.

## 1. Install Flutter

https://docs.flutter.dev/get-started/install

Confirm:

```bash
flutter doctor
```

You need an Android emulator or a USB-connected phone.

## 2. Clone and generate platform folders

```bash
git clone https://github.com/appwrite3519-cpu/localchat.git
cd localchat
flutter create . --project-name localchat --org com.example
```

`flutter create .` adds `android/` and `ios/` without wiping `lib/`.

## 3. Firebase

1. Create a project at https://console.firebase.google.com
2. Enable Authentication → Sign-in method → Phone
3. Create Firestore (start in production mode)
4. Enable Storage
5. Add an Android app with package `com.example.localchat`
6. Download `google-services.json` into `android/app/` (flutterfire does this)

```bash
dart pub global activate flutterfire_cli
flutterfire configure
flutter pub get
```

Replace the stub `lib/firebase_options.dart` with the generated file.

## 4. Firestore rules

In Firestore → Rules, paste `firebase/firestore.rules` and Publish.

## 5. Test numbers

Authentication → Phone → Phone numbers for testing  
Add `+2348011111111` / `123456` and a second number for the other phone.

## 6. Run two devices

```bash
flutter run
```

On device A: register number 1, set a name.  
On device B: register number 2, set a name.  
On A: New chat → enter B’s E.164 number → send.  
Turn on airplane mode, send another message, then turn network back on. It should go out from the outbox.

## 7. Push (optional)

```bash
cd firebase/functions
npm init -y
npm i firebase-admin firebase-functions
firebase deploy --only functions
```
