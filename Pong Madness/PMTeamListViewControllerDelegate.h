//
//  PMTeamListViewControllerDelegate.h
//  Pong Madness
//
//  Created by Ludovic Landry on 4/1/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMTeamListViewController, PMTeam;

@protocol PMTeamListViewControllerDelegate <NSObject>

- (void)teamListViewController:(PMTeamListViewController *)teamListViewController didSelectTeam:(PMTeam *)team;

@end
