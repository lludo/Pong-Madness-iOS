//
//  PMGame.h
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PMGameParticipant, PMTournament, PMParticipant;

typedef enum {
	PMGameTypeSingle = 0,
	PMGameTypeDouble
} PMGameType;

@interface PMGame : NSManagedObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *timePlayed;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSOrderedSet *gameParticipantOrderedSet;
@property (nonatomic, strong) NSSet *tournamentSet;

+ (PMGame *)gameWithParticipants:(NSArray *)participants;

- (BOOL)isGameOver;
- (NSNumber *)scoreForParticipant:(PMParticipant *)participant;
- (void)increasePointsForParticipant:(PMParticipant *)participant;
- (void)decreasePointsForParticipant:(PMParticipant *)participant;

- (PMParticipant *)participantWinnerWithMinimumScore:(NSInteger)score andScoresGap:(NSInteger)gap;

@end

@interface PMGame (CoreDataGeneratedAccessors)

- (void)addGameParticipantOrderedSetObject:(PMGameParticipant *)value;
- (void)removeGameParticipantOrderedSetObject:(PMGameParticipant *)value;
- (void)addGameParticipantOrederdSet:(NSOrderedSet *)values;
- (void)removeGameParticipantOrderedSet:(NSOrderedSet *)values;

- (void)addTournamentSetObject:(PMTournament *)value;
- (void)removeTournamentSetObject:(PMTournament *)value;
- (void)addTournamentSet:(NSSet *)values;
- (void)removeTournamentSet:(NSSet *)values;

@end
