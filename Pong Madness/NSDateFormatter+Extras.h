//
//  NSDateFormatter.h
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Extras)

+ (NSDate*)dateFromString:(NSString *)dateString withFormat:(NSString*)dateFormat;
+ (NSString*)dateStringFromString:(NSString *)dateString fromFormat:(NSString*)fromFormat toFormat:(NSString*)toFormat;

@end


