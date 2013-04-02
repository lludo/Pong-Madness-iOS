//
//  PMTeamListViewController.h
//  Pong Madness
//
//  Created by Ludovic Landry on 4/1/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PMTeamListViewControllerDelegate.h"

@interface PMTeamListViewController : UIViewController

@property (nonatomic, weak) id <PMTeamListViewControllerDelegate> delegate;

@end
