//
//  PMGame.h
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PMGameParticipant, PMTournament;

@interface PMGame : NSManagedObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *timePlayed;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSSet *gameParticipantSet;
@property (nonatomic, strong) NSSet *tournamentSet;

@end

@interface PMGame (CoreDataGeneratedAccessors)

- (void)addGameParticipantSetObject:(PMGameParticipant *)value;
- (void)removeGameParticipantSetObject:(PMGameParticipant *)value;
- (void)addGameParticipantSet:(NSSet *)values;
- (void)removeGameParticipantSet:(NSSet *)values;

- (void)addTournamentSetObject:(PMTournament *)value;
- (void)removeTournamentSetObject:(PMTournament *)value;
- (void)addTournamentSet:(NSSet *)values;
- (void)removeTournamentSet:(NSSet *)values;

@end
