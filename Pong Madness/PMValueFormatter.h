//
//  PMValueFormatter.h
//  Pong Madness
//
//  Created by Ludovic Landry on 03/02/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMValueFormatter : NSObject

+ (NSDateFormatter *)formatterDateShortStyle;
+ (NSDateFormatter *)formatterTimeMediumStyle;
+ (NSNumberFormatter *)formatterNumberDecimalStyle;

@end
