
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PGVideoImageViewDelegate.h"

@interface PGVideoImageView : UIImageView
{
	id<PGVideoImageViewDelegate> _delegate;
}

@property (nonatomic, assign) id<PGVideoImageViewDelegate> delegate;

@property (nonatomic,assign) BOOL autoRepeatMode;
@property (nonatomic,assign) BOOL playbackControlHidden;
@property (nonatomic,assign) BOOL statusBarHidden;

- (id)initWithFrame:(CGRect)frame
            andPath:(NSString *)moviePath;
- (void)readyPlayer;

- (void)stop;
@end
