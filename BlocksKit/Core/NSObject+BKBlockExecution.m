//
//  NSObject+BKBlockExecution.m
//  BlocksKit
//

#import "NSObject+BKBlockExecution.h"

NS_INLINE dispatch_time_t BKTimeDelay(NSTimeInterval t) {
    return dispatch_time(DISPATCH_TIME_NOW, (uint64_t)(NSEC_PER_SEC * t));
}

NS_INLINE dispatch_queue_t BKGetBackgroundQueue(void) {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

static id <NSObject, NSCopying> BKDispatchCancellableBlock(dispatch_queue_t queue, NSTimeInterval delay, void(^block)(void)) {
    dispatch_time_t time = BKTimeDelay(delay);
    
    if (@available(iOS 8.0, macOS 10.10, tvOS 9.0, watchOS 2.0, *)) {
        dispatch_block_t ret = dispatch_block_create(0, block);
        dispatch_after(time, queue, ret);
        return ret;
    }
    
    __block BOOL cancelled = NO;
    void (^wrapper)(BOOL) = ^(BOOL cancel) {
        if (cancel) {
            cancelled = YES;
            return;
        }
        if (!cancelled) block();
    };
    
    dispatch_after(time, queue, ^{
        wrapper(NO);
    });
    
    return wrapper;
}

@implementation NSObject (BlocksKit)

- (id <NSObject, NSCopying>)bk_performAfterDelay:(NSTimeInterval)delay usingBlock:(void (^)(id obj))block
{
    return [self bk_performOnQueue:dispatch_get_main_queue() afterDelay:delay usingBlock:block];
}

+ (id <NSObject, NSCopying>)bk_performAfterDelay:(NSTimeInterval)delay usingBlock:(void (^)(void))block
{
    return [NSObject bk_performOnQueue:dispatch_get_main_queue() afterDelay:delay usingBlock:block];
}

- (id <NSObject, NSCopying>)bk_performInBackgroundAfterDelay:(NSTimeInterval)delay usingBlock:(void (^)(id obj))block
{
    return [self bk_performOnQueue:BKGetBackgroundQueue() afterDelay:delay usingBlock:block];
}

+ (id <NSObject, NSCopying>)bk_performInBackgroundAfterDelay:(NSTimeInterval)delay usingBlock:(void (^)(void))block
{
    return [NSObject bk_performOnQueue:BKGetBackgroundQueue() afterDelay:delay usingBlock:block];
}

- (id <NSObject, NSCopying>)bk_performOnQueue:(dispatch_queue_t)queue afterDelay:(NSTimeInterval)delay usingBlock:(void (^)(id obj))block
{
    NSParameterAssert(block != nil);
    
    return BKDispatchCancellableBlock(queue, delay, ^{
        block(self);
    });
}

+ (id <NSObject, NSCopying>)bk_performOnQueue:(dispatch_queue_t)queue afterDelay:(NSTimeInterval)delay usingBlock:(void (^)(void))block
{
    NSParameterAssert(block != nil);
    
    return BKDispatchCancellableBlock(queue, delay, block);
}

+ (void)bk_cancelBlock:(id <NSObject, NSCopying>)block
{
    NSParameterAssert(block != nil);
    
    if (@available(iOS 8.0, macOS 10.10, tvOS 9.0, watchOS 2.0, *)) {
        dispatch_block_cancel((dispatch_block_t)block);
        return;
    }
    
    void (^wrapper)(BOOL) = (void(^)(BOOL))block;
    wrapper(YES);
}

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@implementation NSObject (BKBlockExecution_Deprecated)

#pragma mark - Legacy verions

- (id <NSObject, NSCopying>)bk_performBlock:(void (^)(id obj))block afterDelay:(NSTimeInterval)delay
{
    return [self bk_performAfterDelay:delay usingBlock:block];
}

+ (id <NSObject, NSCopying>)bk_performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    return [self bk_performAfterDelay:delay usingBlock:block];
}

- (id <NSObject, NSCopying>)bk_performBlockInBackground:(void (^)(id obj))block afterDelay:(NSTimeInterval)delay
{
    return [self bk_performInBackgroundAfterDelay:delay usingBlock:block];
}

+ (id <NSObject, NSCopying>)bk_performBlockInBackground:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    return [self bk_performInBackgroundAfterDelay:delay usingBlock:block];
}

- (id <NSObject, NSCopying>)bk_performBlock:(void (^)(id obj))block onQueue:(dispatch_queue_t)queue afterDelay:(NSTimeInterval)delay
{
    return [self bk_performOnQueue:queue afterDelay:delay usingBlock:block];
}

+ (id <NSObject, NSCopying>)bk_performBlock:(void (^)(void))block onQueue:(dispatch_queue_t)queue afterDelay:(NSTimeInterval)delay
{
    return [self bk_performOnQueue:queue afterDelay:delay usingBlock:block];
}

@end

#pragma clang diagnostic pop
