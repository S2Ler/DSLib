#import <UIKit/UIKit.h>
#import "DSValueChooserViewControllerDelegate.h"

typedef id (^value_filter_block_t)(id value);

/** Designed to be pushed to UINavigationController */
@interface DSValueChooserViewController : UIViewController
<
UITableViewDelegate,
UITableViewDataSource
> {
  NSArray *_values;
  
  NSIndexPath *_selectedPath;
  
  id<DSValueChooserViewControllerDelegate> _delegate;
    
  NSDictionary *_userInfo;
  
  value_filter_block_t _filter;
}

@property (nonatomic, retain) id<DSValueChooserViewControllerDelegate> delegate;
@property (nonatomic, retain) NSDictionary *userInfo;

/** \param theValues for non NSString objects description 
 *   selector will be used. theValues is retained.
 **/
- (id)initWithValues:(NSArray *)theValues
       selectedValue:(id)selectedValue;

- (void)setValueFilterBlock:(value_filter_block_t)theFilter;

@end
