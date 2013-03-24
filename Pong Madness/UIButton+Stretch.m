//
//  UIButton+Stretch.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "UIButton+Stretch.h"

@implementation UIButton (Stretch)

- (void)stretchBackgroundImage {
    UIImage *normalBackgroundImage = [self backgroundImageForState:UIControlStateNormal];
    UIImage *normalStretchableBackgroundImage = [normalBackgroundImage stretchableImage];
    [self setBackgroundImage:normalStretchableBackgroundImage forState:UIControlStateNormal];
}

@end
