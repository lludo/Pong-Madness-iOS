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

@end
