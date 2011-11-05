#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


/*
 Context, model, coordinator shared among CoreDataManager instances
 FetchController unique
 */
@interface CoreDataManager : NSObject {
@private
	//Options
	NSString *modelFileName_;
	NSString *storePath_;
	
	NSMutableDictionary *fetchControllers_;
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *context;
@property (nonatomic, retain, readonly) NSManagedObjectModel *model;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *coordinator;

- (id) initWithModelFileName:(NSString *)aFileName
                   storePath:(NSString *)aPath;

- (NSFetchRequest *)fetchRequestWithEntity:(NSString *)anEntityName
                                 batchSize:(NSUInteger)aBatchSize
                                   sortKey:(NSString *)aSortKey
                               isAscending:(BOOL)anIsAscending
                           predicateFormat:(NSString *)aPredicateFormat;

- (void)addFetchControllerWithSortKey:(NSString *)sortKey 
                          isAscending:(BOOL)isAscending
                            batchSize:(NSUInteger)bachSize
                           entityName:(NSString *)entityName
                               forKey:(NSString *)aKey;

- (void)addFetchControllerWithSortKey:(NSString *)sortKey 
                          isAscending:(BOOL)isAscending
                            batchSize:(NSUInteger)bachSize
                           entityName:(NSString *)entityName
                      predicateFormat:(NSString *)aPredicateFormat
                               forKey:(NSString *)aKey;

- (void)addFetchControllerWithSortKey:(NSString *)sortKey 
                          isAscending:(BOOL)isAscending
                            batchSize:(NSUInteger)bachSize
                           entityName:(NSString *)entityName
                      predicateFormat:(NSString *)aPredicateFormat
                               forKey:(NSString *)aKey
                 sectionIdentifierKey:(NSString *)aSectionIdentifier;

- (NSFetchedResultsController *)fetchControllerForKey:(NSString *)aKey;
- (void)removeFetchControllerForKey:(NSString *)aKey;	

- (void)saveContext;

@end
