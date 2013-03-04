//
//  PMPlayerCardViewController.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMPlayerCardViewController.h"
#import "UIFont+PongMadness.h"
#import "PMLeaderboardPlayer.h"
#import "PMLeaderboard.h"

@interface PMPlayerCardViewController ()

- (IBAction)close:(id)sender;

@property (nonatomic, assign) PMPlayerCardMode mode;

@property (nonatomic, strong) IBOutlet UIView *playerContainerView;
@property (nonatomic, strong) IBOutlet UIImageView *avatarPlayerImageView;
@property (nonatomic, strong) IBOutlet UILabel *usernamePlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *rankPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *winCountPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *loseCountPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *playedCountPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *ratioPlayerLabel;
@property (nonatomic, strong) IBOutlet UIImageView *handednessPlayerImageView;

@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *legendLabels;

- (void)updateView;

@end

@implementation PMPlayerCardViewController

@synthesize player;
@synthesize mode;

@synthesize playerContainerView;
@synthesize avatarPlayerImageView;
@synthesize usernamePlayerLabel;
@synthesize rankPlayerLabel;
@synthesize winCountPlayerLabel;
@synthesize loseCountPlayerLabel;
@synthesize playedCountPlayerLabel;
@synthesize handednessPlayerImageView;

@synthesize legendLabels;

- (id)init {
    self = [super init];
    if (self) {
        self.mode = PMPlayerCardModeConsult;
    }
    return self;
}

- (id)initWithMode:(PMPlayerCardMode)aMode {
    self = [super init];
    if (self) {
        self.mode = aMode;
    }
    return self;
}

- (id)initWithPlayer:(PMPlayer *)aPlayer mode:(PMPlayerCardMode)aMode {
    self = [self initWithMode:aMode];
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
    
    self.playerContainerView.transform = CGAffineTransformMakeTranslation(0.f, -466.f);
    self.avatarPlayerImageView.layer.cornerRadius = 3.f;
    self.usernamePlayerLabel.font = [UIFont brothersBoldFontOfSize:38.f];
    self.rankPlayerLabel.font = [UIFont brothersBoldFontOfSize:22.f];
    self.winCountPlayerLabel.font = [UIFont brothersBoldFontOfSize:22.f];
    self.loseCountPlayerLabel.font = [UIFont brothersBoldFontOfSize:22.f];
    self.playedCountPlayerLabel.font = [UIFont brothersBoldFontOfSize:22.f];
    self.ratioPlayerLabel.font = [UIFont brothersBoldFontOfSize:22.f];
    
    [self.legendLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.font = [UIFont brothersBoldFontOfSize:11.f];
    }];
    
    // Setup data in the views
    
    [self updateView];
}

- (void)updateView {
    PMLeaderboard *globalLeaderboard = [PMLeaderboard globalLeaderboard];
    PMLeaderboardPlayer *leaderboardPlayer = [self.player leaderboardPlayerInLeaderboard:globalLeaderboard];
    
    NSUInteger playedGamesCount = [leaderboardPlayer.gamesPlayedCount unsignedIntegerValue];
    NSUInteger wonGamesCount = [leaderboardPlayer.gamesWonCount unsignedIntegerValue];
    NSNumber *rank = [self.player rankInLeaderboard:globalLeaderboard];
    float ratio = wonGamesCount / (float)playedGamesCount;
    
    NSString *rankString = (rank != nil) ? [rank stringValue] : @"-";
    
    NSString *ratioString;
    if (playedGamesCount == 0) {
        ratioString = @"-";
    } else if (ratio == 1.f) {
        ratioString = @"1";
    } else {
        ratioString = [[NSString stringWithFormat:@"%.2f", ratio] substringFromIndex:1];
    }
    
    self.usernamePlayerLabel.text = self.player.username;
    self.rankPlayerLabel.text = rankString;
    self.playedCountPlayerLabel.text = [NSString stringWithFormat:@"%u", playedGamesCount];
    self.winCountPlayerLabel.text = [NSString stringWithFormat:@"%u", wonGamesCount];
    self.loseCountPlayerLabel.text = [NSString stringWithFormat:@"%u", playedGamesCount - wonGamesCount];
    self.ratioPlayerLabel.text = ratioString;
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
