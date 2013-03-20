//
//  NSMutableArray+Additions.m
//
//  Created by Alexander Belyavskiy on 9/26/12.
//

#import "NSMutableArray+Additions.h"

@implementation NSMutableArray (Additions)
- (void)addObjectOrNil:(id)theObject
{
  if (theObject) {
    [self addObject:theObject];
  }
}
@end
