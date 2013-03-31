//
//  PMGame.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMGame.h"
#import "PMGameParticipant.h"
#import "PMTournament.h"
#import "PMParticipant.h"
#import "PMDocumentManager.h"
#import "PMTournament.h"
#import "PMPlayer.h"
#import "PMBinome.h"
#import "PMLeaderboard.h"
#import "PMLeaderboardParticipant.h"

@implementation PMGame

@dynamic type;
@dynamic timePlayed;
@dynamic startDate;
@dynamic gameParticipantOrderedSet;
@dynamic tournamentSet;

+ (PMGame *)gameWithParticipants:(NSArray *)participants {
    
    // Verify that we have 2 participants
    if ([participants count] != 2) {
        return nil;
    }
    
    // Retrieve the participants from the list
    PMParticipant *firstParticipant = [participants objectAtIndex:0];
    PMParticipant *secondParticipant = [participants objectAtIndex:1];
    
    // Create the game
    NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
    NSEntityDescription *gameEntityDescription = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:managedObjectContext];
    PMGame *game = [[PMGame alloc] initWithEntity:gameEntityDescription insertIntoManagedObjectContext:managedObjectContext];
    
    // Create the game participants using the participants
    PMGameParticipant *firstGameParticipant = [PMGameParticipant gameParticipantWithParticipant:firstParticipant];
    PMGameParticipant *secondGameParticipant = [PMGameParticipant gameParticipantWithParticipant:secondParticipant];
    
    // Assign the game participants to the game
    [game setGameParticipantOrderedSet:[NSOrderedSet orderedSetWithObjects:firstGameParticipant, secondGameParticipant, nil]];
    [game setTournamentSet:[NSSet setWithObject:[PMTournament globalTournament]]];
    return game;
}

- (BOOL)isGameOver {
    return (self.timePlayed != nil);
}

// When a new game is completed we update some denormalized fields
- (void)setTimePlayed:(NSNumber *)timePlayed {
    [self willChangeValueForKey:@"timePlayed"];
    [self setPrimitiveValue:timePlayed forKey:@"timePlayed"];
    [self didChangeValueForKey:@"timePlayed"];
    
    PMGameParticipant *firstGameParticipant = [self.gameParticipantOrderedSet objectAtIndex:0];
    PMGameParticipant *secondGameParticipant = [self.gameParticipantOrderedSet objectAtIndex:1];
    
    // Add the players to the global tournament
    PMTournament *globalTournament = [PMTournament globalTournament];
    [globalTournament addGameSetObject:self];
    if ([firstGameParticipant.participant isKindOfClass:[PMPlayer class]]) {
        [globalTournament addPlayerSetObject:(PMPlayer *)firstGameParticipant.participant];
        [globalTournament addPlayerSetObject:(PMPlayer *)secondGameParticipant.participant];
    } else if ([firstGameParticipant.participant isKindOfClass:[PMBinome class]]) {
        [globalTournament addPlayerSet:((PMBinome *)firstGameParticipant.participant).playerSet];
        [globalTournament addPlayerSet:((PMBinome *)secondGameParticipant.participant).playerSet];
    }
    
    // Update global leadearboard players
    PMLeaderboard *globalLeaderboard = [PMLeaderboard globalLeaderboard];
    if ([firstGameParticipant.participant isKindOfClass:[PMPlayer class]]) {
        PMPlayer *firstPlayer = (PMPlayer *)firstGameParticipant.participant;
        PMPlayer *secondPlayer = (PMPlayer *)secondGameParticipant.participant;
        PMLeaderboardParticipant *firstLeaderboardParticipant = [firstPlayer leaderboardParticipantInLeaderboard:globalLeaderboard];
        PMLeaderboardParticipant *secondLeaderboardParticipant = [secondPlayer leaderboardParticipantInLeaderboard:globalLeaderboard];
        if (!firstLeaderboardParticipant) {
            firstLeaderboardParticipant = [PMLeaderboardParticipant leaderboardParticipantForParticipant:firstPlayer inLeaderboard:globalLeaderboard];
        }
        if (!secondLeaderboardParticipant) {
            secondLeaderboardParticipant = [PMLeaderboardParticipant leaderboardParticipantForParticipant:secondPlayer inLeaderboard:globalLeaderboard];
        }
        if ([firstGameParticipant.score intValue] > [secondGameParticipant.score intValue]) {
            [firstLeaderboardParticipant recordVictoryAgainst:secondLeaderboardParticipant];
        } else {
            [secondLeaderboardParticipant recordVictoryAgainst:firstLeaderboardParticipant];
        }
    } else if ([firstGameParticipant.participant isKindOfClass:[PMBinome class]]) {
        
        //TODO: later manage binomes
    }
    
    // Update week leadearboard players
    PMLeaderboard *weekLeaderboard = [PMLeaderboard currentWeekLeaderboard];
    if ([firstGameParticipant.participant isKindOfClass:[PMPlayer class]]) {
        PMPlayer *firstPlayer = (PMPlayer *)firstGameParticipant.participant;
        PMPlayer *secondPlayer = (PMPlayer *)secondGameParticipant.participant;
        PMLeaderboardParticipant *firstLeaderboardParticipant = [firstPlayer leaderboardParticipantInLeaderboard:weekLeaderboard];
        PMLeaderboardParticipant *secondLeaderboardParticipant = [secondPlayer leaderboardParticipantInLeaderboard:weekLeaderboard];
        if (!firstLeaderboardParticipant) {
            firstLeaderboardParticipant = [PMLeaderboardParticipant leaderboardParticipantForParticipant:firstPlayer inLeaderboard:weekLeaderboard];
        }
        if (!secondLeaderboardParticipant) {
            secondLeaderboardParticipant = [PMLeaderboardParticipant leaderboardParticipantForParticipant:secondPlayer inLeaderboard:weekLeaderboard];
        }
        if ([firstGameParticipant.score intValue] > [secondGameParticipant.score intValue]) {
            [firstLeaderboardParticipant recordVictoryAgainst:secondLeaderboardParticipant];
        } else {
            [secondLeaderboardParticipant recordVictoryAgainst:firstLeaderboardParticipant];
        }
    } else if ([firstGameParticipant.participant isKindOfClass:[PMBinome class]]) {
        
        //TODO: later manage binomes
    }
}

- (NSNumber *)scoreForParticipant:(PMParticipant *)participant {
    __block NSNumber *score = nil;
    [self.gameParticipantOrderedSet enumerateObjectsUsingBlock:^(PMGameParticipant *gameParticipant, NSUInteger idx, BOOL *stop) {
        if (gameParticipant.participant == participant) {
            score = gameParticipant.score;
            *stop = YES;
        }
    }];
    return score;
}

- (void)increasePointsForParticipant:(PMParticipant *)participant {
    [self.gameParticipantOrderedSet enumerateObjectsUsingBlock:^(PMGameParticipant *gameParticipant, NSUInteger idx, BOOL *stop) {
        if (gameParticipant.participant == participant) {
            gameParticipant.score = @([gameParticipant.score integerValue] + 1);
            *stop = YES;
        }
    }];
}

- (void)decreasePointsForParticipant:(PMParticipant *)participant {
    [self.gameParticipantOrderedSet enumerateObjectsUsingBlock:^(PMGameParticipant *gameParticipant, NSUInteger idx, BOOL *stop) {
        if (gameParticipant.participant == participant) {
            NSInteger score = [gameParticipant.score integerValue];
            if (score > 0) {
                gameParticipant.score = @([gameParticipant.score intValue] - 1);
            }
            *stop = YES;
        }
    }];
}

- (PMParticipant *)participantWinnerWithMinimumScore:(NSInteger)score andScoresGap:(NSInteger)gap {
    PMGameParticipant *firstGameParticipant = [self.gameParticipantOrderedSet objectAtIndex:0];
    PMGameParticipant *secondGameParticipant = [self.gameParticipantOrderedSet objectAtIndex:1];
    NSInteger firstGameParticipantScore = [firstGameParticipant.score integerValue];
    NSInteger secondGameParticipantScore = [secondGameParticipant.score integerValue];
    
    if (firstGameParticipantScore >= score && secondGameParticipantScore + 2 <= firstGameParticipantScore) {
        return firstGameParticipant.participant;
    } else if (secondGameParticipantScore >= score && firstGameParticipantScore + 2 <= secondGameParticipantScore) {
        return secondGameParticipant.participant;
    } else {
        return nil;
    }
}

@end
