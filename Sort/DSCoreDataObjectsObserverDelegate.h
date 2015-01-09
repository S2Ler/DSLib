
@import Foundation;

@class DSCoreDataObjectsObserver;

@protocol DSCoreDataObjectsObserverDelegate <NSObject>
@optional
- (void)coreDataObjectsObserver:(DSCoreDataObjectsObserver *)observer didInsertObjects:(NSSet *)objets;
- (void)coreDataObjectsObserver:(DSCoreDataObjectsObserver *)observer didUpdateObjects:(NSSet *)objets;
- (void)coreDataObjectsObserver:(DSCoreDataObjectsObserver *)observer didDeleteObjects:(NSSet *)objets;
@end
