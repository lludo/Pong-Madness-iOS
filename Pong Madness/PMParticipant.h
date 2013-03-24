//
//  PMParticipant.h
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PMGameParticipant;

@interface PMParticipant : NSManagedObject

@property (nonatomic, strong) NSSet *gameParticipantSet;

@end

@interface PMParticipant (CoreDataGeneratedAccessors)

- (void)addGameParticipantSetObject:(PMGameParticipant *)value;
- (void)removeGameParticipantSetObject:(PMGameParticipant *)value;
- (void)addGameParticipantSet:(NSSet *)values;
- (void)removeGameParticipantSet:(NSSet *)values;

@end
