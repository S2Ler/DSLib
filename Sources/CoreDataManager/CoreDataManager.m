#pragma mark imports
#import "CoreDataManager.h"

#pragma mark =================props=================
@interface CoreDataManager()
@property (nonatomic, strong) NSMutableDictionary *fetchControllers;
@end

@implementation CoreDataManager
#pragma mark =================synth=================
@synthesize fetchControllers = fetchControllers_;

#pragma mark memory

#pragma mark Initialization
- (id) initWithModelFileName:(NSString *)aFileName
                   storePath:(NSString *)aPath 
{
	self = [super init];
	if (self != nil) {
		modelFileName_ = aFileName;
		storePath_ = aPath;
		fetchControllers_ = [[NSMutableDictionary alloc] init];
	}
	return self;
}

#pragma mark Core Data Stack
- (NSManagedObjectContext *)context {
	static 	NSManagedObjectContext *context_ = nil;
	
	if (context_ != nil) {
		return context_;
	}
	
	NSPersistentStoreCoordinator *aCoordinator = self.coordinator;
	if (aCoordinator != nil) {
		context_ = [[NSManagedObjectContext alloc] init];
		[context_ setPersistentStoreCoordinator:aCoordinator];
	}
	return context_;
}

- (NSManagedObjectModel *)model {
	static NSManagedObjectModel *model_ = nil;
	
	if (model_ != nil) {
		return model_;
	}
	
	NSString *modelPath 
  = [[NSBundle mainBundle] pathForResource:modelFileName_ ofType:@"momd"];
	NSURL *modelURL = [[NSURL alloc] initFileURLWithPath:modelPath];
	model_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	return model_;
}

- (NSPersistentStoreCoordinator *)coordinator {
	static NSPersistentStoreCoordinator *coordinator_ = nil;
	
	if (coordinator_ != nil) {
		return coordinator_;
	}
  
	NSURL *storeURL = [NSURL fileURLWithPath:storePath_];
  
	NSError *error = nil;
	coordinator_ 
  = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
	
  NSMutableDictionary *options 
  = [[NSMutableDictionary alloc] init];
  
	[options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
  
	if (![coordinator_ addPersistentStoreWithType:NSSQLiteStoreType 
                                  configuration:nil 
                                            URL:storeURL 
                                        options:options 
                                          error:&error]) {
		//TODO: Error handling
    //		[[ErrorHandler sharedInstance] handleError:error];
	}
  
	return coordinator_;
}

#pragma mark =================adding fetchcontrollers=================
- (NSFetchRequest *)fetchRequestWithEntity:(NSString *)anEntityName
                                 batchSize:(NSUInteger)aBatchSize
                                   sortKey:(NSString *)aSortKey
                               isAscending:(BOOL)anIsAscending
                           predicateFormat:(NSString *)aPredicateFormat {
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];	
	NSEntityDescription *entity = [NSEntityDescription entityForName:anEntityName
                                            inManagedObjectContext:[self context]];	
	[fetchRequest setEntity:entity];
	[fetchRequest setFetchBatchSize:aBatchSize];
	if (aSortKey) {
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:aSortKey
                                                                   ascending:anIsAscending];
		[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	}
	if (aPredicateFormat) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:aPredicateFormat];
		[fetchRequest setPredicate:predicate];
	}
	
	return fetchRequest;
}

- (NSFetchedResultsController *)fetchedResultControllerWithRequest:(NSFetchRequest *)aRequest
                                                sectionNameKeyPath:(NSString *)aSectionPath {
	NSFetchedResultsController *fetchController = 
	[[NSFetchedResultsController alloc] initWithFetchRequest:aRequest
                                      managedObjectContext:[self context] 
                                        sectionNameKeyPath:aSectionPath 
                                                 cacheName:nil];
	NSError *error = nil;
	if (![fetchController performFetch:&error]) {
		//TODO: Error handling
		//		[[ErrorHandler sharedInstance] handleError:error];
		return nil;
	}
	
	return fetchController;
}

- (void)addFetchControllerWithSortKey:(NSString *)sortKey 
                          isAscending:(BOOL)isAscending
                            batchSize:(NSUInteger)bachSize
                           entityName:(NSString *)entityName
                               forKey:(NSString *)aKey {
	NSFetchRequest *fetchRequest = [self fetchRequestWithEntity:entityName
                                                    batchSize:bachSize
                                                      sortKey:sortKey
                                                  isAscending:isAscending
                                              predicateFormat:nil];
	NSFetchedResultsController *newController = [self fetchedResultControllerWithRequest:fetchRequest
                                                                    sectionNameKeyPath:nil];
	[fetchControllers_ setObject:newController
                        forKey:aKey];
}
- (void)addFetchControllerWithSortKey:(NSString *)sortKey 
                          isAscending:(BOOL)isAscending
                            batchSize:(NSUInteger)bachSize
                           entityName:(NSString *)entityName
                      predicateFormat:(NSString *)aPredicateFormat
                               forKey:(NSString *)aKey {
	NSFetchRequest *fetchRequest = [self fetchRequestWithEntity:entityName
                                                    batchSize:bachSize
                                                      sortKey:sortKey
                                                  isAscending:isAscending
                                              predicateFormat:aPredicateFormat];
	NSFetchedResultsController *newController = [self fetchedResultControllerWithRequest:fetchRequest
                                                                    sectionNameKeyPath:nil];
	[fetchControllers_ setObject:newController
                        forKey:aKey];
}

- (void)addFetchControllerWithSortKey:(NSString *)sortKey 
                          isAscending:(BOOL)isAscending
                            batchSize:(NSUInteger)bachSize
                           entityName:(NSString *)entityName
                      predicateFormat:(NSString *)aPredicateFormat
                               forKey:(NSString *)aKey
                 sectionIdentifierKey:(NSString *)aSectionIdentifier {
	NSFetchRequest *fetchRequest = [self fetchRequestWithEntity:entityName
                                                    batchSize:bachSize
                                                      sortKey:sortKey
                                                  isAscending:isAscending
                                              predicateFormat:aPredicateFormat];
	NSFetchedResultsController *newController 
  = [self fetchedResultControllerWithRequest:fetchRequest
                          sectionNameKeyPath:aSectionIdentifier];
  if (newController) {
    [fetchControllers_ setObject:newController
                          forKey:aKey];
  }
}

- (NSFetchedResultsController *)fetchControllerForKey:(NSString *)aKey {
	return [fetchControllers_ objectForKey:aKey];
}

- (void)removeFetchControllerForKey:(NSString *)aKey {
	[fetchControllers_ removeObjectForKey:aKey];
}

- (void)saveContext {
	NSError *error = nil;
	NSManagedObjectContext *context = [self context];
	if (![context save:&error]) {
		[context rollback];
	}
}
@end
