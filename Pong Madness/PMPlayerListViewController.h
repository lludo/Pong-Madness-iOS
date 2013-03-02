//
//  PMPlayerListViewController.h
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

typedef enum {
    PMPlayerListModeManage = 0,
	PMPlayerListModeSelectForSingle,
	PMPlayerListModeSelectForDouble
} PMPlayerListMode;

@interface PMPlayerListViewController : UIViewController

- (id)initWithMode:(PMPlayerListMode)mode;

@end
