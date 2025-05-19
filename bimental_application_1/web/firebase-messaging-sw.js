importScripts(
  'https://www.gstatic.com/firebasejs/9.6.11/firebase-app-compat.js'
);
importScripts(
  'https://www.gstatic.com/firebasejs/9.6.11/firebase-messaging-compat.js'
);

firebase.initializeApp({
  apiKey: 'AIzaSyD0cCdkkHOnRkb5bloXI1j5rG14a2-5lJw',
  authDomain: 'bimental-eecd7.firebaseapp.com',
  projectId: 'bimental-eecd7',
  storageBucket: 'bimental-eecd7.firebasestorage.app',
  messagingSenderId: '381340908284',
  appId: '1:381340908284:web:28d06242a7d8359c8ab579',
});

const messaging = firebase.messaging();

// Manejar notificaciones en segundo plano (background)
messaging.onBackgroundMessage(function (payload) {
  console.log(
    '[firebase-messaging-sw.js] Received background message',
    payload
  );
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/icons/Icon-192.png', // Cambia esto al path correcto de tu icono si lo tienes
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
