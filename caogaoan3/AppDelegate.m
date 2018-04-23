//
//  AppDelegate.m
//  caogaoan3
//
//  Created by XDS on 2018/3/11.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreTextController.h"
#import "RACController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

static int s_fatal_signals[] = {
    SIGABRT,
    SIGBUS,
    SIGFPE,
    SIGILL,
    SIGSEGV,
    SIGTRAP,
    SIGTERM,
    SIGKILL,
};

static const char* s_fatal_signal_names[] = {
    "SIGABRT",
    "SIGBUS",
    "SIGFPE",
    "SIGILL",
    "SIGSEGV",
    "SIGTRAP",
    "SIGTERM",
    "SIGKILL",
};

static int s_fatal_signal_num = sizeof(s_fatal_signals) / sizeof(s_fatal_signals[0]);

void handleEx (NSException * ex)
{
   NSArray <NSString *> *exStackArr = ex.callStackSymbols;
    for (int i = 0; i < exStackArr.count; i++) {
       
        NSLog(@"%@",exStackArr[i]);
    }
    
//    CFRunLoopRef runloop = CFRunLoopGetCurrent();
//    CFArrayRef allModes = CFRunLoopCopyAllModes(runloop);
//
//    {
//        //for (NSString * mode in (__bridge NSArray * )allModes) {
//            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.001, false);
//        //}
//    }
//
//    CFRelease(allModes);
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    for (int i =0 ; i < s_fatal_signal_num; i++) {
        signal(s_fatal_signals[i], handleEx);
    }
    
    NSSetUncaughtExceptionHandler(handleEx);
    
    [self testCrash];
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.rootViewController = [[RACController alloc] init];
//    [self.window makeKeyAndVisible];
    return YES;
}

- (void)testCrash
{
    NSArray * arr = @[@"1",@"2",@"3",@"4",@"5",@"6"];
    NSLog(@"%@",arr[9]);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
