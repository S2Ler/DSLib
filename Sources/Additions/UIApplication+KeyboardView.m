
#import "UIApplication+KeyboardView.h"

@implementation UIApplication (UIApplication_KeyboardView)


- (UIView *)peripheralHostView;
{
	NSArray *windows = [self windows];
	for (UIWindow *window in [windows reverseObjectEnumerator])
	{
		for (UIView *view in [window subviews])
		{
      NSLog(@"%@", view);
			if (!strcmp(object_getClassName(view), "UIPeripheralHostView"))
			{
				return view;
			}
		}
	}
	
	return nil;
}

@end
