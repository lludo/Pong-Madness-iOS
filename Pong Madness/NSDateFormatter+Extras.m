//
//  NSDateFormatter.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "NSDateFormatter+Extras.h"

@implementation NSDateFormatter (Extras)

+ (NSDate*)dateFromString:(NSString *)dateString withFormat:(NSString*)dateFormat {
	static NSDateFormatter *dateFormatter = nil;
   if (!dateFormatter) {
      dateFormatter = [[NSDateFormatter alloc] init];
      NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
      [dateFormatter setTimeZone:timeZone];
      [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
      [dateFormatter setDateFormat:dateFormat];

   }
	NSDate *date = [dateFormatter dateFromString:dateString];
	
	return date;
}

+ (NSString*)dateStringFromString:(NSString *)dateString fromFormat:(NSString*)fromFormat toFormat:(NSString*)toFormat {
	static NSDateFormatter *dateFormatter = nil;
	if (!dateFormatter) {
		dateFormatter = [[NSDateFormatter alloc] init];
		NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
		[dateFormatter setTimeZone:timeZone];
		[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	}
	[dateFormatter setDateFormat:fromFormat];
	NSDate *date = [dateFormatter dateFromString:dateString];
	[dateFormatter setDateFormat:toFormat];
	return 	[dateFormatter stringFromDate:date];
}

@end
