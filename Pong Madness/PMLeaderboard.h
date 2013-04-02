//
//  PMLeaderboard.h
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PMLeaderboardParticipant, PMTournament, PMPlayer;

@interface PMLeaderboard : NSManagedObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) PMTournament *tournament;
@property (nonatomic, strong) NSSet *leaderboardParticipantSet;

+ (PMLeaderboard *)globalLeaderboard;

+ (PMLeaderboard *)lastWeekLeaderboard;
+ (PMLeaderboard *)currentWeekLeaderboard;
+ (PMLeaderboard *)weekLeaderboardFromDate:(NSDate *)date;

+ (PMPlayer *)playerOfTheWeek;

@end

@interface PMLeaderboard (CoreDataGeneratedAccessors)

- (void)addLeaderboardParticipantSetObject:(PMLeaderboardParticipant *)value;
- (void)removeLeaderboardParticipantSetObject:(PMLeaderboardParticipant *)value;
- (void)addLeaderboardPParticipantSet:(NSSet *)values;
- (void)removeLeaderboardParticipantSet:(NSSet *)values;

@end
