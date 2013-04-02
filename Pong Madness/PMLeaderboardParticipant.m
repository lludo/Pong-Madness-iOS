//
//  PMLeaderboardParticipant.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMLeaderboardParticipant.h"
#import "PMLeaderboard.h"
#import "PMParticipant.h"
#import "PMDocumentManager.h"
#import "SBEloRating.h"
#import "PMDefaultKFactorStrategy.h"

@implementation PMLeaderboardParticipant

@dynamic participant;
@dynamic gamesPlayedCount;
@dynamic gamesWonCount;
@dynamic rating;
@dynamic leaderboard;

+ (PMLeaderboardParticipant *)leaderboardParticipantForParticipant:(PMParticipant *)participant inLeaderboard:(PMLeaderboard *)leaderboard {
    
    NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"LeaderboardParticipant" inManagedObjectContext:managedObjectContext];
    PMLeaderboardParticipant *leaderboardParticipant = [[PMLeaderboardParticipant alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:managedObjectContext];
    
    SBEloRating *elo = [[SBEloRating alloc] initWithStrategy:[[PMDefaultKFactorStrategy alloc] init]];
    leaderboardParticipant.rating = @([elo initialRating]);
    
    leaderboardParticipant.participant = participant;
    leaderboardParticipant.leaderboard = leaderboard;
    return leaderboardParticipant;
}

- (void)recordVictoryAgainst:(PMLeaderboardParticipant *)againstPlayer {
    
    // Update winner stats
    self.gamesPlayedCount = @([self.gamesPlayedCount intValue] + 1);
    self.gamesWonCount = @([self.gamesWonCount intValue] + 1);
    
    // Update looser stats
    againstPlayer.gamesPlayedCount = @([againstPlayer.gamesPlayedCount intValue] + 1);
    
    // Compute elo for winner
    SBEloRating *elo = [[SBEloRating alloc] initWithStrategy:[[PMDefaultKFactorStrategy alloc] init]];
    
    NSUInteger winnerNewRating = [elo adjustedRatingForPlayerWithCompletedGames:[self.gamesPlayedCount unsignedIntegerValue]
                                                                andRating:[self.rating unsignedIntegerValue]
                                                                  scoring:1
                                                    againstOpponentRating:[againstPlayer.rating unsignedIntegerValue]];
    
    NSUInteger looserNewRating = [elo adjustedRatingForPlayerWithCompletedGames:[againstPlayer.gamesPlayedCount unsignedIntegerValue]
                                                                andRating:[againstPlayer.rating unsignedIntegerValue]
                                                                  scoring:0
                                                    againstOpponentRating:[self.rating unsignedIntegerValue]];
    
    self.rating = @(winnerNewRating);
    againstPlayer.rating = @(looserNewRating);
}

@end
