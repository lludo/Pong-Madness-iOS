//
//  PMTeam.h
//  Pong Madness
//
//  Created by Ludovic Landry on 3/31/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PMParticipant.h"

@class PMPlayer;

@interface PMTeam : PMParticipant

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSSet *playerSet;

+ (PMTeam *)teamWithName:(NSString *)name;

@end

@interface PMTeam (CoreDataGeneratedAccessors)

- (void)addPlayerSetObject:(PMPlayer *)value;
- (void)removePlayerSetObject:(PMPlayer *)value;
- (void)addPlayerSet:(NSSet *)values;
- (void)removePlayerSet:(NSSet *)values;

@end
