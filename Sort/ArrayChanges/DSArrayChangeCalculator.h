//
//  DSArrayChangeCalculator
//  uPrintX
//
//  Created by Alexander Belyavskiy on 6/3/13.

#import <Foundation/Foundation.h>


@interface DSArrayChangeCalculator : NSObject
/** Objects in arrays are compared with isEqual: method
* @return array of DSArrayChange objects
* */
- (NSArray *)calculateChangesFromArray:(NSArray *)initialArray toArray:(NSArray *)newArray;
@end
