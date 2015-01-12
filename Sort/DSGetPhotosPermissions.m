//
//  DSGetPhotosPermissions.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 1/10/15.
//  Copyright (c) 2015 DS ltd. All rights reserved.
//

#pragma mark - include
#import "DSGetPhotosPermissions.h"
#import <AssetsLibrary/AssetsLibrary.h>

void DSRequestPhotosPermissions(void(^completion)(DSPhotosPermission permissions))
{
  if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized) {
    completion(DSPhotosPermissionAuthorized);
  }
  else if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined)
  {
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    
    //Request permissions
    [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                       usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                         if (*stop == NO) {
                           *stop = YES;
                           completion(DSPhotosPermissionAuthorized);
                         }
                       } failureBlock:^(NSError *error) {
                         completion(DSPhotosPermissionDenied);
                       }];
  }
  else {
    completion(DSPhotosPermissionDenied);
  }
}
