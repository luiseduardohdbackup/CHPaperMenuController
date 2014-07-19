//
//  CHAppDelegate.m
//  CHPaperMenuController
//
//  Created by Christian Hatch on 6/21/14.
//  Copyright (c) 2014 Christian Hatch. All rights reserved.
//

#import "CHAppDelegate.h"
#import "CHPaperMenuController.h"

#import "CHBackViewController.h"
#import <Tweaks/FBTweakShakeWindow.h>



@interface CHAppDelegate ()

///The front window, which covers the status bar.
@property (nonatomic, strong) UIWindow *frontWindow;

///The back window, which holds the tableview.
@property (nonatomic, strong) UIWindow *backWindow;

@end



@implementation CHAppDelegate

#pragma mark - Overrides

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CHPaperMenuController *apm = [CHPaperMenuController paperMenuControllerWithFrontWindow:self.frontWindow
                                                                                backWindow:self.backWindow];
    self.frontWindow.rootViewController = apm;
    
    CHBackViewController *inbox = [CHBackViewController backViewController];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:inbox];
    self.backWindow.rootViewController = nav;
    
    [self.backWindow makeKeyAndVisible];
    [self.frontWindow makeKeyAndVisible];

    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - Getters

- (UIWindow *)frontWindow
{
    if (!_frontWindow)
    {
#ifdef DEBUG
        _frontWindow = [[FBTweakShakeWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
#else
        _frontWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
#endif
        _frontWindow.windowLevel = UIWindowLevelStatusBar;
    }
    return _frontWindow;
}

- (UIWindow *)backWindow
{
    if (!_backWindow)
    {
//#ifdef DEBUG
//        _backWindow = [[FBTweakShakeWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//#else
        _backWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//#endif
    }
    return _backWindow;
}

- (CHPaperMenuController *)paperMenuController
{
    return (CHPaperMenuController *)self.frontWindow.rootViewController;
}



#pragma mark - UIApplication Delegate Callbacks

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
