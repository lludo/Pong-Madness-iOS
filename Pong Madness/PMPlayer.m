//
//  PMPlayer.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMPlayer.h"
#import "PMLeaderboardPlayer.h"
#import "PMTeam.h"
#import "PMTournament.h"
#import "PMDocumentManager.h"
#import "PMLeaderboard.h"
#import "PMGame.h"
#import "PMParticipant.h"

@implementation PMPlayer

@dynamic username;
@dynamic photo;
@dynamic email;
@dynamic company;
@dynamic handedness;
@dynamic leaderboardPlayerSet;
@dynamic teamSet;
@dynamic sinceDate;
@dynamic tournamentSet;

+ (PMPlayer *)playerWithUsername:(NSString *)username {
    
    NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:managedObjectContext];
    PMPlayer *player = [[PMPlayer alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:managedObjectContext];
    
    player.username = username;
    player.sinceDate = [NSDate date];
    return player;
}

- (NSArray *)gamesPlayed {
    
    //TODO: later manage doubles (when user won because it's team won - not only when he directly won as a player but also as a team)
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"timePlayed != %@ AND gameParticipantOrderedSet.participant CONTAINS %@", nil, self]];
    
    NSError *error = nil;
    NSArray *games = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        return nil;
    } else {
        return games;
    }
}

- (NSUInteger)wonGamesCount {
    __block NSUInteger wonGamesCount = 0;
    NSArray *playedGames = [self gamesPlayed];
    [playedGames enumerateObjectsUsingBlock:^(PMGame *game, NSUInteger idx, BOOL *stop) {
        PMParticipant *participant = [game participantWinnerWithMinimumScore:0 andScoresGap:2];
        if ([participant isKindOfClass:[PMPlayer class]]) {
            PMPlayer *player = (PMPlayer *)participant;
            if (player == self) {
                wonGamesCount++;
            }
        } else if ([participant isKindOfClass:[PMTeam class]]) {
            PMTeam *team = (PMTeam *)participant;
            if ([team.playerSet containsObject:self]) {
                wonGamesCount++;
            }
        }
    }];
    return wonGamesCount;
}

- (NSUInteger)lostGamesCount {
    __block NSUInteger wonGamesCount = 0;
    NSArray *playedGames = [self gamesPlayed];
    [playedGames enumerateObjectsUsingBlock:^(PMGame *game, NSUInteger idx, BOOL *stop) {
        PMParticipant *participant = [game participantWinnerWithMinimumScore:0 andScoresGap:2];
        if ([participant isKindOfClass:[PMPlayer class]]) {
            PMPlayer *player = (PMPlayer *)participant;
            if (player == self) {
                wonGamesCount++;
            }
        } else if ([participant isKindOfClass:[PMTeam class]]) {
            PMTeam *team = (PMTeam *)participant;
            if ([team.playerSet containsObject:self]) {
                wonGamesCount++;
            }
        }
    }];
    return [playedGames count] - wonGamesCount;
}

- (NSUInteger)playedGamesCount {
    NSArray *playedGames = [self gamesPlayed];
    return [playedGames count];
}

- (NSUInteger)rankInLeaderboard:(PMLeaderboard *)leaderboard {
    
}

@end
