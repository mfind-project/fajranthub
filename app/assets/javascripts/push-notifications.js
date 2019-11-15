PushNotification = {
  isSupported: function () {
    return 'serviceWorker' in navigator && 'PushManager' in window;
  }
}
