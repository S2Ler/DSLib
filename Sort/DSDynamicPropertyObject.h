//
//  DSDynamicPropertyObject.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 2/5/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

@import Foundation;

@interface DSDynamicPropertyObject : NSObject
@property (nonatomic, strong) id container;

- (id)initWithContainer:(id)container;

- (id)containerValueForKeyPath:(NSString *)keyPath;

- (NSDictionary *)allValues;
@end

@interface DSDynamicPropertyObject (Abstract)

/** Needed for dynamic getter resolution.
 Usage:
 - create readonly property
 - overwrite keypathForGetter: method to return keypath in responseDictionary for this property
 - look into forwardInvocation: if some of the property types isn't supported and add a new handler
 */
- (NSString *)keypathForGetter:(NSString *)getter;

- (NSString *)dateFormatForGetter:(NSString *)getter;
@end
