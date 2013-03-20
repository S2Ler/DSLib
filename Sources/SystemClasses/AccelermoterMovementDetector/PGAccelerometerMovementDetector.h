
#import <Foundation/Foundation.h>

#define kPGDidShakeNotification @"DidShakeNotifications"

@interface PGAccelerometerMovementDetector : NSObject <UIAccelerometerDelegate>

/**
 \param percentStrength possible values from 0.0 to 1.0
 */
- (void)setValueStrength:(double)percentStrength;

/**
 After initialization isEnabled = NO.
 \param percentStrength possible values from 0.0 to 1.0
 */
- (id)initWithShakeStrenght:(double)percentStrength;

@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

@end
