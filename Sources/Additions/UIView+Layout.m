
#import "UIView+Layout.h"
#import "NSString+Extras.h"


@implementation UIView (Layout)

- (void)verticallyLayoutLabels:(NSArray *)labels
                  labelsMargin:(CGFloat)margin
                     topMargin:(CGFloat)topMargin
                  bottomMargin:(CGFloat)bottomMargin
                   changeFrame:(BOOL)changeFrame
{
  CGRect previousLabelFrame = CGRectMake(0, topMargin-1-margin, 0, 1);

  for (UILabel *label in labels) {
    if (![label text] || [[label text] isEmpty]) {
      continue;
    }
    CGFloat width = [label frame].size.width;
    CGSize textSize = [[label text] sizeWithFont:[label font]
                               constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                                   lineBreakMode:[label lineBreakMode]];
    CGRect labelFrame = [label frame];
    labelFrame.origin.y = CGRectGetMaxY(previousLabelFrame) + margin;

    labelFrame.size.height = textSize.height;
    [label setFrame:labelFrame];
    previousLabelFrame = labelFrame;
  }

  if (changeFrame) {
    CGRect frame = [self frame];
    frame.size.height = CGRectGetMaxY(previousLabelFrame) + bottomMargin;
    [self setFrame:frame];
  }
}


- (void)verticallyLayoutLabels:(NSArray *)labels
                  labelsMargin:(CGFloat)margin
                     topMargin:(CGFloat)topMargin
                  bottomMargin:(CGFloat)bottomMargin
{
  [self verticallyLayoutLabels:labels labelsMargin:margin topMargin:topMargin bottomMargin:bottomMargin changeFrame:YES];
}

- (void)addSubViews:(NSArray *)subviews
{
  [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
  {
    assert([obj isKindOfClass:[UIView class]]);
    [self addSubview:obj];
  }];
}


- (void)verticallyLayoutLabels:(NSArray *)labels
                  labelsMargin:(CGFloat)margin
                     topMargin:(CGFloat)topMargin
                  bottomMargin:(CGFloat)bottomMargin
                   changeFrame:(BOOL)changeFrame
                      getFrame:(CGRect *)frame
{
  CGRect previousLabelFrame = CGRectMake(0, topMargin-1-margin, 0, 1);
  
  for (UILabel *label in labels) {
    if (![label text] || [[label text] isEmpty]) {
      continue;
    }
    CGFloat width = [label frame].size.width;
    CGSize textSize = [[label text] sizeWithFont:[label font]
                               constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                                   lineBreakMode:[label lineBreakMode]];
    CGRect labelFrame = [label frame];
    labelFrame.origin.y = CGRectGetMaxY(previousLabelFrame) + margin;
    
    labelFrame.size.height = textSize.height;
    [label setFrame:labelFrame];
    previousLabelFrame = labelFrame;
  }
  
  if (changeFrame) {
    CGRect frame = [self frame];
    frame.size.height = CGRectGetMaxY(previousLabelFrame) + bottomMargin;
    [self setFrame:frame];
  }
  
  *frame = [self frame];
}

@end
