
@protocol DSAlertView;

@protocol DSAlertViewDelegate<NSObject>
- (void)        alertView:(id<DSAlertView>)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex;
@end
