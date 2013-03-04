//
//  PMTournament.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMTournament.h"
#import "PMGame.h"
#import "PMLeaderboard.h"
#import "PMPlayer.h"
#import "PMDocumentManager.h"

@implementation PMTournament

@dynamic name;
@dynamic startDate;
@dynamic playerSet;
@dynamic gameSet;
@dynamic leaderboard;

+ (PMTournament *)globalTournament {
    PMTournament *globalTournament = nil;
    
    // Try to get the tournament "Global"
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tournament" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name == %@", @"Global"]];
    [fetchRequest setFetchLimit:1];
    
    NSError *error = nil;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([result count] == 1) {
        globalTournament = [result lastObject];
    } else {
        globalTournament = [[PMTournament alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    }
    
    return globalTournament;
}

@end
