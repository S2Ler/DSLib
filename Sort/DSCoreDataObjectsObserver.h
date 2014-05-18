
#import <Foundation/Foundation.h>
#import "DSCoreDataObjectsObserverDelegate.h"

@interface DSCoreDataObjectsObserver : NSObject
- (id)initWithContext:(NSManagedObjectContext *)context;

- (void)addDelegate:(id<DSCoreDataObjectsObserverDelegate>)delegate filteringPredicate:(NSPredicate *)predicate;
- (void)removeDelegate:(id<DSCoreDataObjectsObserverDelegate>)delegate;
@end
