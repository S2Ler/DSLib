
#pragma mark =================include=================
#import "DSActivityIndicator.h"

#pragma mark =================props=================
@interface DSActivityIndicator()	
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIImageView *doneImageView;
@end

@implementation DSActivityIndicator
#pragma mark =================synth=================
@synthesize activityIndicator = activityIndicator_;
@synthesize doneImageView = doneImageView_;

#pragma mark =================memory=================
- (void)dealloc {
	[activityIndicator_ release];
	[doneImageView_ release];
    [super dealloc];
}

#pragma mark =================inites=================
- (id)initWithFrame:(CGRect)aFrame
			  style:(UIActivityIndicatorViewStyle)aStyle {    
    self = [super initWithFrame:aFrame];
    if (self) {
		[self setBackgroundColor:[UIColor clearColor]];
		
        UIActivityIndicatorView *newActivityInicatorView =
		[[UIActivityIndicatorView alloc] initWithFrame:[self bounds]];
		[newActivityInicatorView setActivityIndicatorViewStyle:aStyle];
		[newActivityInicatorView setHidesWhenStopped:YES];
		[newActivityInicatorView stopAnimating];
		[newActivityInicatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[self addSubview:newActivityInicatorView];
		[self setActivityIndicator:newActivityInicatorView];				
		[newActivityInicatorView release];
		
		UIImageView *newImageView = [[UIImageView alloc] initWithFrame:[self bounds]];
		[newImageView setBackgroundColor:[UIColor clearColor]];
		[newImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[newImageView setAlpha:0.0];
		[self addSubview:newImageView];
		[self setDoneImageView:newImageView];
    }
    return self;
}

- (void)setStopAnimatingImage:(UIImage *)anImage {
	[doneImageView_ setImage:anImage];
}

- (void)startAnimating {
	[doneImageView_ setAlpha:0.0];
	[activityIndicator_ startAnimating];
}

- (void)stopAnimating {
	[doneImageView_ setAlpha:1.0];
	[activityIndicator_ stopAnimating];
}

@end
