//
//  AFHTTPBodyPartReadPhase.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/4/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

@import Foundation;

typedef NS_ENUM (NSUInteger, AFHTTPBodyPartReadPhase) {
  AFEncapsulationBoundaryPhase = 1,
  AFHeaderPhase                = 2,
  AFBodyPhase                  = 3,
  AFFinalBoundaryPhase         = 4,
};