//
//  PMGameParticipant.h
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PMGame, PMParticipant;

@interface PMGameParticipant : NSManagedObject

@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) PMParticipant *participant;
@property (nonatomic, strong) PMGame *game;

+ (PMGameParticipant *)gameParticipantWithParticipant:(PMParticipant *)participant;

@end
