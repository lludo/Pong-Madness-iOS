//
//  PMPlayerListViewControllerDelegate.h
//  Pong Madness
//
//  Created by Ludovic Landry on 3/2/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PMPlayerListViewControllerDelegate <NSObject>

- (void)didSelectPlayers:(NSArray *)playerList;

@end
