//
//  PMDoubleGameViewController.m
//  Pong Madness
//
//  Created by Ludovic Landry on 3/2/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMDoubleGameViewController.h"

@interface PMDoubleGameViewController ()

@end

@implementation PMDoubleGameViewController

@synthesize participantList;

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithParticipants:(NSArray *)aParticipantList {
    self = [self init];
    if (self) {
        self.participantList = aParticipantList;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //TODO: later
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
