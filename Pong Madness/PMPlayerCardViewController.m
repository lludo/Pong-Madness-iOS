//
//  PMPlayerCardViewController.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMPlayerCardViewController.h"
#import "PMPlayerEditViewController.h"
#import "PMPlayerView.h"
#import "PMLeaderboardPlayer.h"
#import "PMLeaderboard.h"
#import "UIFont+PongMadness.h"

@interface PMPlayerCardViewController ()

- (IBAction)close:(id)sender;

@property (nonatomic, strong) IBOutlet PMPlayerView *playerCardView;
@property (nonatomic, strong) IBOutlet UIButton *messageButton;

@end

@implementation PMPlayerCardViewController

@synthesize player;
@synthesize playerCardView;
@synthesize messageButton;

- (id)init {
    self = [super init];
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
    
    self.title = self.player.username;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil)
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self action:@selector(close:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil)
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self action:@selector(edit:)];
    
    self.playerCardView.player = self.player;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.playerCardView refreshUI];
    self.messageButton.hidden = ([self.player.email length] < 6);
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)edit:(id)sender {
    PMPlayerEditViewController *playerEditViewController = [[PMPlayerEditViewController alloc] initWithPlayer:self.player];
    [self.navigationController pushViewController:playerEditViewController animated:YES];
}

- (IBAction)messagePlayer:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
