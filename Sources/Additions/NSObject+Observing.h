
typedef void (^NSObjectObserverBlock)(id object, NSString *keyPath);


@interface NSObject (Observing)
- (void)addObserver:(NSObject *)theObserver
        forKeyPaths:(NSString *)theKeyPath,...;
- (void)removeObserver:(NSObject *)theObserver
              keyPaths:(NSString *)theKeyPath,...;

/** Not thread save */
- (void)addObserverForKeyPath:(NSString *)keypath block:(NSObjectObserverBlock)block;
- (void)removeObserverForKeyPath:(NSString *)keyPath;
@end
