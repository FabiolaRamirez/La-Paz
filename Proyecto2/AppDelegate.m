//
//  AppDelegate.m
//  Proyecto2
//
//  Created by Fabiola Ramirez on 28/04/14.
//  Copyright (c) 2014 Fabiola Ramirez. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "UIColor+LaPaz.h"
//#import <ParseFacebookUtils/PFFacebookUtils.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //Parse
    [Parse setApplicationId:@"7zhX4zytyA24tWtRSAnos5HvbPLOdzpTCrWkNEuY"
                  clientKey:@"XMRL8gP5x5DlZev2oL4cDVNRcOwOlQZcsxzrFZDO"];
    //enviar estadisticas parse
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //facebook/parse
    [PFFacebookUtils initializeFacebook];
    
    //PERSONALIZAR NAVIGATIONS
    [[UINavigationBar appearance] setBarTintColor:[UIColor primaryColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [[UITabBar appearance] setTintColor:[UIColor primaryColor]];
    [[UIToolbar appearance] setTintColor:[UIColor primaryColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
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
    //facebook/parse
   [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //facebook/parse
    [[PFFacebookUtils session] close];
}
//facebook/parse
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}




@end
