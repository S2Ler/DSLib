//
//  NSError(Parse)
//  uPrintX
//
//  Created by Alexander Belyavskiy on 7/8/13.

#import "NSError+Parse.h"


@implementation NSError (Parse)
- (NSError *)correctedParseError
{
    NSMutableDictionary *userInfo = [[self userInfo] mutableCopy];
    NSString *parseError = [userInfo valueForKey:@"error"];
    
    if ([parseError rangeOfString:@"Error Domain=NSURLErrorDomain Code=-1009"].location != NSNotFound) {
        return [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:nil];
    }
    
    NSRange r1 = [parseError rangeOfString:@"\""];
    NSString *parseErrorDescription = nil;
    if (r1.location != NSNotFound) {
        NSRange subRange = NSMakeRange(r1.location+1, [parseError length] - r1.location - 1);
        NSRange r2 = [parseError rangeOfString:@"\""
                                       options:0
                                         range:subRange];
        NSRange descriptionRange = NSMakeRange(r1.location+1, r2.location - r1.location-1);
        parseErrorDescription = [parseError substringWithRange:descriptionRange];
    }
    else {
        parseErrorDescription = parseError;
    }
    
    if ([parseErrorDescription length] == 0) {
        parseErrorDescription = @"Unknown error";
    }
    
    [userInfo setObject:parseErrorDescription
                 forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:[self domain]
                               code:[self code]
                           userInfo:userInfo];
}

@end
