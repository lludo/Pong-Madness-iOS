//
//  PMPlayerCardViewController.h
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMPlayer.h"

@interface PMPlayerCardViewController : UIViewController

@property (nonatomic, strong) PMPlayer *player;

- (id)initWithPlayer:(PMPlayer *)player;

@end
