//
//  PMLobbyViewController.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMLobbyViewController.h"
#import "PMPlayerListViewController.h"
#import "PMSingleGameViewController.h"
#import "PMDoubleGameViewController.h"
#import "PMLeaderboardViewController.h"
#import "PMSettingsViewController.h"
#import "UIFont+PongMadness.h"

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

//TODO: (remove when we will have knockout implemented)
@property (nonatomic, assign) IBOutlet UIView *soonView;

- (IBAction)openQuickGame:(id)sender;
- (IBAction)openKnockOut:(id)sender;
- (IBAction)openLeaderboard:(id)sender;
- (IBAction)openThePlayers:(id)sender;

- (IBAction)playSingleGame:(id)sender;
- (IBAction)playDoubleGame:(id)sender;

- (IBAction)settings:(id)sender;
- (IBAction)cancel:(id)sender;

@end

@implementation PMLobbyViewController

@synthesize logoLaunchImageView;
@synthesize cancelButton;
@synthesize quickGameButton;
@synthesize knockOutButton;
@synthesize leaderboardButton;
@synthesize thePlayersButton;
@synthesize gameSingleButton;
@synthesize gameDoubleButton;

@synthesize hasPlayedInitialAnimation;
@synthesize gameConfiguration;

//TODO: (remove when we will have knockout implemented)
@synthesize soonView;

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
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Menu", nil)
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:nil action:nil];
    
    self.gameSingleButton.titleLabel.font = [UIFont brothersBoldFontOfSize:50.f];
    self.gameDoubleButton.titleLabel.font = [UIFont brothersBoldFontOfSize:50.f];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.title = @"PONG MADNESS";
    
    if (hasPlayedInitialAnimation) {
        [self cancel:nil];
    } else {
        self.hasPlayedInitialAnimation = YES;
        
        self.logoLaunchImageView.alpha = 1.f;
        self.quickGameButton.center = CGPointMake(-135.f, 330.f);
        self.knockOutButton.center = CGPointMake(-135.f, 330.f);
        self.leaderboardButton.center = CGPointMake(-135.f, 330.f);
        self.thePlayersButton.center = CGPointMake(-135.f, 330.f);
        
        [UIView animateWithDuration:0.4 animations:^{
            self.logoLaunchImageView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.8 animations:^{
                self.quickGameButton.center = CGPointMake(135.f, 330.f);
                self.knockOutButton.center = CGPointMake(386.f, 330.f);
                self.leaderboardButton.center = CGPointMake(638.f, 330.f);
                self.thePlayersButton.center = CGPointMake(889.f, 330.f);
            }];
        }];
    }
}

- (IBAction)openQuickGame:(id)sender {
    self.gameConfiguration = PMGameConfigurationQuickGame;
    
    self.gameSingleButton.transform = CGAffineTransformIdentity;
    self.gameDoubleButton.transform = CGAffineTransformIdentity;
    
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
        
        self.cancelButton.enabled = YES;
    }];
}

- (IBAction)openKnockOut:(id)sender {
    self.gameConfiguration = PMGameConfigurationKnockOut;
    
    self.gameSingleButton.transform = CGAffineTransformMakeTranslation(252, 0);
    self.gameDoubleButton.transform = CGAffineTransformMakeTranslation(252, 0);
    
    [UIView transitionWithView:self.knockOutButton
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
        UIImage *knockOutActiveImage = [UIImage imageNamed:@"paddle-knockout-active"];
        [self.knockOutButton setBackgroundImage:knockOutActiveImage forState:UIControlStateNormal];
    } completion:nil];
    
    [UIView animateWithDuration:0.4 animations:^{
        //TODO: (uncoment that when we will have knockout implemented)
        //self.gameSingleButton.alpha = 1.f;
        //self.gameDoubleButton.alpha = 1.f;
        self.soonView.alpha = 1.f;
        
        self.quickGameButton.transform = CGAffineTransformConcat(
            CGAffineTransformMakeTranslation(-30, -40),
            CGAffineTransformMakeRotation(-M_PI_4)
        );
        
        self.leaderboardButton.transform = CGAffineTransformConcat(
            CGAffineTransformMakeTranslation(380, 60),
            CGAffineTransformMakeRotation(-M_PI_4/2)
        );
        
        self.thePlayersButton.transform = CGAffineTransformConcat(
            CGAffineTransformMakeTranslation(80, -20),
            CGAffineTransformMakeRotation(M_PI_4/4)
        );
    } completion:^(BOOL finished) {
        [self.view insertSubview:self.gameSingleButton aboveSubview:self.cancelButton];
        [self.view insertSubview:self.gameDoubleButton aboveSubview:self.cancelButton];
        
        self.cancelButton.enabled = YES;
    }];
}

- (IBAction)openLeaderboard:(id)sender {
    PMLeaderboardViewController *leaderboardViewController = [[PMLeaderboardViewController alloc] init];
    [self.navigationController pushViewController:leaderboardViewController animated:YES];
}

- (IBAction)openThePlayers:(id)sender {
    PMPlayerListViewController *playerListViewController = [[PMPlayerListViewController alloc] initWithMode:PMPlayerListModeConsult];
    [self.navigationController pushViewController:playerListViewController animated:YES];
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
            [self.view insertSubview:self.gameSingleButton belowSubview:self.thePlayersButton];
            [self.view insertSubview:self.gameDoubleButton belowSubview:self.thePlayersButton];
            
            [UIView transitionWithView:self.knockOutButton
                              duration:0.4
                               options:UIViewAnimationOptionTransitionFlipFromRight
                            animations:^{
                UIImage *quickGameActiveImage = [UIImage imageNamed:@"paddle-knockout"];
                [self.knockOutButton setBackgroundImage:quickGameActiveImage forState:UIControlStateNormal];
            } completion:nil];
            
            [UIView animateWithDuration:0.4 animations:^{
                self.gameSingleButton.alpha = 0.f;
                self.gameDoubleButton.alpha = 0.f;
                
                //TODO: (remove when we will have knockout implemented)
                self.soonView.alpha = 0.f;
                
                self.quickGameButton.transform = CGAffineTransformIdentity;
                self.leaderboardButton.transform = CGAffineTransformIdentity;
                self.thePlayersButton.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                self.cancelButton.enabled = NO;
            }];
            
            break;
        }
    }
}

- (IBAction)playSingleGame:(id)sender {
    PMPlayerListViewController *playerListViewController = [[PMPlayerListViewController alloc] initWithMode:PMPlayerListModeSelectForSingle];
    [self.navigationController pushViewController:playerListViewController animated:YES];
    playerListViewController.delegate = self;
}

- (IBAction)playDoubleGame:(id)sender {
    PMPlayerListViewController *playerListViewController = [[PMPlayerListViewController alloc] initWithMode:PMPlayerListModeSelectForDouble];
    [self.navigationController pushViewController:playerListViewController animated:YES];
}

- (IBAction)settings:(id)sender {
    PMSettingsViewController *settingsViewController = [[PMSettingsViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark player list view controller delegate

- (void)didSelectParticipants:(NSArray *)participantList {
    switch (self.gameConfiguration) {
        case PMGameConfigurationNone: {
            break;
        }
        case PMGameConfigurationQuickGame: {
            
            // Needs to be sure we have 2 players
            if ([participantList count] != 2) {
                return;
            }
            
            PMSingleGameViewController *singleGameViewController = [[PMSingleGameViewController alloc] initWithParticipants:participantList];
            [self.navigationController pushViewController:singleGameViewController animated:YES];
            
            break;
        }
        case PMGameConfigurationKnockOut: {
            
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
