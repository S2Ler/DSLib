
#import "DSVibrator.h"
#import <AudioToolbox/AudioToolbox.h>


@implementation DSVibrator {
  BOOL _enabled;
  NSTimer *_timer;
}

@synthesize enabled = _enabled;

- (void)dealloc {
  [_timer invalidate];
}

+ (DSVibrator *)sharedInstance
{
	static DSVibrator *sharedSingleton;
	
	@synchronized(self)
	{
    
		if (!sharedSingleton)
		{
			sharedSingleton = [[DSVibrator alloc] init];
		}
    
		return sharedSingleton;
	}
}

- (id)init {
  self = [super init];
  if (self) {
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                              target:self
                                            selector:@selector(vibrate)
                                            userInfo:nil 
                                             repeats:YES];
  }
  return self;
}

- (void)vibrate
{
  if ([self isEnabled]) {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    double delayInSeconds = 0.8;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    });
  }
}
@end
