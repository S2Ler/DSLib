
#import <UIKit/UIKit.h>

@interface DSFlashingImageView : UIImageView
@property (nonatomic, strong) NSArray *flashImages;

- (void)setPulsingEnabled:(BOOL)thePulsingFlag
                 duration:(NSTimeInterval)thePulseDuration
                 minScale:(double)theMinScale
                 maxScale:(double)theMaxScale;

/** @param theTimeout Time interval between flashes. 
 Default is 3 sec.*/
- (void)setIsFlashingEnabled:(BOOL)theFlashFlag
                     timeout:(NSTimeInterval)theTimeout;


@end
