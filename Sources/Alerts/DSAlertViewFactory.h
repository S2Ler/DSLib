
#import <Foundation/Foundation.h>

@protocol DSAlertView;
@class DSAlert;
@protocol DSAlertViewDelegate;


@interface DSAlertViewFactory: NSObject
/** Don't forget to set delegate */
+ (id<DSAlertView>)modalAlertViewWithAlert:(DSAlert *)theAlert
                                  delegate:(id<DSAlertViewDelegate>)theDelegate;
@end
