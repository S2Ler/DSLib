
#pragma mark - include
#import "DSCoreDataObjectsObserver.h"
@import CoreData;

@interface DSCoreDataObjectsObserver ()
@property (nonatomic, strong) NSPredicate *objectsFilter;
@end

@implementation DSCoreDataObjectsObserver

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithPredicate:(NSPredicate *)objectsFilter context:(NSManagedObjectContext *)context
{
  self = [super init];
  if (self) {
    _objectsFilter = objectsFilter;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contextDidSave:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:context];
  }
  return self;
}

- (void)contextDidSave:(NSNotification *)notification
{
  NSManagedObjectContext *context = [notification object];
  
  NSSet *updatedObjects = [[context updatedObjects] filteredSetUsingPredicate:[self objectsFilter]];
  if ([updatedObjects count] > 0 &&
      [[self delegate] respondsToSelector:@selector(coreDataObjectsObserver:didUpdateObjects:)]) {
    [[self delegate] coreDataObjectsObserver:self didUpdateObjects:updatedObjects];
  }
  
  NSSet *deletedObjects = [[context deletedObjects] filteredSetUsingPredicate:[self objectsFilter]];
  if ([deletedObjects count] > 0 &&
      [[self delegate] respondsToSelector:@selector(coreDataObjectsObserver:didDeleteObjects:)]) {
    [[self delegate] coreDataObjectsObserver:self didDeleteObjects:deletedObjects];
  }
  
  NSSet *insertedObjects = [[context insertedObjects] filteredSetUsingPredicate:[self objectsFilter]];
  if ([insertedObjects count] > 0 &&
      [[self delegate] respondsToSelector:@selector(coreDataObjectsObserver:didInsertObjects:)]) {
    [[self delegate] coreDataObjectsObserver:self didInsertObjects:insertedObjects];
  }
}

@end
