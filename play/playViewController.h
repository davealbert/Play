//
//  playViewController.h
//  play
//
//  Created by Dave Albert on 14/12/2011.
//  Copyright 2011 Hermitage Medical Clinic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MusicTableViewController.h"

@interface playViewController : UIViewController <MPMediaPickerControllerDelegate,MusicTableViewControllerDelegate, UIAlertViewDelegate> {
    
    UIButton *toggleButton;
    UISlider *timeSlider;
    UITextField *hour;
    UITextField *minute;
    UITextField *second;
    UILabel *songTitle;
    MPMusicPlayerController *musicPlayer;
    UILabel *playTime;
    NSTimer *currentTimer;
    BOOL started;
    NSUserDefaults *defaults;
    MPMediaItemCollection *userMediaItemCollection;
    UIView *subView;
    UISlider *mySlider;
    UILabel *label;
}

@property (nonatomic, retain) MPMediaItemCollection *userMediaItemCollection; 
@property (nonatomic, retain) NSUserDefaults *defaults;
@property (nonatomic, retain) MPMusicPlayerController *musicPlayer;
@property (nonatomic, assign) BOOL started;
@property (nonatomic, retain) IBOutlet UILabel *playTime;
@property (nonatomic, retain) IBOutlet UIButton *toggleButton;
@property (nonatomic, retain) IBOutlet UISlider *timeSlider;
@property (nonatomic, retain) IBOutlet UITextField *hour;
@property (nonatomic, retain) IBOutlet UITextField *minute;
@property (nonatomic, retain) IBOutlet UITextField *second;
@property (nonatomic, retain) IBOutlet UILabel *songTitle;


- (IBAction)seek:(id)sender;
- (IBAction)toggleMusic:(id)sender;
- (void)onTimer:(NSTimer *)timer;
- (IBAction)slideTime:(id)sender;
- (IBAction)pickMusic:(id)sender;
- (void) updatePlayerQueueWithMediaCollection: (MPMediaItemCollection *) mediaItemCollection;
- (IBAction)clearList:(id)sender;
- (IBAction)goToNextSong:(id)sender;
- (IBAction)goToPrevSong:(id)sender;

- (IBAction)hhNextField:(id)sender;
- (IBAction)mmNextField:(id)sender;
- (IBAction)ssGo:(id)sender;
- (IBAction)playList:(id)sender;
- (IBAction)lockScreen:(id)sender;
- (IBAction)unlock:(id)sender;
- (void) fadeLabel;

@end
