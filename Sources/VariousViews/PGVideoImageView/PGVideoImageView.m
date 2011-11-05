
#import "PGVideoImageView.h"
@interface PGVideoImageView ()
{
	NSURL *_movieURL;
	MPMoviePlayerController * _moviePlayer;
	BOOL _autoRepeatMode;
	BOOL _playbackControlHidden;
	BOOL _statusBarHidden;
}

@property (nonatomic,retain) NSURL* movieURL;
@property (nonatomic,retain) MPMoviePlayerController * moviePlayer;


- (void)moviePlayBackDidFinish:(NSNotification*)notification;
- (void)moviePlayerLoadStateChanged:(NSNotification*)notification; 
@end



@implementation PGVideoImageView
@synthesize movieURL = _movieURL;
@synthesize moviePlayer = _moviePlayer;

@synthesize playbackControlHidden = _playbackControlHidden;
@synthesize statusBarHidden = _statusBarHidden;
@synthesize autoRepeatMode = _autoRepeatMode;
@synthesize delegate = _delegate;

- (void)dealloc 
{
  PG_SAVE_RELEASE(_movieURL);
	PG_SAVE_RELEASE(_moviePlayer);
	[super dealloc];
}


- (id)initWithFrame:(CGRect)frame andPath:(NSString *)moviePath
{
	self = [super initWithFrame:frame];
	// Initialize and create movie URL
  if (self)
  {
	  self.movieURL = [NSURL fileURLWithPath:moviePath];
		_autoRepeatMode = NO;
		_statusBarHidden = NO;
		_playbackControlHidden = YES;
 	}
	return self;
}

- (void)moviePlayerLoadStateChanged:(NSNotification*)notification 
{
	if(self.statusBarHidden == YES)
		[[UIApplication sharedApplication] setStatusBarHidden:YES];
	
	// Unless state is unknown, start playback
	if ([self.moviePlayer loadState] != MPMovieLoadStateUnknown)
  {
  	// Remove observer
    [[NSNotificationCenter 	defaultCenter] 
		 removeObserver:self
		 name:MPMoviePlayerLoadStateDidChangeNotification 
		 object:nil];
		
		// Set frame of movieplayer
		[[self.moviePlayer view] setFrame:[self bounds]];
		
    // Add movie player as subview
	  [self  addSubview:[self.moviePlayer view]];   
		
		// Play the movie
		[self.moviePlayer play];
	}
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification 
{    
	if(self.statusBarHidden == YES)
		[[UIApplication sharedApplication] setStatusBarHidden:YES];
	
 	// Remove observer
  [[NSNotificationCenter 	defaultCenter] 
	 removeObserver:self
	 name:MPMoviePlayerPlaybackDidFinishNotification 
	 object:nil];
	
  [[self delegate] videoImageViewDidFinishPlaying:self];
}

- (void) readyPlayer
{
 	if(_moviePlayer == nil)
	{
		_moviePlayer =
		[[MPMoviePlayerController alloc] initWithContentURL:self.movieURL];
    [_moviePlayer setScalingMode:MPMovieScalingModeAspectFill];
	}
	//autorepeatMode
	if(self.autoRepeatMode == YES)
		self.moviePlayer.repeatMode = MPMovieRepeatModeOne;
	
	if(self.playbackControlHidden == YES)
		self.moviePlayer.controlStyle = MPMovieControlStyleNone;
	else
		self.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
	
	
  if ([self.moviePlayer respondsToSelector:@selector(loadState)]) 
  {
  	// Set movie player layout
		[self.moviePlayer setFullscreen:YES];
		
		// May help to reduce latency
		[self.moviePlayer prepareToPlay];
		
		// Register that the load state changed (movie is ready)
		[[NSNotificationCenter defaultCenter] 
		 addObserver:self
		 selector:@selector(moviePlayerLoadStateChanged:) 
		 name:MPMoviePlayerLoadStateDidChangeNotification
		 object:nil];
	}  
  else
  {
    // Register to receive a notification when the movie is in memory and ready to play.
    [[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(moviePreloadDidFinish:) 
		// name:MPMoviePlayerContentPreloadDidFinishNotification
		 name:MPMoviePlayerLoadStateDidChangeNotification
		 object:nil];
  }
	
  // Register to receive a notification when the movie has finished playing. 
  [[NSNotificationCenter defaultCenter]
	 addObserver:self 
	 selector:@selector(moviePlayBackDidFinish:)
	 name:MPMoviePlayerPlaybackDidFinishNotification 
	 object:nil];
}

//-(void)moveLabels
//{
//	
//	
//	CGRect bounds = [self bounds];
//	
//	CGSize titleSize = [[[self titleLabel] text]
//											sizeWithFont:[[self titleLabel] font]
//											constrainedToSize:CGSizeMake(bounds.size.width, 
//																									 bounds.size.height)
//											lineBreakMode:UILineBreakModeWordWrap];
//	
//	CGSize messageSize 
//	= [[[self messageLabel] text]
//		 sizeWithFont:[[self messageLabel] font]
//		 constrainedToSize:CGSizeMake(bounds.size.width,
//																	bounds.size.height-titleSize.height - MARGIN)
//		 lineBreakMode:UILineBreakModeWordWrap];
//	
//	CGFloat titleY = (bounds.size.height -
//										(titleSize.height + messageSize.height + MARGIN)) / 2.0;
//	
//	CGRect titleFrame = CGRectMake(floor((bounds.size.width-titleSize.width)/2.0), 
//																 titleY,
//																 titleSize.width,
//																 titleSize.height);
//	
//	CGRect messageFrame 
//	= CGRectMake(floor((bounds.size.width-messageSize.width)/2.0), 
//							 CGRectGetMaxY(titleFrame),
//							 messageSize.width, 
//							 messageSize.height);
//	[[self titleLabel] setFrame:titleFrame];
//	[[self messageLabel] setFrame:messageFrame];
//}

- (void)stop
{
  [[self moviePlayer] stop];
}
@end
