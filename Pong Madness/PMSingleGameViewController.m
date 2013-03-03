//
//  PMSingleGameViewController.m
//  Pong Madness
//
//  Created by Ludovic Landry on 3/2/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMSingleGameViewController.h"
#import "PMPlayer.h"

@interface PMSingleGameViewController ()

@end

@implementation PMSingleGameViewController

@synthesize playerList;

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPlayers:(NSArray *)aPlayerList {
    self = [self init];
    if (self) {
        self.playerList = aPlayerList;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PMPlayer *firstPlayer = [self.playerList objectAtIndex:0];
    PMPlayer *secondPlayer = [self.playerList objectAtIndex:1];
    self.title = [NSString stringWithFormat:@"%@ VS %@", firstPlayer.username, secondPlayer.username];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self action:@selector(close:)];
}

- (IBAction)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
