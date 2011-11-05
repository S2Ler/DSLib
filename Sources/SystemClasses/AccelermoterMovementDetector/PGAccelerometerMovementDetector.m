#import "PGAccelerometerMovementDetector.h"

@interface PGAccelerometerMovementDetector ()
{
  double valueStrength;
  UIAcceleration *_lastAcceleration;
  BOOL histeresisExcited;

  BOOL _enabled;
}

@property(nonatomic, assign) double valueStrength;
@property(nonatomic, retain) UIAcceleration *lastAcceleration;


- (BOOL)isShakingAcceleration:(UIAcceleration *)lastAccel
                      current:(UIAcceleration *)currentAccel
                   byStrength:(double)strength;

- (BOOL)isShakingAcceleration:(double)vectorX
                         vecY:(double)vectorY
                         vecZ:(double)vectorZ
                       thresh:(double)strength;
@end


@implementation PGAccelerometerMovementDetector
@synthesize valueStrength;
@synthesize lastAcceleration = _lastAcceleration;
@synthesize enabled = _enabled;

static const double minValueOfHeighth = 0.1;
static const double maxValueOfHeighth = 6.0;
static const double histeresisValue = 0.2;

- (void)dealloc
{
  [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
  PG_SAVE_RELEASE(_lastAcceleration);
  [super dealloc];
}

- (id)initWithShakeStrenght:(double)percentStrength
{
  self = [super init];

  if (self) {
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1 / 15];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    [self setValueStrength:percentStrength];
  }

  return self;
}

- (void)setValueStrength:(double)percentStrength
{
  NSParameterAssert(percentStrength >= 0 && percentStrength <= 1.0);

  valueStrength = (maxValueOfHeighth - minValueOfHeighth) * percentStrength +
                  minValueOfHeighth;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer
        didAccelerate:(UIAcceleration *)acceleration
{
  if (self.lastAcceleration) {
    if (!histeresisExcited &&
        [self isShakingAcceleration:self.lastAcceleration
                            current:acceleration
                         byStrength:valueStrength] == YES) {
      histeresisExcited = YES;
      /* SHAKE DETECTED.*/

      if ([self isEnabled]) {
        [[NSNotificationCenter defaultCenter]
                               postNotificationName:kPGDidShakeNotification
                                             object:nil];
        DDLogInfo(@"PGAccselerometerShake: didShake");
      }
    } else if (histeresisExcited &&
               [self isShakingAcceleration:self.lastAcceleration
                                   current:acceleration
                                byStrength:histeresisValue] == NO) {
      histeresisExcited = NO;
    }
  }
  self.lastAcceleration = acceleration;
}

- (BOOL)isShakingAcceleration:(UIAcceleration *)lastAccel
                      current:(UIAcceleration *)currentAccel
                   byStrength:(double)strength
{
  double deltaX = ABS(lastAccel.x - currentAccel.x);
  double deltaY = ABS(lastAccel.y - currentAccel.y);
  double deltaZ = ABS(lastAccel.z - currentAccel.z);
  return [self
      isShakingAcceleration:deltaX vecY:deltaY vecZ:deltaZ thresh:strength];
}

- (BOOL)isShakingAcceleration:(double)vectorX
                         vecY:(double)vectorY
                         vecZ:(double)vectorZ
                       thresh:(double)strength
{
  double resultQuadratic =
      vectorX * vectorX + vectorY * vectorY + vectorZ * vectorZ;
  if (resultQuadratic > strength * strength) {
    return YES;
  }
  return NO;
}

@end
