//
//  PMLeaderboard.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMLeaderboard.h"
#import "PMLeaderboardPlayer.h"
#import "PMTournament.h"
#import "PMDocumentManager.h"

@implementation PMLeaderboard

@dynamic type;
@dynamic tournament;
@dynamic leaderboardPlayerSet;

+ (PMLeaderboard *)globalLeaderboard {
    PMLeaderboard *globalLeaderboard = nil;
    
    // Try to get the leaderboard that have the global tournament attached
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Leaderboard" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"tournament == %@", [PMTournament globalTournament]]];
    [fetchRequest setFetchLimit:1];
    
    NSError *error = nil;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([result count] == 1) {
        globalLeaderboard = [result lastObject];
    } else {
        globalLeaderboard = [[PMLeaderboard alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    }
    
    return globalLeaderboard;
}

@end
