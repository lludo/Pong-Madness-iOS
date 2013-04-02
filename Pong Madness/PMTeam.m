//
//  PMTeam.m
//  Pong Madness
//
//  Created by Ludovic Landry on 3/31/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMTeam.h"
#import "PMPlayer.h"
#import "PMDocumentManager.h"

@implementation PMTeam

@dynamic name;
@dynamic photo;
@dynamic playerSet;

+ (PMTeam *)teamWithName:(NSString *)aName {
    
    NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:managedObjectContext];
    PMTeam *team = [[PMTeam alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:managedObjectContext];
    
    team.name = aName;
    return team;
}


@end
