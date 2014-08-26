
@protocol DSAlertViewDelegate;
@class DSAlert;

@protocol DSAlertView<NSObject>
@property (nonatomic, strong) DSAlert *alert;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id<DSAlertViewDelegate>)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
        otherTitles:(NSArray *)otherButtonTitles;

- (void)setDelegate:(id<DSAlertViewDelegate>)theDelegate;
- (void)show;
- (void)dismissAnimated:(BOOL)animated;

- (BOOL)isCancelButtonAtIndex:(NSInteger)theButtonIndex;
@end
