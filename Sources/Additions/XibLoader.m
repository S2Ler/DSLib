#import "XibLoader.h"


@implementation XibLoader
+ (NSArray *)xibNamed:(NSString *)theXibName {
  NSArray *xibElements = [[NSBundle mainBundle]
                          loadNibNamed:theXibName
                          owner:nil
                          options:nil];
  if ([xibElements count] > 0) {
    return xibElements;
  } else {
    return nil;
  }
}

+ (id)firstViewInXibNamed:(NSString *)theXibName {
  NSArray *xibElements = [self xibNamed:theXibName];
  
  if ([xibElements count] > 0) {
    return [xibElements objectAtIndex:0];
  } else {
    return nil;
  }    
}

@end
