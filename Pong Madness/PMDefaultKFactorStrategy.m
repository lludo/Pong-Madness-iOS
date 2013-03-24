//
//  PMDefaultKFactorStrategy.m
//  Pong Madness
//
//  Created by Ludovic Landry on 03/02/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMDefaultKFactorStrategy.h"

@implementation PMDefaultKFactorStrategy

- (NSUInteger)initialRating {
    return 1200u;
}

- (NSUInteger)kFactorForRating:(NSUInteger)r andNumberOfGames:(NSUInteger)g {
    if (g < 4)
        return 320u;
    
    if (r < 1600)
        return 280u;
    
    return 160u;
}

@end
