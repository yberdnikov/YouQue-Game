//
//  Connect5AppDelegate.m
//  Connect5
//
//  Created by Mohammed Eldehairy on 6/20/13.
//  Copyright (c) 2013 Mohammed Eldehairy. All rights reserved.
//

#import "Connect5AppDelegate.h"

#import "MainMenuViewController.h"

@implementation Connect5AppDelegate

- (void)dealloc
{
   
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil] ;
    } else {
        self.viewController = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil] ;
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = nav;
    [self authenticateLocalPlayer];
    [self.window makeKeyAndVisible];
    
    if(floorf([[UIDevice currentDevice] systemVersion].floatValue)>= 7)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }
    return YES;
}
- (void) authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    __weak GKLocalPlayer *player = localPlayer;
    
    if((floorf([[UIDevice currentDevice] systemVersion].floatValue))>=6)
    {
        localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
            if (viewController != nil)
            {
                
                
                [self.window.rootViewController presentModalViewController:viewController animated:YES];
            }
            else if (player.isAuthenticated)
            {
                
            }
            else
            {
                
            }
        };
    }else{
        
        [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
            if (localPlayer.isAuthenticated)
            {
                
            }
        }];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*if([[((UINavigationController*)self.window.rootViewController) topViewController] isKindOfClass:[Connect5ViewController class]])
    {
        [((Connect5ViewController*)[((UINavigationController*)self.window.rootViewController) topViewController]) saveGame];
    }*/
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
-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return UIInterfaceOrientationMaskPortrait;
    }else
    {
        return UIInterfaceOrientationMaskAll;
    }
    
}

@end
