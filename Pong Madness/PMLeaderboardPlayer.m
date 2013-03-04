//
//  PMLeaderboardPlayer.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMLeaderboardPlayer.h"
#import "PMLeaderboard.h"
#import "PMPlayer.h"
#import "PMDocumentManager.h"

@implementation PMLeaderboardPlayer

@dynamic player;
@dynamic gamesPlayedCount;
@dynamic gamesWonCount;
@dynamic victoryRatio;
@dynamic leaderboard;

+ (PMLeaderboardPlayer *)leaderboardPlayerForPlayer:(PMPlayer *)player inLeaderboard:(PMLeaderboard *)leaderboard {
    
    NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"LeaderboardPlayer" inManagedObjectContext:managedObjectContext];
    PMLeaderboardPlayer *leaderboardPlayer = [[PMLeaderboardPlayer alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:managedObjectContext];
    
    leaderboardPlayer.player = player;
    leaderboardPlayer.leaderboard = leaderboard;
    return leaderboardPlayer;
}

- (void)recordVictory {
    self.gamesPlayedCount = @([self.gamesPlayedCount intValue] + 1);
    self.gamesWonCount = @([self.gamesWonCount intValue] + 1);
    self.victoryRatio = @([self.gamesWonCount floatValue] / [self.gamesPlayedCount floatValue]);
}

- (void)recordDefeat {
    self.gamesPlayedCount = @([self.gamesPlayedCount intValue] + 1);
    self.victoryRatio = @([self.gamesWonCount floatValue] / [self.gamesPlayedCount floatValue]);
}

@end
