#import "CATransition+AnimationsBuilder.h"

@implementation CATransition (CATransation_AnimationsBuilder)
+ (CATransition *)transationForFadeWithDuration:(NSTimeInterval)theDuration
{
  CATransition *transition = [CATransition animation];
  [transition setDuration:theDuration];
  [transition setTimingFunction:
   [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
  [transition setType:kCATransitionFade];
  
  return transition;
}

@end
