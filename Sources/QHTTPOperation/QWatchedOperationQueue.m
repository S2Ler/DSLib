#import "QWatchedOperationQueue.h"

@interface QWatchedOperationQueue ()
@property (weak, readwrite) id target;
@end

@implementation QWatchedOperationQueue

- (id)initWithTarget:(id)target
// See comment in header.
{
  assert(target != nil);
  self = [super init];
  if (self != nil) {
    self->_target = target;
    self->_targetThread = [NSThread currentThread];
    self->_operationToAction
      = CFDictionaryCreateMutable(NULL, 0,
                                        &kCFTypeDictionaryKeyCallBacks, NULL);
    assert(self->_operationToAction != NULL);
  }
  return self;
}

- (void)dealloc
{
  // can be called on any thread
  if (self->_operationToAction != NULL) {
    assert(CFDictionaryGetCount(self->_operationToAction) == 0);
    CFRelease(self->_operationToAction);
  }
}

@synthesize target = _target;
@synthesize targetThread = _targetThread;

- (void)addOperation:(NSOperation *)op finishedAction:(SEL)action
// See comment in header.
{
  // can be called on any thread
  assert(op != nil);
  assert(action != nil);

  // Add the operation-to-action map entry.  We do this synchronised
  // because we can be running on any thread.

  @synchronized (self) {
    assert( !CFDictionaryContainsKey(self->_operationToAction,
                                     (__bridge const void *) op) );
    CFDictionarySetValue(self->_operationToAction,
                         (__bridge const void *) op,
                         (const void *) action);
  }

  // Retain ourselves so that we can't go away while the operation is running,
  // and then observe the finished property of the operation.

  [op addObserver:self
       forKeyPath:@"isFinished"
          options:0
          context:&self->_target];

  // Call into the real NSOperationQueue.

  [self addOperation:op];
}

- (void)invalidate;
// See comment in header.
{
  assert([NSThread currentThread] == self.targetThread);

  // Because self.target is only referenced by this and -didFinishOperation:,
  // and both of these can only be called on the target thread, this doesn't
  // require synchronisation and is guaranteed to be effective against any
  // 'in flight' operations.

  self.target = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
// Called when the finished property of the operation changes.  We do very
// little here, but rather push the work off to the target thread.
{
  // can be called on any thread
  if (context == &self->_target) {
    assert([keyPath isEqual:@"isFinished"]);
    @synchronized (self) {
      assert( CFDictionaryContainsKey(self->_operationToAction,
                                      (__bridge const void *) object) );
    }
    assert([object isKindOfClass:[NSOperation class]]);

    // We ignore the change if isFinished is not set.  Various operations
    // end up triggering KVO notification on isFinished when they're not
    // actually finished so, just to be sure, we perform a definitive check
    // here.

    if ([((NSOperation *) object) isFinished]) {
      [self performSelector:@selector(didFinishOperation:)
                   onThread:self.targetThread
                 withObject:object
              waitUntilDone:NO];
    }
  }
  else {
    assert(NO);
  }
  if (NO) {
    [super observeValueForKeyPath:keyPath
                         ofObject:object
                           change:change
                          context:context];
  }
}

- (void)didFinishOperation:(NSOperation *)op
// Called on the target thread when an operation finishes.
{
  SEL action;

  assert([NSThread currentThread] == self.targetThread);
  assert([op isKindOfClass:[NSOperation class]]);
  assert([op isFinished]);

  // Pull the action out of the operation-to-action map, remembering the
  // action that was required.

  @synchronized (self) {
    assert( CFDictionaryContainsKey(self->_operationToAction,
                                    (__bridge const void *) op) );
    action = (SEL) CFDictionaryGetValue(self->_operationToAction,
                                        (__bridge const void *) op);
    CFDictionaryRemoveValue(self->_operationToAction, (__bridge const void *) op);
    assert(action != nil);
  }

  // Remove ourselves as an observer for this operation. We can now
  // safely release the retain on ourselves that we took in
  // -addOperation:finishedAction:.

  [op removeObserver:self forKeyPath:@"isFinished"];

  // If we haven't been invalidated, and the operation hasn't been
  // cancelled, call the action method.

  if ((self.target != nil) && ![op isCancelled]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.target performSelector:action withObject:op];
#pragma clang diagnostic pop

  }
}

@end
