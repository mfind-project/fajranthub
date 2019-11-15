function isPushNotificationSupported() {
  return 'serviceWorker' in navigator && 'PushManager' in window;
}

export {
  isPushNotificationSupported
}
