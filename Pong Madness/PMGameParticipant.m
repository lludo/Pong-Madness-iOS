//
//  PMGameParticipant.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMGameParticipant.h"
#import "PMGame.h"
#import "PMParticipant.h"
#import "PMDocumentManager.h"

@implementation PMGameParticipant

@dynamic score;
@dynamic participant;
@dynamic game;

+ (PMGameParticipant *)gameParticipantWithParticipant:(PMParticipant *)participant {
    
    NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"GameParticipant" inManagedObjectContext:managedObjectContext];
    PMGameParticipant *gameParticipant = [[PMGameParticipant alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:managedObjectContext];
    
    gameParticipant.participant = participant;
    gameParticipant.score = @(0);
    return gameParticipant;
}

@end
