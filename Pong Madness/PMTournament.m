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
        globalTournament.name = @"Global";
    }
    
    return globalTournament;
}

+ (PMTournament *)weakTournamentFromDate:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    gregorian.firstWeekday = 2; // Sunday = 1, Saturday = 7
    NSDateComponents *components = [gregorian components:NSWeekOfYearCalendarUnit | NSYearCalendarUnit fromDate:date];
    
    // Compute the leaderboard id
    NSString *weekTournamentName = [NSString stringWithFormat:@"Week-%i-%i", [components year], [components weekOfYear]];
    
    // Try to get the tournament that have the year and week name
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tournament" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name == %@", weekTournamentName]];
    [fetchRequest setFetchLimit:1];
    
    NSError *error = nil;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    PMTournament *weekTournament = nil;
    if ([result count] == 1) {
        weekTournament = [result lastObject];
    } else {
        weekTournament = [[PMTournament alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        weekTournament.name = weekTournamentName;
    }
    
    return weekTournament;
}

@end
