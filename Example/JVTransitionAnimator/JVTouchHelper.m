//
//  JVTouchHelper.m
//  Pods
//
//  Created by Jorge Valbuena on 2015-04-20.
//
//

#import "JVTouchHelper.h"
#import "JVTouchEventsWindow.h"


#define RESOURCE_NAME @"JVTouchEventsWindow"

@implementation JVTouchHelper

/**
 *  Handles getting the bundle resources of our project
 *
 *  @return a NSBundle to our project
 */
+ (NSBundle *)myProjectResources
{
    static dispatch_once_t onceToken;
    static NSBundle *bundle = nil;
    
    dispatch_once(&onceToken, ^{
        // This bundle name must be the same as the product name for the resources bundle target
        NSURL *url = [[NSBundle bundleForClass:[JVTouchEventsWindow class]] URLForResource:RESOURCE_NAME withExtension:@"bundle"];
    
        if (!url) {
            url = [[NSBundle mainBundle] URLForResource:RESOURCE_NAME withExtension:@"bundle"];
        }
        
        bundle = [NSBundle bundleWithURL:url];
    });
    
    return bundle;
}

/**
 *  Handles getting our assets from the bundle resources of our project
 *
 *  @param the name of the asset
 *
 *  @return an UIImage
 */
+ (UIImage *)bundleImageNamed:(NSString *)name
{
    UIImage *imageFromMainBundle = [UIImage imageNamed:name];
 
    if (imageFromMainBundle) {
        return imageFromMainBundle;
    }
    
    NSString *imageName = [NSString stringWithFormat:@"%@.bundle/%@", RESOURCE_NAME, name];
    UIImage *imageFromBundle = [UIImage imageNamed:imageName];
    
    if (!imageFromBundle) {
        NSLog(@"Image not found: %@", name);
    }
    
    return imageFromBundle;
}

@end