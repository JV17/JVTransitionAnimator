//
//  JVTouchImageViewQueue.h
//  Pods
//
//  Created by Jorge Valbuena on 2015-04-20.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface JVTouchImageViewQueue : NSObject

/**
 *  Custom initializer for our ImageViewQueue with the queue size
 *
 *  @param a NSUInteger which represents the size of our queue
 *
 *  @return an initialized instancetype
*/
- (instancetype)initWithTouchesCount:(NSUInteger)count;

/**
 *  A helper function to remove ImageViews from our queue
 *
 *  @return the new queue without the removed ImageView
 */
- (UIImageView *)popTouchImageView;

/**
 *  A helper function to add ImageView to our queue
 *
 *  @param an UIImageView to be added to queue
 *
 *  @return n/a
 */
- (void)pushTouchImageView:(UIImageView *)touchImageView;

@end