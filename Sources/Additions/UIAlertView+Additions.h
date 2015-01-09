
#pragma mark -
#pragma mark Imports
@import Foundation;
@import UIKit;

/** Simple UIAlertView wrapper methods */
@interface UIAlertView(Additions)

+ (void)showWithTitle:(NSString *)aTitle
			  message:(NSString *)aMessage 
			 delegate:(id)aDelegate;

+ (void)showWithTitle:(NSString *)aTitle
			  message:(NSString *)aMessage;

+ (void)showWithTitle:(NSString *)aTitle
							message:(NSString *)aMessage
						 delegate:(id)aDelegate
			closeButtonText:(NSString *)aCloseButtonText;

+ (void)showWithTitle:(NSString *)aTitle
				error:(NSError *)error
			 delegate:(id)aDelegate;

+ (void)showWithTitle:(NSString *)aTitle
				error:(NSError *)error;

@end
