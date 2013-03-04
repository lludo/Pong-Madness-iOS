//
//  PMSingleGameViewController.m
//  Pong Madness
//
//  Created by Ludovic Landry on 3/2/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMSingleGameViewController.h"
#import "UIFont+PongMadness.h"
#import "UIButton+Stretch.h"
#import "PMDocumentManager.h"
#import "PMPlayer.h"
#import "PMGame.h"

@interface PMSingleGameViewController ()

@property (nonatomic, strong) IBOutlet UIView *firstPlayerContainerView;
@property (nonatomic, strong) IBOutlet UIImageView *avatarFirstPlayerImageView;
@property (nonatomic, strong) IBOutlet UILabel *usernameFirstPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *rankFirstPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *winCountFirstPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *loseCountFirstPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *playedCountFirstPlayerLabel;
@property (nonatomic, strong) IBOutlet UIImageView *handednessFirstPlayerImageView;

@property (nonatomic, strong) IBOutlet UIView *secondPlayerContainerView;
@property (nonatomic, strong) IBOutlet UIImageView *avatarSecondPlayerImageView;
@property (nonatomic, strong) IBOutlet UILabel *usernameSecondPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *rankSecondPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *winCountSecondPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *loseCountSecondPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *playedCountSecondPlayerLabel;
@property (nonatomic, strong) IBOutlet UIImageView *handednessSecondPlayerImageView;

@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *legendLabels;
@property (nonatomic, strong) IBOutlet UIView *tableBackgroundView;
@property (nonatomic, strong) IBOutlet UIButton *pointsToWinSwitch;
@property (nonatomic, strong) IBOutlet UILabel *winnerLabel;
@property (nonatomic, strong) IBOutlet UIButton *startButton;
@property (nonatomic, strong) IBOutlet UIButton *finishButton;

@property (nonatomic, strong) IBOutlet UIButton *leftMinusButton;
@property (nonatomic, strong) IBOutlet UIButton *leftPlusButton;
@property (nonatomic, strong) IBOutlet UIView *leftScoreBackground;
@property (nonatomic, strong) IBOutlet UILabel *leftScoreLabel;

@property (nonatomic, strong) IBOutlet UIButton *rightMinusButton;
@property (nonatomic, strong) IBOutlet UIButton *rightPlusButton;
@property (nonatomic, strong) IBOutlet UIView *rightScoreBackground;
@property (nonatomic, strong) IBOutlet UILabel *rightScoreLabel;

@property (nonatomic, strong) IBOutlet UIView *timerBackground;
@property (nonatomic, strong) IBOutlet UILabel *timerLabel;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) PMGame *game;

- (void)updateView;
- (IBAction)tooglePointsToWinSwitch:(id)sender;
- (IBAction)startGame:(id)sender;
- (IBAction)finishGame:(id)sender;

- (IBAction)decreaseLeftPoints:(id)sender;
- (IBAction)increaseLeftPoints:(id)sender;
- (IBAction)decreaseRightPoints:(id)sender;
- (IBAction)increaseRightPoints:(id)sender;

@end

@implementation PMSingleGameViewController

@synthesize firstPlayerContainerView;
@synthesize avatarFirstPlayerImageView;
@synthesize usernameFirstPlayerLabel;
@synthesize rankFirstPlayerLabel;
@synthesize winCountFirstPlayerLabel;
@synthesize loseCountFirstPlayerLabel;
@synthesize playedCountFirstPlayerLabel;
@synthesize handednessFirstPlayerImageView;

@synthesize secondPlayerContainerView;
@synthesize avatarSecondPlayerImageView;
@synthesize usernameSecondPlayerLabel;
@synthesize rankSecondPlayerLabel;
@synthesize winCountSecondPlayerLabel;
@synthesize loseCountSecondPlayerLabel;
@synthesize playedCountSecondPlayerLabel;
@synthesize handednessSecondPlayerImageView;

@synthesize legendLabels;
@synthesize tableBackgroundView;
@synthesize pointsToWinSwitch;
@synthesize winnerLabel;
@synthesize startButton;
@synthesize finishButton;
@synthesize participantList;

@synthesize leftMinusButton;
@synthesize leftPlusButton;
@synthesize leftScoreBackground;
@synthesize leftScoreLabel;

@synthesize rightMinusButton;
@synthesize rightPlusButton;
@synthesize rightScoreBackground;
@synthesize rightScoreLabel;

@synthesize timerBackground;
@synthesize timerLabel;

@synthesize timer;
@synthesize game;

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
    
    PMPlayer *firstPlayer = [self.participantList objectAtIndex:0];
    PMPlayer *secondPlayer = [self.participantList objectAtIndex:1];
    self.title = [NSString stringWithFormat:@"%@ VS %@", firstPlayer.username, secondPlayer.username];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self action:@selector(close:)];
    
    // Configure players
    
    self.firstPlayerContainerView.transform = CGAffineTransformMakeTranslation(0.f, -466.f);
    self.avatarFirstPlayerImageView.layer.cornerRadius = 3.f;
    self.usernameFirstPlayerLabel.font = [UIFont brothersBoldFontOfSize:38.f];
    self.rankFirstPlayerLabel.font = [UIFont brothersBoldFontOfSize:22.f];
    self.winCountFirstPlayerLabel.font = [UIFont brothersBoldFontOfSize:22.f];
    self.loseCountFirstPlayerLabel.font = [UIFont brothersBoldFontOfSize:22.f];
    self.playedCountFirstPlayerLabel.font = [UIFont brothersBoldFontOfSize:22.f];
    
    self.secondPlayerContainerView.transform = CGAffineTransformMakeTranslation(0.f, -466.f);
    self.avatarSecondPlayerImageView.layer.cornerRadius = 3.f;
    self.usernameSecondPlayerLabel.font = [UIFont brothersBoldFontOfSize:38.f];
    self.rankSecondPlayerLabel.font = [UIFont brothersBoldFontOfSize:22.f];
    self.winCountSecondPlayerLabel.font = [UIFont brothersBoldFontOfSize:22.f];
    self.loseCountSecondPlayerLabel.font = [UIFont brothersBoldFontOfSize:22.f];
    self.playedCountSecondPlayerLabel.font = [UIFont brothersBoldFontOfSize:22.f];
    
    [self.legendLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.font = [UIFont brothersBoldFontOfSize:11.f];
    }];
    
    [self.startButton stretchBackgroundImage];
    self.startButton.titleLabel.font = [UIFont brothersBoldFontOfSize:38.f];
    
    [self.finishButton stretchBackgroundImage];
    self.finishButton.titleLabel.font = [UIFont brothersBoldFontOfSize:38.f];
    self.finishButton.alpha = 0.f;
    
    self.leftScoreLabel.font = [UIFont brothersBoldFontOfSize:93.f];
    self.rightScoreLabel.font = [UIFont brothersBoldFontOfSize:93.f];
    self.timerLabel.font = [UIFont brothersBoldFontOfSize:36.f];
    self.winnerLabel.font = [UIFont brothersBoldFontOfSize:17.f];
    self.winnerLabel.alpha = 0.f;
    
    
    // Hides games controls for now
    
    self.leftMinusButton.transform = CGAffineTransformMakeTranslation(-44.f, 0.f);
    self.leftPlusButton.transform = CGAffineTransformMakeTranslation(-87.f, 0.f);
    self.leftScoreBackground.alpha = 0.f;
    self.leftScoreLabel.alpha = 0.f;
    self.timerBackground.alpha = 0.f;
    self.timerLabel.alpha = 0.f;
    self.rightScoreBackground.alpha = 0.f;
    self.rightScoreLabel.alpha = 0.f;
    self.rightMinusButton.transform = CGAffineTransformMakeTranslation(44.f, 0.f);
    self.rightPlusButton.transform = CGAffineTransformMakeTranslation(87.f, 0.f);
    
    // Setup data in the views
    
    [self updateView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.4 delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.firstPlayerContainerView.transform = CGAffineTransformMakeTranslation(0.f, 12.f);
        self.secondPlayerContainerView.transform = CGAffineTransformMakeTranslation(0.f, 12.f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.firstPlayerContainerView.transform = CGAffineTransformIdentity;
            self.secondPlayerContainerView.transform = CGAffineTransformIdentity;
        } completion:NULL];
    }];
}

- (void)updateView {
    PMPlayer *firstPlayer = [self.participantList objectAtIndex:0];
    PMPlayer *secondPlayer = [self.participantList objectAtIndex:1];
    
    self.usernameFirstPlayerLabel.text = firstPlayer.username;
    self.usernameSecondPlayerLabel.text = secondPlayer.username;
    
    if (game) {
        self.leftScoreLabel.text = [NSString stringWithFormat:@"%@", [self.game scoreForParticipant:firstPlayer]];
        self.rightScoreLabel.text = [NSString stringWithFormat:@"%@", [self.game scoreForParticipant:secondPlayer]];
        
        NSInteger minScoreToWin = (self.pointsToWinSwitch.selected) ? 21 : 11;
        NSInteger scoresGap = 2;
        PMParticipant *participantWinner = [self.game participantWinnerWithMinimumScore:minScoreToWin andScoresGap:scoresGap];
        if (participantWinner) {
            self.timerBackground.alpha = 0.f;
            self.timerLabel.alpha = 0.f;
            self.finishButton.alpha = 1.f;
        } else {
            self.timerBackground.alpha = 1.f;
            self.timerLabel.alpha = 1.f;
            self.finishButton.alpha = 0.f;
        }
    }
}

- (IBAction)close:(id)sender {
    if (timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)popNavigation:(id)sender {
    if (timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tooglePointsToWinSwitch:(id)sender {
    self.pointsToWinSwitch.selected = !self.pointsToWinSwitch.selected;
    [self updateView];
}

- (IBAction)startGame:(id)sender {
    if (game) {
        return;
    }
    
    self.game = [PMGame gameWithParticipants:self.participantList];
    self.game.startDate = [NSDate date];
    self.game.type = @"single";
    [[PMDocumentManager sharedDocument] save];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self action:@selector(close:)];
    
    [UIView animateWithDuration:1.f animations:^{
        
        self.startButton.alpha = 0.f;
        
        // Show games controls
        self.leftMinusButton.transform = CGAffineTransformIdentity;
        self.leftPlusButton.transform = CGAffineTransformIdentity;
        self.leftScoreBackground.alpha = 1.f;
        self.leftScoreLabel.alpha = 1.f;
        self.timerBackground.alpha = 1.f;
        self.timerLabel.alpha = 1.f;
        self.rightScoreBackground.alpha = 1.f;
        self.rightScoreLabel.alpha = 1.f;
        self.rightMinusButton.transform = CGAffineTransformIdentity;
        self.rightPlusButton.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                      target:self selector:@selector(timerTick:)
                                                    userInfo:nil repeats:YES];
        [self.timer fire];
    }];
}

- (IBAction)finishGame:(id)sender {
    NSInteger minScoreToWin = (self.pointsToWinSwitch.selected) ? 21 : 11;
    NSInteger scoresGap = 2;
    PMParticipant *participantWinner = [self.game participantWinnerWithMinimumScore:minScoreToWin andScoresGap:scoresGap];
    
    if (participantWinner) {
        [self.timer invalidate];
        self.timer = nil;
        self.game.timePlayed = @(-[self.game.startDate timeIntervalSinceNow]);
        [[PMDocumentManager sharedDocument] save];
        
        NSInteger timePlayed = [self.game.timePlayed integerValue];
        NSInteger minutes = timePlayed / 60;
        NSInteger seconds = timePlayed % 60;
        
        PMPlayer *firstPlayer = [self.participantList objectAtIndex:0];
        PMPlayer *secondPlayer = [self.participantList objectAtIndex:1];
        if (participantWinner == firstPlayer) {
            self.winnerLabel.text = [NSString stringWithFormat:@"%@ defeated %@ %@-%@ in %i minutes and %i seconds.", firstPlayer.username, secondPlayer.username, [game scoreForParticipant:firstPlayer], [game scoreForParticipant:secondPlayer], minutes, seconds];
        } else {
            self.winnerLabel.text = [NSString stringWithFormat:@"%@ defeated %@ %@-%@ in %i minutes and %i seconds.", secondPlayer.username, firstPlayer.username, [game scoreForParticipant:secondPlayer], [game scoreForParticipant:firstPlayer], minutes, seconds];
        }
                                     
        [UIView animateWithDuration:0.8 animations:^{
            
            // Discard the loser
            if (participantWinner == firstPlayer) {
                self.secondPlayerContainerView.transform = CGAffineTransformConcat(
                    CGAffineTransformMakeTranslation(0.f, 1200.f),
                    CGAffineTransformMakeScale(0.5, 0.5)
                );
            } else {
                self.firstPlayerContainerView.transform = CGAffineTransformConcat(
                    CGAffineTransformMakeTranslation(0.f, 1200.f),
                    CGAffineTransformMakeScale(0.5, 0.5)
                );
            }
            
            // Hides games controls
            
            self.leftMinusButton.transform = CGAffineTransformMakeTranslation(-44.f, 0.f);
            self.leftPlusButton.transform = CGAffineTransformMakeTranslation(-87.f, 0.f);
            self.leftScoreBackground.alpha = 0.f;
            self.leftScoreLabel.alpha = 0.f;
            self.finishButton.alpha = 0.f;
            self.pointsToWinSwitch.alpha = 0.f;
            self.rightScoreBackground.alpha = 0.f;
            self.rightScoreLabel.alpha = 0.f;
            self.rightMinusButton.transform = CGAffineTransformMakeTranslation(44.f, 0.f);
            self.rightPlusButton.transform = CGAffineTransformMakeTranslation(87.f, 0.f);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.6 animations:^{
                
                // Hilight the winner
                if (participantWinner == firstPlayer) {
                    self.firstPlayerContainerView.transform = CGAffineTransformMakeTranslation(257, 94.f);
                } else {
                    self.secondPlayerContainerView.transform = CGAffineTransformMakeTranslation(-257.f, 94.f);
                }
                
                self.winnerLabel.alpha = 1.f;
                
                self.tableBackgroundView.transform = CGAffineTransformMakeTranslation(0.f, -552.f);
            } completion:^(BOOL finished) {
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil)
                                                                                         style:UIBarButtonItemStyleBordered
                                                                                        target:self action:@selector(close:)];
                
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"New Game", nil)
                                                                                          style:UIBarButtonItemStyleBordered
                                                                                         target:self action:@selector(popNavigation:)];
            }];
        }];
    }
}

- (IBAction)decreaseLeftPoints:(id)sender {
    PMPlayer *firstPlayer = [self.participantList objectAtIndex:0];
    [self.game decreasePointsForParticipant:firstPlayer];
    [self updateView];
}

- (IBAction)increaseLeftPoints:(id)sender {
    PMPlayer *firstPlayer = [self.participantList objectAtIndex:0];
    [self.game increasePointsForParticipant:firstPlayer];
    [self updateView];
}

- (IBAction)decreaseRightPoints:(id)sender {
    PMPlayer *secondPlayer = [self.participantList objectAtIndex:1];
    [self.game decreasePointsForParticipant:secondPlayer];
    [self updateView];
}

- (IBAction)increaseRightPoints:(id)sender {
    PMPlayer *secondPlayer = [self.participantList objectAtIndex:1];
    [self.game increasePointsForParticipant:secondPlayer];
    [self updateView];
}

- (void)timerTick:(id)sender {
    NSTimeInterval interval = -[self.game.startDate timeIntervalSinceNow];
    NSInteger minutes = (int)interval / 60;
    NSInteger seconds = (int)interval % 60;
    self.timerLabel.text = [NSString stringWithFormat:@"%02i:%02i", minutes, seconds];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
