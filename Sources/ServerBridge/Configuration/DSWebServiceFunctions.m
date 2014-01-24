//
//  DSWebServiceFunctions.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 9/24/13.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#import "DSWebServiceFunctions.h"

@implementation DSWebServiceFunctions
- (NSString *)functionForParams:(DSWebServiceParams *)params
{
  return [self valueForKey:NSStringFromClass([params class])];
}

- (BOOL)isHTTPSForcedForParams:(DSWebServiceParams *)params
{
  NSArray *HTTPSOnlyParams = [self valueForKey:@"HTTPSOnly"];
  BOOL isHTTPSForced = [HTTPSOnlyParams containsObject:NSStringFromClass([params class])];
  return isHTTPSForced;
}
@end
