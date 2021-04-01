#import "AppDelegate.h"

#import <React/RCTBridge.h>

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <RNCPushNotificationIOS.h>
#import <Leanplum/Leanplum.h>
#import <Leanplum/LPPushNotificationsManager.h>
#import <React/RCTLinkingManager.h>

#if DEBUG
#import <FlipperKit/FlipperClient.h>
#import <FlipperKitLayoutPlugin/FlipperKitLayoutPlugin.h>
#import <FlipperKitUserDefaultsPlugin/FKUserDefaultsPlugin.h>
#import <FlipperKitNetworkPlugin/FlipperKitNetworkPlugin.h>
#import <SKIOSNetworkPlugin/SKIOSNetworkAdapter.h>
#import <FlipperKitReactPlugin/FlipperKitReactPlugin.h>


static void InitializeFlipper(UIApplication *application) {
  FlipperClient *client = [FlipperClient sharedClient];
  SKDescriptorMapper *layoutDescriptorMapper = [[SKDescriptorMapper alloc] initWithDefaults];
  [client addPlugin:[[FlipperKitLayoutPlugin alloc] initWithRootNode:application withDescriptorMapper:layoutDescriptorMapper]];
  [client addPlugin:[[FKUserDefaultsPlugin alloc] initWithSuiteName:nil]];
  [client addPlugin:[FlipperKitReactPlugin new]];
  [client addPlugin:[[FlipperKitNetworkPlugin alloc] initWithNetworkAdapter:[SKIOSNetworkAdapter new]]];
  [client start];
}
#endif

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [Leanplum setLogLevel:Debug];
#if DEBUG
  InitializeFlipper(application);
#endif
  
  [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
  
  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"TestPushApp"
                                            initialProperties:nil];

  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
  
  
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray <id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
  
  NSLog(@"[LNOTIF] continueUserActivity %@", userActivity);
  return [RCTLinkingManager application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings{
  NSLog(@"[LNOTIF] didRegisterUserNotificationSettings %@",notificationSettings);
  [RNCPushNotificationIOS didRegisterUserNotificationSettings:notificationSettings];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  NSLog(@"[LNOTIF] openURL %@", url);
  return [RCTLinkingManager application:application openURL:url sourceApplication:sourceApplication annotation:annotation];


}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  NSLog(@"[LNOTIF] didRegisterForRemoteNotificationsWithDeviceToken");
  //NSLog(@"---%@",deviceToken);
  //[FBSDKAppEvents setPushNotificationsDeviceToken:deviceToken];
  [RNCPushNotificationIOS didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}


// Called when notification is received, `completionHandler` must be called ASAP when not in foreground
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
  NSLog(@"[LNOTIF] didReceiveRemoteNotification");
    [RNCPushNotificationIOS didReceiveRemoteNotification:userInfo fetchCompletionHandler:^(UIBackgroundFetchResult rncResult){
      NSLog(@"[LNOTIF] finish notification");
      completionHandler(rncResult);
    }];
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
  NSLog(@"[LNOTIF] didReceiveLocalNotification");
  [RNCPushNotificationIOS didReceiveLocalNotification:notification];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error{
  NSLog(@"[LNOTIF] didFailToRegisterForRemoteNotificationsWithError");
  [RNCPushNotificationIOS didFailToRegisterForRemoteNotificationsWithError:error];
}

// Called when notification is clicked from background or when app is killed
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler
{
  NSLog(@"[LNOTIF] didReceiveNotificationResponse");
  [RNCPushNotificationIOS didReceiveNotificationResponse:response];
}


//Called when a notification is delivered to a foreground app.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
  NSLog(@"[LNOTIF] willPresentNotification");
  completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);

}

@end
