
#pragma mark - include
#import "PGAlertActionContentView.h"

#define LABEL_MARGIN 10.0
#define BUTTON_MARGIN 15.0

#pragma mark - Private
@interface PGAlertActionContentView ()
{
@protected
  NSInvocation *_action;
  UIButton *_actionButton;
}

@property(nonatomic, retain) NSInvocation *action;

- (void)performAlertAction;
@end

@implementation PGAlertActionContentView
@synthesize actionButton = _actionButton;
@synthesize action = _action;

#pragma mark - memory
- (void)dealloc
{
  PG_SAVE_RELEASE(_action);
  PG_SAVE_RELEASE(_actionButton);

  [super dealloc];
}

#pragma mark - init
- (id)initWithTitle:(NSString *)theTitle
            message:(NSString *)theMessage
    foregroundColor:(UIColor *)theForegroundColor
    backgroundColor:(UIColor *)theBackgroundColor
{
  return [self initWithTitle:theTitle
                     message:theMessage
             foregroundColor:theForegroundColor
             backgroundColor:theBackgroundColor
                      action:nil actionImage:nil];
}

- (id)initWithTitle:(NSString *)theTitle
            message:(NSString *)theMessage
    foregroundColor:(UIColor *)theForegroundColor
    backgroundColor:(UIColor *)theBackgroundColor
             action:(NSInvocation *)theAction
        actionImage:(UIImage *)theActionImage
{
  self = [super initWithTitle:theTitle
                      message:theMessage
              foregroundColor:theForegroundColor
              backgroundColor:theBackgroundColor];

  if (self) {
    [self setClipsToBounds:YES];
    _action = [theAction retain];

    _actionButton = [[UIButton alloc] init];
    [_actionButton setBackgroundImage:theActionImage
                             forState:UIControlStateNormal];
    [_actionButton addTarget:self
                      action:@selector(performAlertAction)
            forControlEvents:UIControlEventTouchDown];
    CGSize buttonImageSize = [theActionImage size];
    [_actionButton setBounds:CGRectMake(0,
                                        0,
                                        buttonImageSize.width,
                                        buttonImageSize.height)];
    [self addSubview:_actionButton];
  }

  return self;
}

#pragma mark - public

#pragma mark - layout
- (void)layoutSubviews
{
  //No need for super layout as it is fully custom layout
  CGRect bounds = [self bounds];

  CGSize titleSize = [[[self titleLabel] text]
                             sizeWithFont:[[self titleLabel] font]
                        constrainedToSize:CGSizeMake(bounds.size.width,
                                                     bounds.size.height)
                            lineBreakMode:UILineBreakModeWordWrap];

  CGSize messageSize
      = [[[self messageLabel] text]
                sizeWithFont:[[self messageLabel] font]
           constrainedToSize:CGSizeMake(bounds.size.width,
                                        bounds.size.height -
                                        titleSize.height - LABEL_MARGIN)
               lineBreakMode:UILineBreakModeWordWrap];

  CGSize buttonSize = [[self actionButton] bounds].size;

  CGFloat titleY = (bounds.size.height
                    - (titleSize.height
                       + messageSize.height
                       + buttonSize.height
                       + LABEL_MARGIN + BUTTON_MARGIN)) / 2.0;

  CGRect titleFrame =
      CGRectMake(floor((bounds.size.width - titleSize.width) / 2.0),
                 titleY,
                 titleSize.width,
                 titleSize.height);

  CGRect messageFrame
      = CGRectMake(floor((bounds.size.width - messageSize.width) / 2.0),
                   CGRectGetMaxY(titleFrame) + LABEL_MARGIN,
                   messageSize.width,
                   messageSize.height);

  CGRect buttonFrame
      = CGRectMake(floor((bounds.size.width - buttonSize.width) / 2.0),
                   CGRectGetMaxY(messageFrame) + BUTTON_MARGIN,
                   buttonSize.width,
                   buttonSize.height);

  [[self titleLabel] setFrame:titleFrame];
  [[self messageLabel] setFrame:messageFrame];
  [[self actionButton] setFrame:buttonFrame];
}

#pragma mark - action
- (void)performAlertAction
{
  [[self action] invoke];
}

@end
