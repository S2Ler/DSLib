
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PGVideoImageViewDelegate.h"

@interface PGVideoImageView : UIImageView
{
	id<PGVideoImageViewDelegate> __weak _delegate;
}

@property (nonatomic, weak) id<PGVideoImageViewDelegate> delegate;

@property (nonatomic,assign) BOOL autoRepeatMode;
@property (nonatomic,assign) BOOL playbackControlHidden;
@property (nonatomic,assign) BOOL statusBarHidden;

- (id)initWithFrame:(CGRect)frame
            andPath:(NSString *)moviePath;
- (void)readyPlayer;

- (void)stop;
@end
