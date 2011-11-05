
#import "DSCheckButton.h"

@interface DSCheckButton()
@end

@implementation DSCheckButton 

- (void)dealloc {
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self
                 action:@selector(toggleState) 
       forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setUncheckedImage:(UIImage *)theUncheckedImage
             checkedImage:(UIImage *)theCheckedImage
{
  [self setImage:theUncheckedImage
        forState:UIControlStateNormal];
  
  [self setImage:theCheckedImage
        forState:UIControlStateSelected];
  CGSize image1Size = [theUncheckedImage size];
  CGSize image2Size = [theCheckedImage size];
  
  CGSize buttonSize = CGSizeMake(MAX(image1Size.width, image2Size.width),
                                 MAX(image1Size.height, image2Size.height));
  [self setBounds:CGRectMake(0, 0, buttonSize.width, buttonSize.height)];
}

- (BOOL)isChecked
{
  return [self isSelected];
}

- (void)setChecked:(BOOL)theFlag
{
  [self setSelected:theFlag];
}

- (void)setSelected:(BOOL)selected
{
  BOOL currentSelection = [self isSelected];
  
  if (currentSelection != selected) {
    [self willChangeValueForKey:@"isChecked"];  
  }
  
  [super setSelected:selected];
  
  if (currentSelection != selected) {
    [self didChangeValueForKey:@"isChecked"];
  }
}

- (void)toggleState
{
  [self setSelected:![self isSelected]];
}

@end
