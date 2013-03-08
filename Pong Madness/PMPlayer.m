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
@dynamic active;

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

- (PMLeaderboardPlayer *)leaderboardPlayerInLeaderboard:(PMLeaderboard *)leaderboard {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LeaderboardPlayer" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"leaderboard == %@ AND player == %@", leaderboard, self]];
    [fetchRequest setFetchLimit:1];
    
    NSError *error = nil;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (!error && [result count] == 1) {
        return [result lastObject];
    } else {
        return nil;
    }
}

- (NSNumber *)rankInLeaderboard:(PMLeaderboard *)leaderboard {
    __block NSUInteger rank = 0;
    
    NSSortDescriptor *victoryRatioSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"victoryRatio" ascending:NO];
    NSSortDescriptor *gamesPlayedCountSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"gamesPlayedCount" ascending:NO];
    NSArray *leaderboardPlayers = [leaderboard.leaderboardPlayerSet sortedArrayUsingDescriptors:@[victoryRatioSortDescriptor, gamesPlayedCountSortDescriptor]];
    
    [leaderboardPlayers enumerateObjectsUsingBlock:^(PMLeaderboardPlayer *leaderboardPlayer, NSUInteger index, BOOL *stop) {
        if (leaderboardPlayer.player == self) {
            rank = index + 1;
            *stop = YES;
        }
    }];
    
    if (rank != 0) {
        return @(rank);
    } else {
        return nil;
    }
}

- (NSNumber *)timePlayed {
    __block NSUInteger timePlayed = 0;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"ANY gameParticipantOrderedSet.participant == %@", self]];
    
    NSError *error = nil;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        [result enumerateObjectsUsingBlock:^(PMGame *game, NSUInteger idx, BOOL *stop) {
            timePlayed += [game.timePlayed unsignedIntValue];
        }];
    }
    return @(timePlayed);
}

- (void)descativate {
    
    // Remove from leaderboard
    NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
    [self.leaderboardPlayerSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [managedObjectContext deleteObject:obj];
    }];
    
    // Desactive the user
    self.active = @(NO);
    
    [[PMDocumentManager sharedDocument] save];
}

@end
