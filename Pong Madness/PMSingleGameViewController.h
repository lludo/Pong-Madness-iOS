//
//  PMSingleGameViewController.h
//  Pong Madness
//
//  Created by Ludovic Landry on 3/2/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PMSingleGameViewController : UIViewController

- (id)initWithParticipants:(NSArray *)participantList;

// In single games, participants are players
@property (nonatomic, strong) NSArray *participantList;

@end
