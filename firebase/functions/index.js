const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {getFirestore} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging");
const {initializeApp} = require("firebase-admin/app");

initializeApp();

exports.notifyInbox = onDocumentCreated(
  "inboxes/{uid}/events/{eventId}",
  async (event) => {
    const uid = event.params.uid;
    const user = await getFirestore().collection("users").doc(uid).get();
    const token = user.get("fcmToken");
    if (!token) return;

    await getMessaging().send({
      token,
      notification: {
        title: "New message",
        body: "Open LocalChat to read it.",
      },
      data: {
        type: "inbox",
      },
    });
  },
);
