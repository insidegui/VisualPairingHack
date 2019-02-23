//
//  AppDelegate.m
//  VisualPairingHack
//
//  Created by Guilherme Rambo on 23/02/19.
//  Copyright © 2019 Guilherme Rambo. All rights reserved.
//

#import "AppDelegate.h"

#import "MagicCodeViewController.h"
#import "MagicScannerViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) UITabBarController *tabController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = [[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/VisualPairing.framework"] load];
    assert(result);

    self.window = [UIWindow new];

    MagicCodeViewController *codeController = [MagicCodeViewController new];
    MagicScannerViewController *scannerController = [MagicScannerViewController new];

    self.tabController = [UITabBarController new];

    self.tabController.viewControllers = @[codeController, scannerController];

    self.window.rootViewController = self.tabController;

    [self.window makeKeyAndVisible];

    return YES;
}

@end
