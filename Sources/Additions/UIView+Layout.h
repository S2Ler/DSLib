
@import Foundation;
@import UIKit;

@interface UIView (Layout)
- (void)verticallyLayoutLabels:(NSArray *)labels
                  labelsMargin:(CGFloat)margin
                     topMargin:(CGFloat)topMargin
                  bottomMargin:(CGFloat)bottomMargin
                   changeFrame:(BOOL)changeFrame;

- (void)verticallyLayoutLabels:(NSArray *)labels
                  labelsMargin:(CGFloat)margin
                     topMargin:(CGFloat)topMargin
                  bottomMargin:(CGFloat)bottomMargin
                   changeFrame:(BOOL)changeFrame
                      getFrame:(CGRect *)frame;


- (void)verticallyLayoutLabels:(NSArray *)labels
                  labelsMargin:(CGFloat)margin
                     topMargin:(CGFloat)topMargin
                  bottomMargin:(CGFloat)bottomMargin;

- (void)addSubViews:(NSArray *)subviews;
@end
