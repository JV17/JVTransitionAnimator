//
//  JVTouchImageViewQueue.m
//  Pods
//
//  Created by Jorge Valbuena on 2015-04-20.
//
//

#import "JVTouchImageViewQueue.h"
#import "JVTouchHelper.h"

#define TOUCH_IMAGE @"JVTouchImage"


@interface JVTouchImageViewQueue()

@property (nonatomic, strong) NSMutableArray *queueArray;

@end

@implementation JVTouchImageViewQueue

#pragma mark - Custom initializer

/**
 *  Custom initializer for our ImageViewQueue with the queue size
 *
 *  @param a NSUInteger which represents the size of our queue
 *
 *  @return an initialized instancetype
 */
- (instancetype)initWithTouchesCount:(NSUInteger)count
{
    if (self = [super init])
    {
        self.queueArray = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i < count; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[JVTouchHelper bundleImageNamed:TOUCH_IMAGE]];
            [self.queueArray addObject:imageView];
        }
    }
    
    return self;
}


#pragma mark - Queue helper functions

/**
 *  A helper function to remove ImageViews from our queue
 *
 *  @return the new queue without the removed ImageView
 */
- (UIImageView *)popTouchImageView
{
    UIImageView *touchImageView = [self.queueArray firstObject];
    [self.queueArray removeObjectAtIndex:0];
    
    return touchImageView;
}

/**
 *  A helper function to add ImageView to our queue
 *
 *  @param an UIImageView to be added to queue
 *
 *  @return n/a
 */
- (void)pushTouchImageView:(UIImageView *)touchImageView
{
    [self.queueArray addObject:touchImageView];
}


@end