//
//  PMValueFormatter.m
//  Pong Madness
//
//  Created by Ludovic Landry on 03/02/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMValueFormatter.h"

@implementation PMValueFormatter

+ (NSDateFormatter *)formatterDateShortStyle {
    static dispatch_once_t predicateDateFormatter;
    static NSDateFormatter *dateFormatter = nil;
    
    dispatch_once(&predicateDateFormatter, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.timeZone = [NSTimeZone localTimeZone];
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
        dateFormatter.dateStyle = kCFDateFormatterMediumStyle;
    });
    
    return dateFormatter;
}

+ (NSDateFormatter *)formatterTimeMediumStyle {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
        dateFormatter.timeStyle = NSDateFormatterMediumStyle;
        dateFormatter.dateStyle = NSDateFormatterNoStyle;
    });
    
    return dateFormatter;
}

+ (NSNumberFormatter *)formatterNumberDecimalStyle {
    static dispatch_once_t predicateNumberFormatter;
    static NSNumberFormatter *numberFormatter = nil;
    
    dispatch_once(&predicateNumberFormatter, ^{
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormatter setMaximumFractionDigits:1];
    });
    
    return numberFormatter;
}

@end
