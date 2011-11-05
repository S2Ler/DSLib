
#pragma mark - include
#import "PGAlertsHandler.h"
#import "UIAlertView+Additions.h"
#import "PGAlertMessage.h"
#import "PGAppDelegate.h"
#import "PGAlertView.h"
#import "PGAlertMessageContentView.h"
#import "UIApplication+KeyboardView.h"

static PGAlertsHandler *sharedInstance = nil;

@implementation PGAlertsHandler
#pragma mark ----------------Singleton----------------
+ (PGAlertsHandler *)sharedInstance {
	@synchronized(self) {
		if (sharedInstance == nil) {
			sharedInstance = [[PGAlertsHandler alloc] init];
		}
	}
	return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedInstance == nil) {
			sharedInstance = [super allocWithZone:zone];
			return sharedInstance;
		}
	}
	
	return nil;
}

- (id) init {
	self = [super init];
	if (self != nil) {		
    
	}
	return self;
}

#pragma mark - public

- (void)showAlertWithMessage:(PGAlertMessage *)theMessage
{
  UIView *alertParentView = [[PGAppDelegate instance] window];
  
  UIView *keyboardView = [[UIApplication sharedApplication] peripheralHostView];
  
  if (keyboardView) {
    alertParentView = [keyboardView superview];
  }
  
  PGAlertSkinView *skin = [[PGAlertSkinView alloc]
                           initWithImage:[UIImage imageNamed:@"pg_alert_view_shield.png"]
                           contentViewFrame:CGRectMake(80, 178, 169, 86)];
  
  PGAlertMessageContentView *content = [[PGAlertMessageContentView alloc] 
                                        initWithTitle:[theMessage title]
                                        message:[theMessage message]
                                        foregroundColor:[UIColor whiteColor]
                                        backgroundColor:[UIColor clearColor]];
  
  [[[PGAlertView alloc] showInView:alertParentView
                       contentView:content
                          animated:YES 
                              skin:skin] autorelease];
  
  [skin release];
  [content release];  
}
@end