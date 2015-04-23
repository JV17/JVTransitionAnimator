//
//  JVTouchHelper.h
//  Pods
//
//  Created by Jorge Valbuena on 2015-04-20.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface JVTouchHelper : NSObject

/**
 *  Handles getting the bundle resources of our project
 *
 *  @return a NSBundle to our project
 */
+ (NSBundle *)myProjectResources;

/**
 *  Handles getting our assets from the bundle resources of our project
 *
 *  @param the name of the asset
 *
 *  @return an UIImage
 */
+ (UIImage *)bundleImageNamed:(NSString *)name;

@end