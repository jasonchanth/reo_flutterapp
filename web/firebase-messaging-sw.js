importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

firebase.initializeApp({
   apiKey: "AIzaSyBJDIAr7cJsryK_fGxpUAFXLwP5Q6YEhhA",
    authDomain: "helpdeskdemo-11bef.firebaseapp.com",
    projectId: "helpdeskdemo-11bef",
    storageBucket: "helpdeskdemo-11bef.appspot.com",
    messagingSenderId: "144700325122",
    appId: "1:144700325122:web:4cd2ad419da5655610961b",
    measurementId: "G-RS1P3VRV1B"
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});