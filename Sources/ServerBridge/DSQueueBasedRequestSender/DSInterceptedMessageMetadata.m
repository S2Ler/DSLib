//
//  DSInterceptedMessageMetadata.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 4/2/15.
//  Copyright (c) 2015 DS ltd. All rights reserved.
//

#import "DSInterceptedMessageMetadata.h"
#import "DSWebServiceParams.h"

@implementation DSInterceptedMessageMetadata
- (BOOL)anyOfParams:(NSArray *)params
{
  for (Class paramClass in params) {
    if ([paramClass isSubclassOfClass:[self.params class]]) {
      return true;
    }
  }
  
  return false;
}
@end
