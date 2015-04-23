//
//  JVAppHelper.h
//  JVTransitionAnimtor
//
//  Created by Jorge Valbuena on 2015-04-20.
//  Copyright (c) 2015 Jorge Valbuena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVAppHelper : NSObject

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

+ (UIColor *)colorWithRGBHex:(UInt32)hex;

+ (void)removeLayerFromView:(UIView *)view;

+ (void)setGradientBackgroundInView:(UIView *)view withFirstHexColor:(NSString *)firstHexColor andSecondHexColor:(NSString *)secondHexColor;

+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size;

@end