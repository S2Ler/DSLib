
#import <Foundation/Foundation.h>

@class PGVideoImageView;

@protocol PGVideoImageViewDelegate <NSObject>
- (void)videoImageViewDidFinishPlaying:(PGVideoImageView *)theVideoView;
@end
