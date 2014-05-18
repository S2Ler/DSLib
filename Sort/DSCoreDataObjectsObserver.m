
#pragma mark - include
#import "DSCoreDataObjectsObserver.h"
@import CoreData;

@interface DSCoreDataObjectsObserver ()
@property (nonatomic, strong) NSMapTable *delegates;
@end

@implementation DSCoreDataObjectsObserver

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithContext:(NSManagedObjectContext *)context
{
  self = [super init];
  if (self) {
    _delegates = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory
                                           valueOptions:NSPointerFunctionsStrongMemory
                                               capacity:3];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contextDidSave:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:context];
  }
  return self;
}

- (void)addDelegate:(id<DSCoreDataObjectsObserverDelegate>)delegate filteringPredicate:(NSPredicate *)predicate
{
  [[self delegates] setObject:predicate forKey:delegate];
}

- (void)removeDelegate:(id<DSCoreDataObjectsObserverDelegate>)delegate
{
  [[self delegates] removeObjectForKey:delegate];
}

- (void)contextDidSave:(NSNotification *)notification
{
  NSManagedObjectContext *context = [notification object];
  
  for (id<DSCoreDataObjectsObserverDelegate> delegate in [[self delegates] keyEnumerator]) {
    @autoreleasepool {
      NSPredicate *predicate = [self predicateForDelegate:delegate];
      
      NSSet *updatedObjects = [[context updatedObjects] filteredSetUsingPredicate:predicate];
      if ([updatedObjects count] > 0 &&
          [delegate respondsToSelector:@selector(coreDataObjectsObserver:didUpdateObjects:)]) {
        [delegate coreDataObjectsObserver:self didUpdateObjects:updatedObjects];
      }
      
      NSSet *deletedObjects = [[context deletedObjects] filteredSetUsingPredicate:predicate];
      if ([deletedObjects count] > 0 &&
          [delegate respondsToSelector:@selector(coreDataObjectsObserver:didDeleteObjects:)]) {
        [delegate coreDataObjectsObserver:self didDeleteObjects:deletedObjects];
      }
      
      NSSet *insertedObjects = [[context insertedObjects] filteredSetUsingPredicate:predicate];
      if ([insertedObjects count] > 0 &&
          [delegate respondsToSelector:@selector(coreDataObjectsObserver:didInsertObjects:)]) {
        [delegate coreDataObjectsObserver:self didInsertObjects:insertedObjects];
      }
    }
  }
}

- (NSPredicate *)predicateForDelegate:(id<DSCoreDataObjectsObserverDelegate>)delegate
{
  return [[self delegates] objectForKey:delegate];
}

@end
