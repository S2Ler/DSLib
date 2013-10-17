//
//  DSCompas.h
//  DSLib
//
//  Created by Alex on 16/10/2013.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation.CLLocationManagerDelegate;

@class DSCompas;
typedef void (^DSCompasHeadingBlock)(DSCompas *compas, float heading, NSError *error);

@interface DSCompas : NSObject<CLLocationManagerDelegate>
@property (nonatomic, copy) DSCompasHeadingBlock headingChangedHandler;
@end
