//
//  PMTournament.h
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PMGame, PMLeaderboard, PMPlayer;

@interface PMTournament : NSManagedObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSSet *playerSet;
@property (nonatomic, strong) NSSet *gameSet;
@property (nonatomic, strong) PMLeaderboard *leaderboard;

+ (PMTournament *)globalTournament;
+ (PMTournament *)weakTournamentFromDate:(NSDate *)date;

@end

@interface PMTournament (CoreDataGeneratedAccessors)

- (void)addPlayerSetObject:(PMPlayer *)value;
- (void)removePlayerSetObject:(PMPlayer *)value;
- (void)addPlayerSet:(NSSet *)values;
- (void)removePlayerSet:(NSSet *)values;

- (void)addGameSetObject:(PMGame *)value;
- (void)removeGameSetObject:(PMGame *)value;
- (void)addGameSet:(NSSet *)values;
- (void)removeGameSet:(NSSet *)values;

@end
