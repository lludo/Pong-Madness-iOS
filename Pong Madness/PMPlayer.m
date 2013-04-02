//
//  PMPlayer.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMPlayer.h"
#import "PMLeaderboardParticipant.h"
#import "PMBinome.h"
#import "PMTournament.h"
#import "PMDocumentManager.h"
#import "PMLeaderboard.h"
#import "PMGame.h"
#import "PMParticipant.h"
#import "PMTeam.h"

@implementation PMPlayer

@dynamic username;
@dynamic photo;
@dynamic email;
@dynamic handedness;
@dynamic binomeSet;
@dynamic sinceDate;
@dynamic tournamentSet;
@dynamic active;
@dynamic team;

+ (PMPlayer *)playerWithUsername:(NSString *)username {
    
    NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:managedObjectContext];
    PMPlayer *player = [[PMPlayer alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:managedObjectContext];
    
    player.username = username;
    player.sinceDate = [NSDate date];
    return player;
}

+ (BOOL)hasAtLeastPlayerCount:(NSUInteger)minCount {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"active == YES"]];
    [fetchRequest setIncludesSubentities:NO];
    
    NSError *error = nil;
    NSUInteger playerCount = [managedObjectContext countForFetchRequest:fetchRequest error:&error];
    if(playerCount == NSNotFound) {
        return NO;
    } else {
        return (playerCount >= minCount);
    }
}

- (NSArray *)gamesPlayed {
    
    //TODO: later manage doubles (when user won because it's binome won - not only when he directly won as a player but also as a binome)
    
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

- (PMLeaderboardParticipant *)leaderboardParticipantInLeaderboard:(PMLeaderboard *)leaderboard {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LeaderboardParticipant" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"leaderboard == %@ AND participant == %@", leaderboard, self]];
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
    
    NSSortDescriptor *ratingSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:NO];
    NSSortDescriptor *gamesPlayedCountSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"gamesPlayedCount" ascending:NO];
    NSArray *leaderboardParticipants = [leaderboard.leaderboardParticipantSet sortedArrayUsingDescriptors:@[ratingSortDescriptor, gamesPlayedCountSortDescriptor]];
    
    [leaderboardParticipants enumerateObjectsUsingBlock:^(PMLeaderboardParticipant *leaderboardParticipant, NSUInteger index, BOOL *stop) {
        if (leaderboardParticipant.participant == self) {
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
    [self.leaderboardParticipantSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [managedObjectContext deleteObject:obj];
    }];
    
    // Desactive the user
    self.active = @(NO);
    
    [[PMDocumentManager sharedDocument] save];
}

@end
