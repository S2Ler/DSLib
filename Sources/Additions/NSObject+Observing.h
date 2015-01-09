@import Foundation;

typedef void (^NSObjectObserverBlock)(id object, NSString *keyPath);
typedef void (^NSObjectAggregatedObserverBlock) (id object, NSArray *changedKeypaths);

/** Important don't duplicate paths for on project anyhow */
@interface NSObject (Observing)
- (void)addObserver:(NSObject *)theObserver
        forKeyPaths:(NSString *)theKeyPath,...;
- (void)removeObserver:(NSObject *)theObserver
              keyPaths:(NSString *)theKeyPath,...;

/** Not thread save */
- (void)addObserverForKeyPath:(NSString *)keypath block:(NSObjectObserverBlock)block;
- (void)removeObserverForKeyPath:(NSString *)keyPath;

- (void)addAggregatedObserverForKeyPaths:(NSArray *)keypaths block:(NSObjectAggregatedObserverBlock)block;
- (void)removeObserverForKeyPaths:(NSArray *)keypaths;
@end
