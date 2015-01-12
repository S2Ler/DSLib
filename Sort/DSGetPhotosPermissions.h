//
//  DSGetPhotosPermissions.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 1/10/15.
//  Copyright (c) 2015 DS ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int8_t, DSPhotosPermission) {
  DSPhotosPermissionAuthorized,
  DSPhotosPermissionDenied
};

void DSRequestPhotosPermissions(void(^completion)(DSPhotosPermission permissions));
