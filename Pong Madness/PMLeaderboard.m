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
    PMTournament *globalTournament = [PMTournament globalTournament];
    
    // Try to get the leaderboard that have the global tournament attached
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Leaderboard" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"tournament == %@", globalTournament]];
    [fetchRequest setFetchLimit:1];
    
    NSError *error = nil;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    PMLeaderboard *globalLeaderboard = nil;
    if ([result count] == 1) {
        globalLeaderboard = [result lastObject];
    } else {
        globalLeaderboard = [[PMLeaderboard alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        globalLeaderboard.tournament = globalTournament;
    }
    
    return globalLeaderboard;
}

+ (PMLeaderboard *)lastWeekLeaderboard {
    NSDate *today = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
    [components setDay:([components day]-7)];
    NSDate *lastWeek = [calendar dateFromComponents:components];
    
    return [PMLeaderboard weekLeaderboardFromDate:lastWeek];
}

+ (PMLeaderboard *)currentWeekLeaderboard {
    NSDate *today = [NSDate date];
    return [PMLeaderboard weekLeaderboardFromDate:today];
}

+ (PMLeaderboard *)weekLeaderboardFromDate:(NSDate *)date {
    PMTournament *weekTournament = [PMTournament weakTournamentFromDate:date];
    
    // Try to get the leaderboard that have the global tournament attached
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Leaderboard" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"tournament == %@", weekTournament]];
    [fetchRequest setFetchLimit:1];
    
    NSError *error = nil;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    PMLeaderboard *globalLeaderboard = nil;
    if ([result count] == 1) {
        globalLeaderboard = [result lastObject];
    } else {
        globalLeaderboard = [[PMLeaderboard alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        globalLeaderboard.tournament = weekTournament;
    }
    
    return globalLeaderboard;
}

+ (PMPlayer *)playerOfTheWeek {
    NSDate *today = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
    [components setDay:([components day]-7)];
    NSDate *lastWeek = [calendar dateFromComponents:components];
    
    PMTournament *weekTournament = [PMTournament weakTournamentFromDate:lastWeek];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LeaderboardPlayer" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"leaderboard.tournament == %@ && victoryRatio == max(victoryRatio)", weekTournament]];
    [fetchRequest setFetchLimit:1];
    
    NSError *error = nil;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    PMLeaderboardPlayer *leaderboardPlayer = nil;
    if (result && [result count] == 1) {
        leaderboardPlayer = [result lastObject];
    }
    
    return leaderboardPlayer.player;
}

@end
