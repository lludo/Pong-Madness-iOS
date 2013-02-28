//
//  PMPlayerViewController.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMPlayerViewController.h"

@interface PMPlayerViewController ()

- (IBAction)close:(id)sender;

@end

@implementation PMPlayerViewController

@synthesize player;

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPlayer:(PMPlayer *)aPlayer {
    self = [self init];
    if (self) {
        self.player = aPlayer;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = player.username;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil)
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self action:@selector(close:)];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
