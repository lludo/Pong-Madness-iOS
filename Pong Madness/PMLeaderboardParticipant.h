//
//  PMLeaderboardParticipant.h
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PMLeaderboard, PMParticipant;

@interface PMLeaderboardParticipant : NSManagedObject

@property (nonatomic, strong) PMParticipant *participant;
@property (nonatomic, strong) NSNumber *gamesPlayedCount;
@property (nonatomic, strong) NSNumber *gamesWonCount;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) PMLeaderboard *leaderboard;

+ (PMLeaderboardParticipant *)leaderboardParticipantForParticipant:(PMParticipant *)participant inLeaderboard:(PMLeaderboard *)leaderboard;

- (void)recordVictoryAgainst:(PMLeaderboardParticipant *)againstPlayer;

@end
