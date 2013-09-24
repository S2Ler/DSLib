
#import "DSNetworkActivity.h"
#import "DSMacros.h"

@interface DSNetworkActivity() {
  NSInteger _activitiesCount;
}
@end

@implementation DSNetworkActivity
+ (DSNetworkActivity *)sharedInstance
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^
  {
    return [[self alloc] init];
  })
}

+ (void)increaseActivitiesCount
{
  [[self sharedInstance] updateLoadCountWithDelta:1];
}

+ (void)decreaseActivitiesCount
{
  [[self sharedInstance] updateLoadCountWithDelta:-1];
}

- (void)updateLoadCountWithDelta:(NSInteger)countDelta
{
  @synchronized (self) {
    _activitiesCount += countDelta;
    _activitiesCount = (_activitiesCount < 0) ? 0 : _activitiesCount;

    [UIApplication sharedApplication].networkActivityIndicatorVisible = _activitiesCount > 0;
  }
}

@end
