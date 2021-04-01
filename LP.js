// @flow strict
import {Platform} from 'react-native';
import {Leanplum} from '@leanplum/react-native-sdk';
import PushNotificationIOS from '@react-native-community/push-notification-ios';

const LPKeys = require('./keys.json');
Leanplum.onStartResponse(i => {
  if (i) {
    Platform.OS === 'ios' && PushNotificationIOS.requestPermissions();

    Leanplum.setUserId('useridfortest');
  } else {
    console.warn('leanplumjs not launched');
  }
});

const defaultExport = {
  getIdToken: () => Leanplum.deviceId(),
  start: () => {
    Leanplum.setAppVersion('test-notif');
    Leanplum.trackAllAppScreens();
    // Leanplum.onMessageDisplayed(console.log);
    if (__DEV__)
      Leanplum.setAppIdForDevelopmentMode(LPKeys.appkey, LPKeys.devkey);
    else Leanplum.setAppIdForProductionMode(LPKeys.appkey, LPKeys.prodkey);
    Leanplum.start();
  },
};

PushNotificationIOS.addEventListener('notification', notification => {
  console.log('new notif', notification);
  notification.finish(PushNotificationIOS.FetchResult.NoData);
});

export default defaultExport;
