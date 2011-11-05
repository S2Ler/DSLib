
#pragma mark -
#pragma mark Imports
#import "UIAlertView+Additions.h"

@implementation UIAlertView(Additions)

+ (void)showWithTitle:(NSString *)aTitle
			  message:(NSString *)aMessage
			 delegate:(id)aDelegate {
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:aTitle 
													   message:aMessage
													   delegate:aDelegate
											  cancelButtonTitle:@"Close" 
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

+ (void)showWithTitle:(NSString *)aTitle
							message:(NSString *)aMessage
						 delegate:(id)aDelegate
			closeButtonText:(NSString *)aCloseButtonText {
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:aTitle 
														message:aMessage
													   delegate:aDelegate 
											  cancelButtonTitle:aCloseButtonText
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

+ (void)showWithTitle:(NSString *)aTitle
			  message:(NSString *)aMessage {
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:aTitle 
														message:aMessage
													   delegate:nil
											  cancelButtonTitle:@"Close"
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

+ (void)showWithTitle:(NSString *)aTitle
				error:(NSError *)error {
	NSString *message = [NSString stringWithFormat:@"%@",
						 [error localizedDescription]];
	
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:aTitle 
														message:message
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

+ (void)showWithTitle:(NSString *)aTitle
				error:(NSError *)error
			 delegate:(id)aDelegate {
	
	NSString *message = [NSString stringWithFormat:@"%@",
						 [error localizedDescription]];
	
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:aTitle 
														message:message
													   delegate:aDelegate
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

@end
