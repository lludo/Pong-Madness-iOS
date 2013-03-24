//
//  PMPlayerCardView.h
//  Pong Madness
//
//  Created by Ludovic Landry on 3/4/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PMPlayer.h"

@interface PMPlayerView : UIView

@property (nonatomic, strong) PMPlayer *player;

- (void)refreshUI;

@end
