//
//  UIImage+Stretch.h
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Stretch)

- (UIImage *)stretchableImage;
+ (UIImage *)stretchableImageNamed:(NSString *)imageName;

/*
 * Initialize a stretchable horizontal image from it's file name. The stretch is done using the center pixels.
 */
+ (UIImage *)stretchableHorizontalImageNamed:(NSString *)imageName;

/*
 * Initialize a stretchable vertical image from it's file name. The stretch is done using the center pixels.
 */
+ (UIImage *)stretchableVerticalImageNamed:(NSString *)imageName;

@end
