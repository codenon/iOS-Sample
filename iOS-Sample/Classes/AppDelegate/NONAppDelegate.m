//
//  AppDelegate.m
//  iOS-Sample
//
//  Created by negwiki on 16/1/24.
//  Copyright © 2016年 negwiki. All rights reserved.
//

#import "APIKey.h"
#import "BPush.h"
#import "NONAppDelegate.h"

#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>

@interface NONAppDelegate ()

@end

@implementation NONAppDelegate

#pragma mark AMap
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)configureAMapAPIKey {
  if ([APIKey length] == 0) {
    NSString *reason =
        [NSString stringWithFormat:@"apiKey为空，请检查key是否正确设置。"];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:reason
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
  }

  //[MAMapServices sharedServices].apiKey = (NSString *)APIKey;
  //[AMapLocationServices sharedServices].apiKey = (NSString *)APIKey;
}
#pragma clang diagnostic pop

#pragma mark Baidu push
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)registerBaiduPushNotification:(NSDictionary *)launchOptions {
  // iOS8 下需要使用新的 API
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
    UIUserNotificationType myTypes = UIUserNotificationTypeBadge |
                                     UIUserNotificationTypeSound |
                                     UIUserNotificationTypeAlert;

    UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
    [[UIApplication sharedApplication]
        registerUserNotificationSettings:settings];
  } else {

    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
                                       UIRemoteNotificationTypeAlert |
                                       UIRemoteNotificationTypeSound;

    [[UIApplication sharedApplication]
        registerForRemoteNotificationTypes:myTypes];
  }

  // 在 App 启动时注册百度云推送服务，需要提供 Apikey
  [BPush registerChannel:launchOptions
                  apiKey:@"KeFXozWzGq0LdMHTsuAluMDk"
                pushMode:BPushModeDevelopment
         withFirstAction:nil
        withSecondAction:nil
            withCategory:nil
                 isDebug:YES];

  // App 是用户点击推送消息启动
  NSDictionary *userInfo = [launchOptions
      objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
  if (userInfo) {
    NSLog(@"从消息启动:%@", userInfo);
    [BPush handleNotification:userInfo];
  }

  //角标清0
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

  //测试本地通知
  [self performSelector:@selector(testLocalNotification)
             withObject:nil
             afterDelay:1.0];
}
- (void)testLocalNotification {
  NSLog(@"测试本地通知啦！！！");
  NSDate *fireDate = [[NSDate new] dateByAddingTimeInterval:5];
  [BPush localNotification:fireDate
                 alertBody:@"这是本地通知"
                     badge:3
           withFirstAction:@"打开"
          withSecondAction:@"关闭"
                  userInfo:nil
                 soundName:nil
                    region:nil
        regionTriggersOnce:YES
                  category:nil];
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application
    didRegisterUserNotificationSettings:
        (UIUserNotificationSettings *)notificationSettings {

  [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  NSLog(@"test:%@", deviceToken);
  [BPush registerDeviceToken:deviceToken];
  [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
    //[self.viewController
    // addLogString:[NSString stringWithFormat:@"Method: %@\n%@",
    //    BPushRequestMethodBind,
    //  result]];
    // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
    if (result) {
      [BPush setTag:@"Mytag"
          withCompleteHandler:^(id result, NSError *error) {
            if (result) {
              NSLog(@"设置tag成功");
            }
          }];
    }
  }];

  // 打印到日志 textView 中
  //[self.viewController
  // addLogString:[NSString stringWithFormat:@"Register use deviceToken : %@",
  // deviceToken]];
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application
    didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  NSLog(@"DeviceToken 获取失败，原因：%@", error);
}

// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo
          fetchCompletionHandler:
              (void (^)(UIBackgroundFetchResult))completionHandler {
  completionHandler(UIBackgroundFetchResultNewData);
  // 打印到日志 textView 中
  NSLog(@"********** iOS7.0之后 background **********");
  // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
  if (application.applicationState == UIApplicationStateActive ||
      application.applicationState == UIApplicationStateBackground) {
    NSLog(@"acitve or background");
    UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"收到一条消息"
                                   message:userInfo[@"aps"][@"alert"]
                                  delegate:self
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@"确定", nil];
    [alertView show];
  } else { //杀死状态下，直接跳转到跳转页面。

    // SkipViewController *skipCtr = [[SkipViewController alloc] init];
    // 根视图是nav 用push 方式跳转
    //[_tabBarCtr.selectedViewController pushViewController:skipCtr
    // animated:YES];
    /*
     // 根视图是普通的viewctr 用present跳转
     [_tabBarCtr.selectedViewController presentViewController:skipCtr
     animated:YES completion:nil]; */
  }
  //[self.viewController
  // addLogString:[NSString stringWithFormat:@"backgroud : %@", userInfo]];
}

- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo {
  // App 收到推送的通知
  [BPush handleNotification:userInfo];
  NSLog(@"********** ios7.0之前 **********");
  // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
  if (application.applicationState == UIApplicationStateActive ||
      application.applicationState == UIApplicationStateBackground) {
    NSLog(@"acitve or background");
    UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"收到一条消息"
                                   message:userInfo[@"aps"][@"alert"]
                                  delegate:self
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@"确定", nil];
    [alertView show];
  } else { //杀死状态下，直接跳转到跳转页面。
    //    SkipViewController *skipCtr = [[SkipViewController alloc] init];
    //    [_tabBarCtr.selectedViewController pushViewController:skipCtr
    //    animated:YES];
  }

  NSLog(@"%@", userInfo);
}

- (void)application:(UIApplication *)application
    didReceiveLocalNotification:(UILocalNotification *)notification {
  NSLog(@"接收本地通知啦！！！");
  [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}
#pragma clang diagnostic pop

#pragma mark application lifecycle method
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSLog(@"%@", NSStringFromSelector(_cmd));

  [self registerBaiduPushNotification:launchOptions];
  [self configureAMapAPIKey];

  return YES;
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
  NSLog(@"%@", NSStringFromSelector(_cmd));
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
  NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationWillResignActive:(UIApplication *)application {
  NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationWillTerminate:(UIApplication *)application {
  NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
