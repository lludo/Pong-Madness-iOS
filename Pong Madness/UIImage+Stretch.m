//
//  UIImage+Stretch.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "UIImage+Stretch.h"

@implementation UIImage (Stretch)

+ (UIImage *)stretchableHorizontalImageNamed:(NSString *)imageName {
    UIImage *stretchableImage = [UIImage imageNamed:imageName];
    NSInteger verticalCap = truncf((stretchableImage.size.width - 1) / 2);
    UIEdgeInsets insets = UIEdgeInsetsMake(0, verticalCap, 0, verticalCap);
    return [stretchableImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

+ (UIImage *)stretchableVerticalImageNamed:(NSString *)imageName {
    UIImage *stretchableImage = [UIImage imageNamed:imageName];
    NSInteger horizontalCap = truncf((stretchableImage.size.height - 1) / 2);
    UIEdgeInsets insets = UIEdgeInsetsMake(horizontalCap, 0, horizontalCap, 0);
    return [stretchableImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

- (UIImage *)stretchableImage {
    NSInteger verticalCap = truncf((self.size.width - 1) / 2);
    NSInteger horizontalCap = truncf((self.size.height - 1) / 2);
    UIEdgeInsets insets = UIEdgeInsetsMake(horizontalCap, verticalCap, horizontalCap, verticalCap);
    return [self resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

+ (UIImage *)stretchableImageNamed:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImage];
}

@end
