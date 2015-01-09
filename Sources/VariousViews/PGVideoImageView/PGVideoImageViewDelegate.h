
@import Foundation;

@class PGVideoImageView;

@protocol PGVideoImageViewDelegate <NSObject>
- (void)videoImageViewDidFinishPlaying:(PGVideoImageView *)theVideoView;
@end
