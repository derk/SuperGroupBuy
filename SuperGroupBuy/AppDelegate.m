//
//  AppDelegate.m
//  SuperGroupBuy
//
//  Created by lanouhn on 14-4-10.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "UMSocial.h"
#import "UserInfoHandle.h"
#import "RennSDK/RennSDK.h"
@implementation AppDelegate
-(void)dealloc
{
    [_wbtoken release];
    [super dealloc];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    RootViewController *rootVC = [[RootViewController alloc] init];
    self.window.rootViewController = rootVC;
    
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    [UMSocialData setAppKey:@"533e61c556240b5a190127cc"];
    [RennClient initWithAppId:@"266562"
                       apiKey:@"748a068524d742859762263a4fc88804"
                    secretKey:@"eebb99ebdc274d34a3a351946f89b08d"];
    [RennClient setScope:@"read_user_blog read_user_photo read_user_status read_user_album read_user_comment read_user_share publish_blog publish_share send_notification photo_upload status_update create_album publish_comment publish_feed operate_like"];
    
    if ([RennClient isLogin]) {
        [RennClient logoutWithDelegate:self];
    }
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

-(void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@",[response.userInfo objectForKey:@"access_token"],[response.userInfo objectForKey:@"uid"]];
        NSLog(@"%@",urlString);

        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSDictionary *dic = nil;
        if (data != nil) {
            dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            [UserInfoHandle sharedHanle].userDic = dic;
        }
        
        NSLog(@"%@",dic);
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
    }
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}





- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
