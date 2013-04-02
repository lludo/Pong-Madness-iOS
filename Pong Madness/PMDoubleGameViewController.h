//
//  PMDoubleGameViewController.h
//  Pong Madness
//
//  Created by Ludovic Landry on 3/2/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMDoubleGameViewController : UIViewController

- (id)initWithParticipants:(NSArray *)participantList;

// In double games, participants are binomes
@property (nonatomic, strong) NSArray *participantList;

@end
