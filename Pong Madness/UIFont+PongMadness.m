//
//  UIFont+PongMadness.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "UIFont+PongMadness.h"

@implementation UIFont (PongMadness)

+ (UIFont *)brothersBoldFontOfSize:(CGFloat)pointSize {
   static UIFont *font = nil;
//   static dispatch_once_t onceToken;
//   dispatch_once(&onceToken, ^{
      font = [UIFont fontWithName:@"Brothers-Bold" size:pointSize];
//   });
   
   return font;
}

+ (void)printAvailableFonts {
   for (NSString *fontFamily in [UIFont familyNames]) {
      for (NSString *fontName in [UIFont fontNamesForFamilyName:fontFamily]) {
         NSLog(@"%@/%@", fontFamily, fontName);
      }
   }
}


@end
