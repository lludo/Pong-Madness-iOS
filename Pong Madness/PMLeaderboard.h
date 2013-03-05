//
//  PMLeaderboard.h
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PMLeaderboardPlayer, PMTournament;

@interface PMLeaderboard : NSManagedObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) PMTournament *tournament;
@property (nonatomic, strong) NSSet *leaderboardPlayerSet;

+ (PMLeaderboard *)globalLeaderboard;

+ (PMLeaderboard *)lastWeekLeaderboard;
+ (PMLeaderboard *)currentWeekLeaderboard;
+ (PMLeaderboard *)weekLeaderboardFromDate:(NSDate *)date;
@end

@interface PMLeaderboard (CoreDataGeneratedAccessors)

- (void)addLeaderboardPlayerSetObject:(PMLeaderboardPlayer *)value;
- (void)removeLeaderboardPlayerSetObject:(PMLeaderboardPlayer *)value;
- (void)addLeaderboardPlayerSet:(NSSet *)values;
- (void)removeLeaderboardPlayerSet:(NSSet *)values;

@end
