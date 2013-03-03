//
//  PMDoubleGameViewController.h
//  Pong Madness
//
//  Created by Ludovic Landry on 3/2/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMDoubleGameViewController : UIViewController

- (id)initWithPlayers:(NSArray *)playerList;

@property (nonatomic, strong) NSArray *playerList;

@end
