//
//  playAppDelegate.m
//  play
//
//  Created by Dave Albert on 14/12/2011.
//  Copyright 2011 Hermitage Medical Clinic. All rights reserved.
//

#import "playAppDelegate.h"
#import "playViewController.h"

@implementation playAppDelegate


@synthesize window=_window;
@synthesize viewController=_viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
     

    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    self.viewController.defaults = [NSUserDefaults standardUserDefaults];

    NSData *data = [self.viewController.defaults objectForKey:@"userMedia"];
    if (data != nil) {
        self.viewController.userMediaItemCollection = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self.viewController.musicPlayer setQueueWithItemCollection: self.viewController.userMediaItemCollection];

        data = [self.viewController.defaults objectForKey:@"nowPlaying"];
        [self.viewController.musicPlayer setNowPlayingItem:[NSKeyedUnarchiver unarchiveObjectWithData:data]];    

        
        self.viewController.musicPlayer.currentPlaybackTime = [self.viewController.defaults doubleForKey:@"audioTime"];
        
        [self.viewController.musicPlayer play];
        self.viewController.toggleButton.titleLabel.tag = 1;
        [self.viewController.toggleButton setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];

        [self.viewController.songTitle setText:[[self.viewController.musicPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyTitle]];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */

    
//    long currentPlaybackTime = self.viewController.musicPlayer.currentPlaybackTime;
//    int currentHours = (currentPlaybackTime / 3600);
//    int currentMinutes = ((currentPlaybackTime / 60) - currentHours*60);
//    int currentSeconds = (currentPlaybackTime % 60);
//    NSString *theTime = [NSString stringWithFormat:@"%i:%02d:%02d", currentHours, currentMinutes, currentSeconds];
    
    
 
    

}
//
//- (BOOL)canBecomeFirstResponder {
//    NSLog(@"canBecomeFirstResponder");
//    return YES;
//}
//
//- (void)remoteControlReceivedWithEvent:(UIEvent *)theEvent 
//{
//	if (theEvent.type == UIEventTypeRemoteControl) {
//        switch(theEvent.subtype) {
//            case UIEventSubtypeRemoteControlTogglePlayPause:
//                //Insert code
//                NSLog(@"Toggle");
//            case UIEventSubtypeRemoteControlPlay:
//				//Insert code
//                NSLog(@"play");
//				break;
//            case UIEventSubtypeRemoteControlPause:
//				// Insert code
//                NSLog(@"pause");
//                break;
//            case UIEventSubtypeRemoteControlStop:
//				//Insert code.
//                NSLog(@"stop");
//                break;
//            default:
//                return;
//        }
//    }
//}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */

    self.viewController.toggleButton.titleLabel.tag = 0;
    [self.viewController.toggleButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    
    self.viewController.defaults = [NSUserDefaults standardUserDefaults];

    NSData *data = [self.viewController.defaults objectForKey:@"userMedia"];
    if (data != nil) {
        self.viewController.userMediaItemCollection = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self.viewController.musicPlayer setQueueWithItemCollection: self.viewController.userMediaItemCollection];
        
        data = [self.viewController.defaults objectForKey:@"nowPlaying"];
        [self.viewController.musicPlayer setNowPlayingItem:[NSKeyedUnarchiver unarchiveObjectWithData:data]];    
        
        
        self.viewController.musicPlayer.currentPlaybackTime = [self.viewController.defaults doubleForKey:@"audioTime"];
        
        [self.viewController.musicPlayer play];
        self.viewController.toggleButton.titleLabel.tag = 1;
        [self.viewController.toggleButton setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
        
        [self.viewController.songTitle setText:[[self.viewController.musicPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyTitle]];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
