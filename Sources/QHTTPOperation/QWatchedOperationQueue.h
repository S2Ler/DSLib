
@import Foundation;

@interface QWatchedOperationQueue : NSOperationQueue
{
  __weak id _target;
  NSThread *_targetThread;
  CFMutableDictionaryRef _operationToAction;
}

/* Initialise the object to call selectors on target on the current thread.
 target is /not/ retained, so we expect target's -dealloc method to call
 -invalidate. */
- (id)initWithTarget:(id)target;

/* The target object established when the object was initialised. */
@property (weak, readonly) id target;

/* The target thread established when the object was initialised. */
@property (retain, readonly) NSThread *targetThread;

/* Add an operation to the queue, calling the action on the target on
the target thread once it has finished.

IMPORTANT: The action is /not/ called if the operation is cancelled.
This cancellation check is done on the target thread just before the
action is called, so to avoid race conditions, it's best to cancel
your operations from the target thread.

This may be called on any thread. */
- (void)addOperation:(NSOperation *)operation finishedAction:(SEL)action;

/* Invalidate the queue, preventing any further calls to target.
This must be called on the target thread. */
- (void)invalidate;

@end
