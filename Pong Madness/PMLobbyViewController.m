//
//  PMLobbyViewController.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMLobbyViewController.h"
#import "PMPlayerListViewController.h"
#import "UIFont+PongMadness.h"
#import "PMGame.h"

typedef enum {
    PMGameConfigurationNone = 0,
	PMGameConfigurationQuickGame,
	PMGameConfigurationKnockOut
} PMGameConfiguration;

@interface PMLobbyViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *logoLaunchImageView;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong) IBOutlet UIButton *quickGameButton;
@property (nonatomic, strong) IBOutlet UIButton *knockOutButton;
@property (nonatomic, strong) IBOutlet UIButton *leaderboardButton;
@property (nonatomic, strong) IBOutlet UIButton *thePlayersButton;

@property (nonatomic, strong) IBOutlet UIButton *gameSingleButton;
@property (nonatomic, strong) IBOutlet UIButton *gameDoubleButton;

@property (nonatomic, assign) BOOL hasPlayedInitialAnimation;
@property (nonatomic, assign) PMGameConfiguration gameConfiguration;

- (IBAction)openQuickGame:(id)sender;
- (IBAction)openKnockOut:(id)sender;
- (IBAction)openLeaderboard:(id)sender;
- (IBAction)openThePlayers:(id)sender;

@end

@implementation PMLobbyViewController

@synthesize logoLaunchImageView;
@synthesize quickGameButton;
@synthesize knockOutButton;
@synthesize leaderboardButton;
@synthesize thePlayersButton;
@synthesize gameSingleButton;
@synthesize gameDoubleButton;

@synthesize hasPlayedInitialAnimation;
@synthesize gameConfiguration;

- (id)init {
    self = [super init];
    if (self) {
        self.gameConfiguration = PMGameConfigurationNone;
        self.hasPlayedInitialAnimation = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gameSingleButton.titleLabel.font = [UIFont brothersBoldFontOfSize:50.f];
    self.gameDoubleButton.titleLabel.font = [UIFont brothersBoldFontOfSize:50.f];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!hasPlayedInitialAnimation) {
        self.hasPlayedInitialAnimation = YES;
        
        self.logoLaunchImageView.alpha = 1.f;
        self.quickGameButton.center = CGPointMake(-135.f, 374.f);
        self.knockOutButton.center = CGPointMake(-135.f, 374.f);
        self.leaderboardButton.center = CGPointMake(-135.f, 374.f);
        self.thePlayersButton.center = CGPointMake(-135.f, 374.f);
        
        [UIView animateWithDuration:0.4 animations:^{
            self.logoLaunchImageView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.8 animations:^{
                self.quickGameButton.center = CGPointMake(135.f, 374.f);
                self.knockOutButton.center = CGPointMake(386.f, 374.f);
                self.leaderboardButton.center = CGPointMake(638.f, 374.f);
                self.thePlayersButton.center = CGPointMake(889.f, 374.f);
            }];
        }];
    }
}

- (IBAction)openQuickGame:(id)sender {
    self.gameConfiguration = PMGameConfigurationQuickGame;
    
    [UIView transitionWithView:self.quickGameButton
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
        UIImage *quickGameActiveImage = [UIImage imageNamed:@"paddle-quickgame-active"];
        [self.quickGameButton setBackgroundImage:quickGameActiveImage forState:UIControlStateNormal];
    } completion:nil];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.gameSingleButton.alpha = 1.f;
        self.gameDoubleButton.alpha = 1.f;
        
        self.knockOutButton.transform = CGAffineTransformConcat(
            CGAffineTransformMakeTranslation(380, -180),
            CGAffineTransformMakeRotation(M_PI_4/2)
        );
        
        self.leaderboardButton.transform = CGAffineTransformConcat(
            CGAffineTransformMakeTranslation(180, 20),
            CGAffineTransformMakeRotation(-M_PI_4/6)
        );
        
        self.thePlayersButton.transform = CGAffineTransformConcat(
            CGAffineTransformMakeTranslation(-60, 20),
            CGAffineTransformMakeRotation(M_PI_4/4)
        );
    } completion:^(BOOL finished) {
        [self.view insertSubview:self.gameSingleButton aboveSubview:self.cancelButton];
        [self.view insertSubview:self.gameDoubleButton aboveSubview:self.cancelButton];
        
        self.gameSingleButton.alpha = 1.f;
        self.cancelButton.enabled = YES;
    }];
}

- (IBAction)openKnockOut:(id)sender {
    self.gameConfiguration = PMGameConfigurationKnockOut;
    
    //TODO: later
}

- (IBAction)openLeaderboard:(id)sender {
    
    //TODO: later
}

- (IBAction)openThePlayers:(id)sender {
    PMPlayerListViewController *playerListViewController = [[PMPlayerListViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:playerListViewController];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (IBAction)cancel:(id)sender {
    switch (self.gameConfiguration) {
        case PMGameConfigurationNone: {
            break;
        }
        case PMGameConfigurationQuickGame: {
            self.gameConfiguration = PMGameConfigurationNone;
            [self.view insertSubview:self.gameSingleButton belowSubview:self.thePlayersButton];
            [self.view insertSubview:self.gameDoubleButton belowSubview:self.thePlayersButton];
            
            [UIView transitionWithView:self.quickGameButton
                              duration:0.4
                               options:UIViewAnimationOptionTransitionFlipFromRight
                            animations:^{
                UIImage *quickGameActiveImage = [UIImage imageNamed:@"paddle-quickgame"];
                [self.quickGameButton setBackgroundImage:quickGameActiveImage forState:UIControlStateNormal];
            } completion:nil];
            
            [UIView animateWithDuration:0.4 animations:^{
                self.gameSingleButton.alpha = 0.f;
                self.gameDoubleButton.alpha = 0.f;
                
                self.knockOutButton.transform = CGAffineTransformIdentity;
                self.leaderboardButton.transform = CGAffineTransformIdentity;
                self.thePlayersButton.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                self.cancelButton.enabled = NO;
            }];
            
            break;
        }
        case PMGameConfigurationKnockOut: {
            self.gameConfiguration = PMGameConfigurationNone;
            
            //TODO: later
            
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
