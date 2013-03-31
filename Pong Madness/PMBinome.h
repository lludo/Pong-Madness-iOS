//
//  PMBinome.h
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PMParticipant.h"

@class PMPlayer;

@interface PMBinome : PMParticipant

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSSet *playerSet;

@end

@interface PMBinome (CoreDataGeneratedAccessors)

- (void)addPlayerSetObject:(PMPlayer *)value;
- (void)removePlayerSetObject:(PMPlayer *)value;
- (void)addPlayerSet:(NSSet *)values;
- (void)removePlayerSet:(NSSet *)values;

@end
