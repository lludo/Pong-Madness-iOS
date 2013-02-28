//
//  PMLobbyViewController.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMLobbyViewController.h"
#import "PMPlayerListViewController.h"

@interface PMLobbyViewController ()

- (IBAction)openPlayersAndTeams:(id)sender;

@end

@implementation PMLobbyViewController

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)openPlayersAndTeams:(id)sender {
    PMPlayerListViewController *playerListViewController = [[PMPlayerListViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:playerListViewController];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
