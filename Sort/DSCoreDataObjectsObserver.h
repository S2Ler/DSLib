
@import Foundation;
#import "DSCoreDataObjectsObserverDelegate.h"
@import CoreData;

@interface DSCoreDataObjectsObserver : NSObject

+ (instancetype)sharedObserver;
+ (void)setSharedObserver:(DSCoreDataObjectsObserver *)observer;

- (id)initWithContext:(NSManagedObjectContext *)context;

- (void)addDelegate:(id<DSCoreDataObjectsObserverDelegate>)delegate filteringPredicate:(NSPredicate *)predicate;
- (void)removeDelegate:(id<DSCoreDataObjectsObserverDelegate>)delegate;
@end
