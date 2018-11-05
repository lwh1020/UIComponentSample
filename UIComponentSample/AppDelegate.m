//
//  AppDelegate.m
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 17..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import "AppDelegate.h"

#define JAILBROKEN_FILE_LIST    @[ \
@"/Applications/Cydia.app", \
@"/Library/MobileSubstrate/MobileSubstrate.dylib", \
@"/bin/bash", \
@"/usr/sbin/sshd", \
@"/etc/apt", \
@"/Applications/Flex.app", \
@"/Applications/Snoop-it Config.app", \
@"/Preferences/kr.typostudio.tsprotector.plist", \
@"/Applications/RockApp.app", \
@"/Applications/Icy.app", \
@"/usr/bin/sshd", \
@"/usr/libexec/sftp-server", \
@"/Applications/WinterBoard.app", \
@"/Applications/SBSettings.app", \
@"/Applications/MxTube.app", \
@"/Applications/InteliScreen.app", \
@"/Library/MobileSubstrate/DynamicLibraries/Veency.plist", \
@"/Applications/FakeCarrier.app", \
@"/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",\
@"/private/var/lib/apt", \
@"/Applications/blackra1n.app", \
@"/private/var/stash", \
@"/private/var/mobile/Library/SBSettings/Themes", \
@"/System/Library/LaunchDaemons/com.ikey.bbot.plist", \
@"/System/Library/LaunchDaemons/com.saurik.Cydia.startup.plist", \
@"/private/var/tmp/cydia.log", \
@"/private/var/lib/cydia" \
]

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self networkCheck];
    
    return YES;
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
    
    if ([self isJailbroken]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Jailbroken" message:@"This device is jailbroken. \nQuit the app." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            exit(0);
        }];
        
        [alert addAction:action];
        [[AppUtility getRootTopMostViewController] presentViewController:alert animated:YES completion:nil];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)networkCheck {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.networkReach = [Reachability reachabilityForInternetConnection];
    [self.networkReach startNotifier];
    
    [self updateInterfaceWithReachability:self.networkReach];
}

- (void)reachabilityChanged:(NSNotification *)note {
    
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)curReach {
    
    if (curReach == self.networkReach) {
        
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        switch (netStatus) {
            case NotReachable: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"Failed to connect." preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        
                        self.networkReach = [Reachability reachabilityForInternetConnection];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                            [self updateInterfaceWithReachability:self.networkReach];
                        });
                        
                        [alert dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                        
                        [alert dismissViewControllerAnimated:YES completion:nil];
                        exit(0);
                    }];
                    
                    [alert addAction:okAction];
                    [alert addAction:cancelAction];
                    
                    [[AppUtility getRootTopMostViewController] presentViewController:alert animated:YES completion:nil];
                    NSLog(@">> Network Error");
                });
            }
                break;
                
            default:
                break;
        }
    }
}

- (BOOL)isJailbroken {
    
#if !(TARGET_IPHONE_SIMULATOR)
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    for (NSString *filePath in JAILBROKEN_FILE_LIST) {
        if ([fileManager fileExistsAtPath:filePath]) {
            return YES;
        }
    }
    
    NSError *error;
    NSString *stringToBeWritten = @"This is a test.";
    
    [stringToBeWritten writeToFile:@"/private/jailbreak.txt" atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (error == nil) { //Device is jailbroken
        return YES;
        
    } else { //Device is not jailbroken
        [[NSFileManager defaultManager] removeItemAtPath:@"/private/jailbreak.txt" error:nil];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]]) {
        //Device is jailbroken
        return YES;
    }
#endif
    return NO;
}

@end
