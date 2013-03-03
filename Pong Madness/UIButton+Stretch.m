//
//  UIButton+Stretch.m
//  KwarterMobile
//
//  Created by Ludovic Landry on 14/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import "UIButton+Stretch.h"

@implementation UIButton (Stretch)

- (void)stretchBackgroundImage {
    UIImage *normalBackgroundImage = [self backgroundImageForState:UIControlStateNormal];
    UIImage *normalStretchableBackgroundImage = [normalBackgroundImage stretchableImage];
    [self setBackgroundImage:normalStretchableBackgroundImage forState:UIControlStateNormal];
}

@end
