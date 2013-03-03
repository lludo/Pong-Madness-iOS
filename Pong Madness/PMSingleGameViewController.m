//
//  PMSingleGameViewController.m
//  Pong Madness
//
//  Created by Ludovic Landry on 3/2/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMSingleGameViewController.h"
#import "UIFont+PongMadness.h"
#import "PMPlayer.h"

@interface PMSingleGameViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *avatarFirstPlayerImageView;
@property (nonatomic, strong) IBOutlet UILabel *usernameFirstPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *rankFirstPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *winCountFirstPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *loseCountFirstPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *playedCountFirstPlayerLabel;
@property (nonatomic, strong) IBOutlet UIImageView *handednessFirstPlayerImageView;

@property (nonatomic, strong) IBOutlet UIImageView *avatarSecondPlayerImageView;
@property (nonatomic, strong) IBOutlet UILabel *usernameSecondPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *rankSecondPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *winCountSecondPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *loseCountSecondPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *playedCountSecondPlayerLabel;
@property (nonatomic, strong) IBOutlet UIImageView *handednessSecondPlayerImageView;

@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *legendLabels;

- (void)setupView;

@end

@implementation PMSingleGameViewController

@synthesize avatarFirstPlayerImageView;
@synthesize usernameFirstPlayerLabel;
@synthesize rankFirstPlayerLabel;
@synthesize winCountFirstPlayerLabel;
@synthesize loseCountFirstPlayerLabel;
@synthesize playedCountFirstPlayerLabel;
@synthesize handednessFirstPlayerImageView;

@synthesize avatarSecondPlayerImageView;
@synthesize usernameSecondPlayerLabel;
@synthesize rankSecondPlayerLabel;
@synthesize winCountSecondPlayerLabel;
@synthesize loseCountSecondPlayerLabel;
@synthesize playedCountSecondPlayerLabel;
@synthesize handednessSecondPlayerImageView;

@synthesize legendLabels;
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
    
    self.avatarFirstPlayerImageView.layer.cornerRadius = 3.f;
    self.usernameFirstPlayerLabel.font = [UIFont brothersBoldFontOfSize:38.f];
    self.rankFirstPlayerLabel.font = [UIFont brothersBoldFontOfSize:22.f];
    self.winCountFirstPlayerLabel.font = [UIFont brothersBoldFontOfSize:22.f];
    self.loseCountFirstPlayerLabel.font = [UIFont brothersBoldFontOfSize:22.f];
    self.playedCountFirstPlayerLabel.font = [UIFont brothersBoldFontOfSize:22.f];
    
    self.avatarSecondPlayerImageView.layer.cornerRadius = 3.f;
    self.usernameSecondPlayerLabel.font = [UIFont brothersBoldFontOfSize:38.f];
    self.rankSecondPlayerLabel.font = [UIFont brothersBoldFontOfSize:22.f];
    self.winCountSecondPlayerLabel.font = [UIFont brothersBoldFontOfSize:22.f];
    self.loseCountSecondPlayerLabel.font = [UIFont brothersBoldFontOfSize:22.f];
    self.playedCountSecondPlayerLabel.font = [UIFont brothersBoldFontOfSize:22.f];
    
    [self.legendLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.font = [UIFont brothersBoldFontOfSize:11.f];
    }];
    
    [self setupView];
}

- (IBAction)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupView {
    PMPlayer *firstPlayer = [self.playerList objectAtIndex:0];
    PMPlayer *secondPlayer = [self.playerList objectAtIndex:1];
    
    self.usernameFirstPlayerLabel.text = firstPlayer.username;
    self.usernameSecondPlayerLabel.text = secondPlayer.username;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
