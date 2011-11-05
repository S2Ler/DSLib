
#pragma mark - include
#import "PGAlertMessageContentView.h"

#define MARGIN 10.0

#pragma mark - Private
@interface PGAlertMessageContentView ()
{
@protected
  UILabel *_titleLabel;
  UILabel *_messageLabel;
}

@end

@implementation PGAlertMessageContentView
@synthesize titleLabel = _titleLabel;
@synthesize messageLabel = _messageLabel;

#pragma mark - memory
- (void)dealloc
{
  PG_SAVE_RELEASE(_titleLabel);
  PG_SAVE_RELEASE(_messageLabel);

  [super dealloc];
}

#pragma mark - init

- (id)init
{
  return [self
      initWithTitle:nil message:nil foregroundColor:[UIColor whiteColor]
    backgroundColor:[UIColor clearColor]];
}

- (id)initWithTitle:(NSString *)theTitle
            message:(NSString *)theMessage
    foregroundColor:(UIColor *)theForegroundColor
    backgroundColor:(UIColor *)theBackgroundColor
{
  self = [super init];

  if (self) {
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setText:theTitle];
    [_titleLabel setLineBreakMode:UILineBreakModeWordWrap];
    [_titleLabel setNumberOfLines:0];
    [_titleLabel setBackgroundColor:theBackgroundColor];
    [_titleLabel setTextColor:theForegroundColor];
    [_titleLabel setTextAlignment:UITextAlignmentCenter];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:16]];

    [self addSubview:_titleLabel];

    _messageLabel = [[UILabel alloc] init];
    [_messageLabel setText:theMessage];
    [_messageLabel setLineBreakMode:UILineBreakModeWordWrap];
    [_messageLabel setNumberOfLines:0];
    [_messageLabel setBackgroundColor:theBackgroundColor];
    [_messageLabel setTextColor:theForegroundColor];
    [_messageLabel setTextAlignment:UITextAlignmentCenter];
    [_messageLabel setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:_messageLabel];
  }

  return self;
}

#pragma mark - public

#pragma mark - layout
- (void)layoutSubviews
{
  [super layoutSubviews];
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
                                        titleSize.height - MARGIN)
               lineBreakMode:UILineBreakModeWordWrap];

  CGFloat titleY = (bounds.size.height
                    - (titleSize.height + messageSize.height + MARGIN)) / 2.0;

  CGRect titleFrame =
      CGRectMake(floor((bounds.size.width - titleSize.width) / 2.0),
                 titleY,
                 titleSize.width,
                 titleSize.height);

  CGRect messageFrame
      = CGRectMake(floor((bounds.size.width - messageSize.width) / 2.0),
                   CGRectGetMaxY(titleFrame) + MARGIN,
                   messageSize.width,
                   messageSize.height);

  [[self titleLabel] setFrame:titleFrame];
  [[self messageLabel] setFrame:messageFrame];
}
@end
