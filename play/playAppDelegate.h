//
//  playAppDelegate.h
//  play
//
//  Created by Dave Albert on 14/12/2011.
//  Copyright 2011 Hermitage Medical Clinic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class playViewController;

@interface playAppDelegate : NSObject <UIApplicationDelegate> {

}



@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet playViewController *viewController;


@end
