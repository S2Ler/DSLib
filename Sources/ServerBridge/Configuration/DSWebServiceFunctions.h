//
//  DSWebServiceFunctions.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 9/24/13.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSConfiguration.h"
#import "DSWebServiceParams.h"


@interface DSWebServiceFunctions : DSConfiguration
- (NSString *)functionForParams:(DSWebServiceParams *)params;
@end
