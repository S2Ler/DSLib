
#pragma mark - include
#import "PGAlertSkinView.h"
#import "PGAlertSkinView+Private.h"

#pragma mark - Private
@interface PGAlertSkinView() {  
  CGRect _contentViewFrame;
}

@property (nonatomic, assign) CGRect contentViewFrame;

@end

@implementation PGAlertSkinView
@synthesize contentViewFrame = _contentViewFrame;

#pragma mark - memory
- (void)dealloc 
{
  [super dealloc];    
}

#pragma mark - init
- (id)initWithImage:(UIImage *)theImage
   contentViewFrame:(CGRect)theImageContentFrame 
{
  self = [super initWithImage:theImage];
  
  if (self) {
    _contentViewFrame = theImageContentFrame;
  }
  
  return self;
}

- (void)setFrame:(CGRect)frame
{
  CGRect boundsBeforeChange = [self bounds];
  [super setFrame:frame];
  CGRect boundsAfterChange = [self bounds];
  
  CGRect newContentViewFrame = [[self class] frame:[self contentViewFrame]
                       scaledWithRootViewFrameFrom:boundsBeforeChange
                                                to:boundsAfterChange];
  [self setContentViewFrame:newContentViewFrame];  
}
@end