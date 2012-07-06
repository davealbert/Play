//
//  playViewController.m
//  play
//
//  Created by Dave Albert on 14/12/2011.
//  Copyright 2011 Hermitage Medical Clinic. All rights reserved.
//

#import "playViewController.h"

@implementation playViewController


@synthesize playTime;
@synthesize toggleButton;
@synthesize timeSlider;
@synthesize hour;
@synthesize minute;
@synthesize second;
@synthesize songTitle;
@synthesize started;
@synthesize musicPlayer;
@synthesize defaults;
@synthesize userMediaItemCollection;


- (void)dealloc
{
    [toggleButton release];
    [playTime release];
    [timeSlider release];
    [hour release];
    [minute release];
    [second release];
    [songTitle release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!started) {
        //        
        started = YES;
        musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
        //        MPMediaPropertyPredicate *artist = [MPMediaPropertyPredicate predicateWithValue:@"The Second Coming of Steve Jobs" forProperty:MPMediaItemPropertyTitle];
        //        ;
        //        MPMediaQuery *myArtistQuery = [[MPMediaQuery alloc] init];
        //        [myArtistQuery addFilterPredicate:artist];
        //        
        //        [musicPlayer setQueueWithQuery:myArtistQuery];
        currentTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    }
}


- (void)viewDidUnload
{
    [self setToggleButton:nil];
    [self setPlayTime:nil];
    [self setTimeSlider:nil];
    [self setHour:nil];
    [self setMinute:nil];
    [self setSecond:nil];
    [self setSongTitle:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)seek:(id)sender {
    [second becomeFirstResponder];
    [second resignFirstResponder];
    
    if ([hour.text intValue] + [minute.text intValue] + [second.text intValue] +0 > 0) {
        musicPlayer.currentPlaybackTime = ([hour.text intValue] * 3600) + ([minute.text intValue] * 60) + ([second.text intValue]);
        long currentPlaybackTime = musicPlayer.currentPlaybackTime;
        int currentHours = (currentPlaybackTime / 3600);
        int currentMinutes = ((currentPlaybackTime / 60) - currentHours*60);
        int currentSeconds = (currentPlaybackTime % 60);
        self.playTime.text = [NSString stringWithFormat:@"%i:%02d:%02d", currentHours, currentMinutes, currentSeconds];
        NSNumber *duration=[[musicPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyPlaybackDuration];
        timeSlider.value = musicPlayer.currentPlaybackTime / [duration floatValue] ;
    }
    
}

- (IBAction)toggleMusic:(id)sender {
    if (toggleButton.titleLabel.tag == 0) {
        [musicPlayer play];        
        toggleButton.titleLabel.tag = 1;
        [toggleButton setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
    } else {
        [musicPlayer pause];        
        toggleButton.titleLabel.tag = 0;
        [toggleButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
    [second becomeFirstResponder];
    [second resignFirstResponder];
    
}

- (void)onTimer:(NSTimer *)timer {
    
    [songTitle setText:[[musicPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyTitle]];
    
    
    if (toggleButton.titleLabel.tag == 1) {
        
        
        if ([[musicPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyPlaybackDuration] > 0) {
            

            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:musicPlayer.nowPlayingItem];
            
            defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:data forKey:@"nowPlaying"];
            [defaults synchronize];
            
            
            
            NSString *key = @"audioTime";
            
            [defaults setDouble:musicPlayer.currentPlaybackTime forKey:key];
            if (userMediaItemCollection != nil){
                [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:userMediaItemCollection] forKey:@"mediaItems"];
            }
            [defaults synchronize];
            
            
            
            long currentPlaybackTime = musicPlayer.currentPlaybackTime;
            int currentHours = (currentPlaybackTime / 3600);
            int currentMinutes = ((currentPlaybackTime / 60) - currentHours*60);
            int currentSeconds = (currentPlaybackTime % 60);
            self.playTime.text = [NSString stringWithFormat:@"%i:%02d:%02d", currentHours, currentMinutes, currentSeconds];
            NSNumber *duration=[[musicPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyPlaybackDuration];
            if ((musicPlayer.currentPlaybackTime / [duration floatValue]) < 1) {
                timeSlider.value = ( musicPlayer.currentPlaybackTime / [duration floatValue] );
            }
        }else {
            [musicPlayer pause];        
            toggleButton.titleLabel.tag = 0;
            timeSlider.value = 0;
            [toggleButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
            self.playTime.text = @"";
            
        }
        
        
    }
}

- (IBAction)slideTime:(id)sender {
    NSNumber *duration=[[musicPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyPlaybackDuration];
    musicPlayer.currentPlaybackTime = timeSlider.value * [duration floatValue];
    
}

- (IBAction)pickMusic:(id)sender {
    
    //    MPMediaPickerController *picker =
    //    [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
    //    
    //    picker.delegate						= self;
    //    picker.allowsPickingMultipleItems	= YES;
    //    picker.prompt						= NSLocalizedString (@"Add songs to play", "Prompt in media item picker");
    //    
    //    // The media item picker uses the default UI style, so it needs a default-style
    //    //		status bar to match it visually
    //    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated: YES];
    //    
    //    [self presentModalViewController: picker animated: YES];
    //    [picker release];
    
    
    // if the user has already chosen some music, display that list
	if (userMediaItemCollection) {
        
		MusicTableViewController *controller = [[MusicTableViewController alloc] initWithNibName: @"MusicTableView" bundle: nil];
		controller.delegate = self;
		
		controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
		
		[self presentModalViewController: controller animated: YES];
		[controller release];
        
        // else, if no music is chosen yet, display the media item picker
	} else {
        
		MPMediaPickerController *picker =
        [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
		
		picker.delegate						= self;
		picker.allowsPickingMultipleItems	= YES;
		picker.prompt						= NSLocalizedString (@"Add songs to play", "Prompt in media item picker");
		
		// The media item picker uses the default UI style, so it needs a default-style
		//		status bar to match it visually
		[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated: YES];
		
		[self presentModalViewController: picker animated: YES];
		[picker release];
	}
    
}

// Responds to the user tapping Done after choosing music.
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
    
	[self dismissModalViewControllerAnimated: YES];
	// Apply the chosen songs to the music player's queue.
	[self updatePlayerQueueWithMediaCollection: mediaItemCollection];
    
    
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated:YES];
}


// Responds to the user tapping done having chosen no music.
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
    
	[self dismissModalViewControllerAnimated: YES];
    
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated:YES];
}



- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
	return YES;
}

- (void) updatePlayerQueueWithMediaCollection: (MPMediaItemCollection *) mediaItemCollection {
    
	// Configure the music player, but only if the user chose at least one song to play
	if (mediaItemCollection) {
        
		// If there's no playback queue yet...
		if (userMediaItemCollection == nil) {
            
			// apply the new media item collection as a playback queue for the music player
			[self setUserMediaItemCollection: mediaItemCollection];
			[musicPlayer setQueueWithItemCollection: userMediaItemCollection];
            //////			[self setPlayedMusicOnce: YES]; 
            [musicPlayer play];        
            toggleButton.titleLabel.tag = 1;
            [toggleButton setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
            
            
            // Obtain the music player's state so it can then be
            //		restored after updating the playback queue.
		} else {
            
			// Take note of whether or not the music player is playing. If it is
			//		it needs to be started again at the end of this method.
			BOOL wasPlaying = NO;
			if (musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
				wasPlaying = YES;
			}
			
			// Save the now-playing item and its current playback time.
			MPMediaItem *nowPlayingItem			= musicPlayer.nowPlayingItem;
			NSTimeInterval currentPlaybackTime	= musicPlayer.currentPlaybackTime;
            
			// Combine the previously-existing media item collection with the new one
			NSMutableArray *combinedMediaItems	= [[userMediaItemCollection items] mutableCopy];
			NSArray *newMediaItems				= [mediaItemCollection items];
			[combinedMediaItems addObjectsFromArray: newMediaItems];
			
			[self setUserMediaItemCollection: [MPMediaItemCollection collectionWithItems: (NSArray *) combinedMediaItems]];
			[combinedMediaItems release];
            
			// Apply the new media item collection as a playback queue for the music player.
			[musicPlayer setQueueWithItemCollection: userMediaItemCollection];
			
			// Restore the now-playing item and its current playback time.
			musicPlayer.nowPlayingItem			= nowPlayingItem;
			musicPlayer.currentPlaybackTime		= currentPlaybackTime;
			
			// If the music player was playing, get it playing again.
			if (wasPlaying) {
				[musicPlayer play];
			}
		}
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userMediaItemCollection];
        
        defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:data forKey:@"userMedia"];
        [defaults synchronize];
        
        
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
        
        [self setUserMediaItemCollection:nil];
        MPMediaPropertyPredicate *predicate =
        [MPMediaPropertyPredicate predicateWithValue: @"Non_Existant_Song_Name"
                                         forProperty: MPMediaItemPropertyTitle];
        MPMediaQuery *q = [[MPMediaQuery alloc] init];
        [q addFilterPredicate: predicate];
        [musicPlayer setQueueWithQuery:q];
        musicPlayer.nowPlayingItem = nil;
        [musicPlayer stop];
        toggleButton.titleLabel.tag = 0;
        [toggleButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        timeSlider.value = 0;
        self.playTime.text = @"";
	}
	else if (buttonIndex == 1)
	{
		// No
	}
}

- (IBAction)clearList:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"Confirm"];
	[alert setMessage:@"Are you sure you want to clear the play list?"];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"Yes"];
	[alert addButtonWithTitle:@"No"];
	[alert show];
	[alert release];
    
    
}

- (IBAction)goToNextSong:(id)sender{
    [musicPlayer skipToNextItem];
}

- (IBAction)goToPrevSong:(id)sender {
    [musicPlayer skipToPreviousItem];
}

- (IBAction)hhNextField:(id)sender {
    if ([hour.text length] == 2) {
        [minute becomeFirstResponder];
    }
}

- (IBAction)mmNextField:(id)sender {
    if ([minute.text length] == 2) {
        [second becomeFirstResponder];
    }
}

- (IBAction)ssGo:(id)sender {
    if ([second.text length] == 2) {
        [self seek:self];
    }
}

- (IBAction)playList:(id)sender {
    
}

- (void) removeSubView{
    [subView removeFromSuperview];
}

- (IBAction)unlock:(id)sender{
    if (mySlider.value > .95) {
        [[ UIApplication sharedApplication ] setIdleTimerDisabled: NO ];
        [songTitle setCenter:CGPointMake(songTitle.center.x, songTitle.center.y + 200)];
        [playTime setCenter:CGPointMake(playTime.center.x, playTime.center.y + 200)];

        [self.view addSubview:playTime];
        [self.view addSubview:songTitle];
        [self removeSubView];
    } else {
        [mySlider setValue:0.00];
        label.alpha = 1;
    }
}

- (void) fadeLabel{
    label.alpha = 1 - mySlider.value;
}



- (IBAction)lockScreen:(id)sender {
    [[ UIApplication sharedApplication ] setIdleTimerDisabled: YES ];
    subView = [[UIView alloc] initWithFrame:self.view.bounds];
    [subView setBackgroundColor:[UIColor blackColor]];
    
    
    //    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect]; 
    //    [myButton setTitle:@"Done" forState:UIControlStateNormal];
    //    myButton.frame = CGRectMake(10,10, 200, 40);
    //    [myButton addTarget:self action:@selector(removeSubView) forControlEvents:UIControlEventTouchUpInside];    
    //    [subView addSubview:myButton];
    
    UIImageView *slideBg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 364, 305, 54)];                        
    [slideBg setImage:[UIImage imageNamed:@"SlideToStopBar.png"]];
    [subView addSubview:slideBg];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(100, 380, 200, 23)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor lightGrayColor]];
    [label setFont:[UIFont fontWithName:@"Helvetica" size:24.0]];
    label.text = @"slide to unlock";
    [subView addSubview:label];
    
    
    mySlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 380, 295, 23)];
    [mySlider setValue:0.00];
    [mySlider addTarget:self action:@selector(unlock:) forControlEvents:UIControlEventTouchUpInside];
    [mySlider addTarget:self action:@selector(fadeLabel) forControlEvents:UIControlEventValueChanged];
    [mySlider setThumbImage: [UIImage imageNamed:@"SlideToStop.png"] forState:UIControlStateNormal];
    UIImage *stetchLeftTrack= [[UIImage imageNamed:@"Nothing.png"]
                               stretchableImageWithLeftCapWidth:30.0 topCapHeight:0.0];
	UIImage *stetchRightTrack= [[UIImage imageNamed:@"Nothing.png"]
                                stretchableImageWithLeftCapWidth:30.0 topCapHeight:0.0];
    
    [mySlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
	[mySlider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    [subView addSubview:mySlider];
    
    
    
    
    
    
    
    
    
//    UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
//    animatedImageView.animationImages = [NSArray arrayWithObjects:    
//                                         
//                                         [UIImage imageNamed:@"heic0106b.jpg"],
//                                         [UIImage imageNamed:@"heic0108a.jpg"],
//                                         [UIImage imageNamed:@"heic0109a.jpg"],
//                                         [UIImage imageNamed:@"heic0114a.jpg"],
//                                         [UIImage imageNamed:@"heic0206a.jpg"],
//                                         [UIImage imageNamed:@"heic0206b.jpg"],
//                                         [UIImage imageNamed:@"heic0206c.jpg"],
//                                         [UIImage imageNamed:@"heic0206d.jpg"],
//                                         [UIImage imageNamed:@"heic0206h.jpg"],
//                                         [UIImage imageNamed:@"heic0301a.jpg"],
//                                         [UIImage imageNamed:@"heic0305a.jpg"],
//                                         [UIImage imageNamed:@"heic0406a.jpg"],
//                                         [UIImage imageNamed:@"heic0411a.jpg"],
//                                         [UIImage imageNamed:@"heic0416a.jpg"],
//                                         [UIImage imageNamed:@"heic0503a.jpg"],
//                                         [UIImage imageNamed:@"heic0506a.jpg"],
//                                         [UIImage imageNamed:@"heic0506b.jpg"],
//                                         [UIImage imageNamed:@"heic0514a.jpg"],
//                                         [UIImage imageNamed:@"heic0515a.jpg"],
//                                         [UIImage imageNamed:@"heic0601a.jpg"],
//                                         [UIImage imageNamed:@"heic0601d.jpg"],
//                                         [UIImage imageNamed:@"heic0601g.jpg"],
//                                         [UIImage imageNamed:@"heic0602a.jpg"],
//                                         [UIImage imageNamed:@"heic0603b.jpg"],
//                                         [UIImage imageNamed:@"heic0604a.jpg"],
//                                         [UIImage imageNamed:@"heic0604d.jpg"],
//                                         [UIImage imageNamed:@"heic0611b.jpg"],
//                                         [UIImage imageNamed:@"heic0615a.jpg"],
//                                         [UIImage imageNamed:@"heic0706a.jpg"],
//                                         [UIImage imageNamed:@"heic0707a.jpg"],
//                                         [UIImage imageNamed:@"heic0709b.jpg"],
//                                         [UIImage imageNamed:@"heic0712b.jpg"],
//                                         [UIImage imageNamed:@"heic0715a.jpg"],
//                                         [UIImage imageNamed:@"heic0719a.jpg"],
//                                         [UIImage imageNamed:@"heic0817a.jpg"],
//                                         [UIImage imageNamed:@"heic0817b.jpg"],
//                                         [UIImage imageNamed:@"heic0904a.jpg"],
//                                         [UIImage imageNamed:@"heic0904f.jpg"],
//                                         [UIImage imageNamed:@"heic0905a.jpg"],
//                                         [UIImage imageNamed:@"heic0909b.jpg"],
//                                         [UIImage imageNamed:@"heic0909c.jpg"],
//                                         [UIImage imageNamed:@"heic0910c.jpg"],
//                                         [UIImage imageNamed:@"heic0910e.jpg"],
//                                         [UIImage imageNamed:@"heic0910f.jpg"],
//                                         [UIImage imageNamed:@"heic0910g.jpg"],
//                                         [UIImage imageNamed:@"heic0910h.jpg"],
//                                         [UIImage imageNamed:@"heic0910i.jpg"],
//                                         [UIImage imageNamed:@"heic0910q.jpg"],
//                                         [UIImage imageNamed:@"heic0910s.jpg"],
//                                         [UIImage imageNamed:@"heic0911b.jpg"],
//                                         [UIImage imageNamed:@"heic0911c.jpg"],
//                                         [UIImage imageNamed:@"heic1007a.jpg"],
//                                         [UIImage imageNamed:@"heic1007c.jpg"],
//                                         [UIImage imageNamed:@"heic1007e.jpg"],
//                                         [UIImage imageNamed:@"hubble_earth.jpg"],
//                                         [UIImage imageNamed:@"hubble_space.jpg"],
//                                         [UIImage imageNamed:@"opo0006a.jpg"],
//                                         [UIImage imageNamed:@"opo0028a.jpg"],
//                                         [UIImage imageNamed:@"opo0110a.jpg"],
//                                         [UIImage imageNamed:@"opo0201a.jpg"],
//                                         [UIImage imageNamed:@"opo0207a.jpg"],
//                                         [UIImage imageNamed:@"opo0212a.jpg"],
//                                         [UIImage imageNamed:@"opo0214a.jpg"],
//                                         [UIImage imageNamed:@"opo0301a.jpg"],
//                                         [UIImage imageNamed:@"opo0306a.jpg"],
//                                         [UIImage imageNamed:@"opo0309a.jpg"],
//                                         [UIImage imageNamed:@"opo0320a.jpg"],
//                                         [UIImage imageNamed:@"opo0322i.jpg"],
//                                         [UIImage imageNamed:@"opo0324a.jpg"],
//                                         [UIImage imageNamed:@"opo0328a.jpg"],
//                                         [UIImage imageNamed:@"opo0331a.jpg"],
//                                         [UIImage imageNamed:@"opo0404a.jpg"],
//                                         [UIImage imageNamed:@"opo0415a.jpg"],
//                                         [UIImage imageNamed:@"opo0417b.jpg"],
//                                         [UIImage imageNamed:@"opo0423a.jpg"],
//                                         [UIImage imageNamed:@"opo0432d.jpg"],
//                                         [UIImage imageNamed:@"opo0501a.jpg"],
//                                         [UIImage imageNamed:@"opo0511a.jpg"],
//                                         [UIImage imageNamed:@"opo0525a.jpg"],
//                                         [UIImage imageNamed:@"opo0607a.jpg"],
//                                         [UIImage imageNamed:@"opo0609b.jpg"],
//                                         [UIImage imageNamed:@"opo0613a.jpg"],
//                                         [UIImage imageNamed:@"opo0624a.jpg"],
//                                         [UIImage imageNamed:@"opo0635a.jpg"],
//                                         [UIImage imageNamed:@"opo0714a.jpg"],
//                                         [UIImage imageNamed:@"opo0745a.jpg"],
//                                         [UIImage imageNamed:@"opo0822a.jpg"],
//                                         [UIImage imageNamed:@"opo0834a.jpg"],
//                                         [UIImage imageNamed:@"opo0917a.jpg"],
//                                         [UIImage imageNamed:@"opo9433a.jpg"],
//                                         [UIImage imageNamed:@"opo9544a.jpg"],
//                                         [UIImage imageNamed:@"opo9545a.jpg"],
//                                         [UIImage imageNamed:@"opo9828c.jpg"],
//                                         [UIImage imageNamed:@"opo9901a.jpg"],
//                                         [UIImage imageNamed:@"opo9912a.jpg"],
//                                         [UIImage imageNamed:@"opo9925a.jpg"],
//                                         [UIImage imageNamed:@"opo9941a.jpg"],
//                                         [UIImage imageNamed:@"opo9942a.jpg"],
//                                         [UIImage imageNamed:@"potw1001a.jpg"],
//                                         [UIImage imageNamed:@"s109e5875.jpg"],nil];
//    
//    animatedImageView.animationDuration = 30.0f;
//    animatedImageView.animationRepeatCount = 0;
//    [animatedImageView startAnimating];
//    
//    [subView addSubview:animatedImageView];
    
    
    
    [subView addSubview:songTitle];
    [subView addSubview:playTime];
    
    [songTitle setCenter:CGPointMake(songTitle.center.x, songTitle.center.y - 200)];
    [playTime setCenter:CGPointMake(playTime.center.x, playTime.center.y - 200)];
    
    [self.view addSubview:subView];
}




// When the playback state changes, set the play/pause button in the Navigation bar
//		appropriately.
- (void) handle_PlaybackStateChanged: (id) notification {
    
	MPMusicPlaybackState playbackState = [musicPlayer playbackState];
	
	if (playbackState == MPMusicPlaybackStatePaused) {
        
        
		
	} else if (playbackState == MPMusicPlaybackStatePlaying) {
        
        
        
	} else if (playbackState == MPMusicPlaybackStateStopped) {
        
        
		
		// Even though stopped, invoking 'stop' ensures that the music player will play  
		//		its queue from the start.
		[musicPlayer stop];
        toggleButton.titleLabel.tag = 0;
        [toggleButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        
        
        
	}
}

- (void) handle_NowPlayingItemChanged: (id) notification {
    
    
    
    
}


// To learn about notifications, see "Notifications" in Cocoa Fundamentals Guide.
- (void) registerForMediaPlayerNotifications {
    
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
	[notificationCenter addObserver: self
						   selector: @selector (handle_NowPlayingItemChanged:)
							   name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
							 object: musicPlayer];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_PlaybackStateChanged:)
							   name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
							 object: musicPlayer];
    
    
    
    /*
     // This sample doesn't use libray change notifications; this code is here to show how
     //		it's done if you need it.
     [notificationCenter addObserver: self
     selector: @selector (handle_iPodLibraryChanged:)
     name: MPMediaLibraryDidChangeNotification
     object: musicPlayer];
     
     [[MPMediaLibrary defaultMediaLibrary] beginGeneratingLibraryChangeNotifications];
     */
    
	[musicPlayer beginGeneratingPlaybackNotifications];
}


// Invoked when the user taps the Done button in the table view.
- (void) musicTableViewControllerDidFinish: (MusicTableViewController *) controller {
	
	[self dismissModalViewControllerAnimated: YES];
    //	[self restorePlaybackState];
    
}






@end













