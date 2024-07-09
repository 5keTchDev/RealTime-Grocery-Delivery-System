importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");


console.log('hii');


firebase.initializeApp({
    apiKey: "AIzaSyD-0tscLDLAcuAK6p8E6reC0TU9C3p0Mew",

    authDomain: "sabjitaja-45326.firebaseapp.com",

    projectId: "sabjitaja-45326",

    storageBucket: "sabjitaja-45326.appspot.com",

    messagingSenderId: "977431736891",

    appId: "1:977431736891:web:c6b3dabe3a3827a1d6a21e",

    measurementId: "G-JJZJ8NBNW7"
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);
});

// const firebaseConfig = {

//     apiKey: "AIzaSyD-0tscLDLAcuAK6p8E6reC0TU9C3p0Mew",

//     authDomain: "sabjitaja-45326.firebaseapp.com",

//     projectId: "sabjitaja-45326",

//     storageBucket: "sabjitaja-45326.appspot.com",

//     messagingSenderId: "977431736891",

//     appId: "1:977431736891:web:c6b3dabe3a3827a1d6a21e",

//     measurementId: "G-JJZJ8NBNW7"

// };


// // Initialize Firebase

// const app = initializeApp(firebaseConfig);

// const analytics = getAnalytics(app);
// // Necessary to receive background messages:
// const messaging = firebase.messaging();
// console.log('hii');
// messaging.setBackgroundMessageHandler(function (payload) {
//     const promiseChain = clients
//         .matchAll({
//             type: "window",
//             includeUncontrolled: true
//         })
//         .then(windowClients => {
//             for (let i = 0; i < windowClients.length; i++) {
//                 const windowClient = windowClients[i];
//                 windowClient.postMessage(payload);
//             }
//         })
//         .then(() => {
//             return registration.showNotification("New Message");
//         });
//     return promiseChain;
// });
// self.addEventListener('notificationclick', function (event) {
//     console.log('notification received: ', event)
// });