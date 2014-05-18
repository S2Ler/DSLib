
#import <Foundation/Foundation.h>
#import "DSCoreDataObjectsObserverDelegate.h"

@interface DSCoreDataObjectsObserver : NSObject
@property (nonatomic, weak) id<DSCoreDataObjectsObserverDelegate> delegate;

- (id)initWithPredicate:(NSPredicate *)objectsFilter context:(NSManagedObjectContext *)context;
@end
