//
//  JVAppHelper.m
//  JVTransitionAnimtor
//
//  Created by Jorge Valbuena on 2015-04-20.
//  Copyright (c) 2015 Jorge Valbuena. All rights reserved.
//

#import "JVAppHelper.h"

@implementation JVAppHelper

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    //converts the hex value into a colour
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [self colorWithRGBHex:hexNum];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex
{
    //converts a hex number into a colour
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (void)removeLayerFromView:(UIView *)view
{
    CAGradientLayer *layerToRemove;
    for (CALayer *aLayer in view.layer.sublayers) {
        if ([aLayer isKindOfClass:[CAGradientLayer class]]) {
            layerToRemove = (CAGradientLayer *)aLayer;
        }
    }
    
    [layerToRemove performSelector:@selector(removeFromSuperlayer)];
}

+ (void)setGradientBackgroundInView:(UIView *)view withFirstHexColor:(NSString *)firstHexColor andSecondHexColor:(NSString *)secondHexColor
{
    [self removeLayerFromView:view];
    
    // gradient background color
    CAGradientLayer *newGradient = [CAGradientLayer layer];
    newGradient.frame = view.frame;
    UIColor *firstColor = [self colorWithHexString:firstHexColor];
    UIColor *secondColor = [self colorWithHexString:secondHexColor];
    
    newGradient.colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
    [view.layer insertSublayer:newGradient atIndex:0];
}

+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end