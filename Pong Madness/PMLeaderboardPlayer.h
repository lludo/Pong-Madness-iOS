//
//  PMLeaderboardPlayer.h
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PMLeaderboard, PMPlayer;

@interface PMLeaderboardPlayer : NSManagedObject

@property (nonatomic, strong) PMPlayer *player;
@property (nonatomic, strong) NSNumber *gamesPlayedCount;
@property (nonatomic, strong) NSNumber *gamesWonCount;
@property (nonatomic, strong) NSNumber *victoryRatio;
@property (nonatomic, strong) PMLeaderboard *leaderboard;

+ (PMLeaderboardPlayer *)leaderboardPlayerForPlayer:(PMPlayer *)player inLeaderboard:(PMLeaderboard *)leaderboard;

- (void)recordVictory;
- (void)recordDefeat;

@end
