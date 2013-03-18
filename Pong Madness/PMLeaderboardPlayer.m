//
//  PMLeaderboardPlayer.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMLeaderboardPlayer.h"
#import "PMLeaderboard.h"
#import "PMPlayer.h"
#import "PMDocumentManager.h"
#import "SBEloRating.h"
#import "PMDefaultKFactorStrategy.h"

@implementation PMLeaderboardPlayer

@dynamic player;
@dynamic gamesPlayedCount;
@dynamic gamesWonCount;
@dynamic victoryRatio;
@dynamic rating;
@dynamic leaderboard;

+ (PMLeaderboardPlayer *)leaderboardPlayerForPlayer:(PMPlayer *)player inLeaderboard:(PMLeaderboard *)leaderboard {
    
    NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"LeaderboardPlayer" inManagedObjectContext:managedObjectContext];
    PMLeaderboardPlayer *leaderboardPlayer = [[PMLeaderboardPlayer alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:managedObjectContext];
    
    SBEloRating *elo = [[SBEloRating alloc] initWithStrategy:[[PMDefaultKFactorStrategy alloc] init]];
    leaderboardPlayer.rating = @([elo initialRating]);
    
    leaderboardPlayer.player = player;
    leaderboardPlayer.leaderboard = leaderboard;
    return leaderboardPlayer;
}

- (void)recordVictoryAgainst:(PMLeaderboardPlayer *)againstPlayer {
    self.gamesPlayedCount = @([self.gamesPlayedCount intValue] + 1);
    self.gamesWonCount = @([self.gamesWonCount intValue] + 1);
    self.victoryRatio = @([self.gamesWonCount floatValue] / [self.gamesPlayedCount floatValue]);
    
    
    SBEloRating *elo = [[SBEloRating alloc] initWithStrategy:[[PMDefaultKFactorStrategy alloc] init]];
    NSUInteger newRating = [elo adjustedRatingForPlayerWithCompletedGames:[self.gamesPlayedCount unsignedIntegerValue]
                                                                andRating:[self.rating unsignedIntegerValue]
                                                                  scoring:1
                                                    againstOpponentRating:[againstPlayer.gamesPlayedCount unsignedIntegerValue]];
    self.rating = @(newRating);
}

- (void)recordDefeatAgainst:(PMLeaderboardPlayer *)againstPlayer {
    self.gamesPlayedCount = @([self.gamesPlayedCount intValue] + 1);
    self.victoryRatio = @([self.gamesWonCount floatValue] / [self.gamesPlayedCount floatValue]);
    
    SBEloRating *elo = [[SBEloRating alloc] initWithStrategy:[[PMDefaultKFactorStrategy alloc] init]];
    NSUInteger newRating = [elo adjustedRatingForPlayerWithCompletedGames:[self.gamesPlayedCount unsignedIntegerValue]
                                                                andRating:[self.rating unsignedIntegerValue]
                                                                  scoring:0
                                                    againstOpponentRating:[againstPlayer.gamesPlayedCount unsignedIntegerValue]];
    self.rating = @(newRating);
}

@end
