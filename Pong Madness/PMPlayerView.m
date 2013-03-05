//
//  PMPlayerCardView.m
//  Pong Madness
//
//  Created by Ludovic Landry on 3/4/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMPlayerView.h"
#import "PMLeaderboard.h"
#import "PMLeaderboardPlayer.h"
#import "UIFont+PongMadness.h"

@interface PMPlayerView ()

@property (nonatomic, strong) IBOutlet UIImageView *avatarPlayerImageView;
@property (nonatomic, strong) IBOutlet UILabel *usernamePlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *rankPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *winCountPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *loseCountPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *playedCountPlayerLabel;
@property (nonatomic, strong) IBOutlet UILabel *ratioPlayerLabel;
@property (nonatomic, strong) IBOutlet UIImageView *handednessPlayerImageView;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *legendLabels;

@property (nonatomic, strong) IBOutlet UIView *mainView;
@property (nonatomic, strong) NSArray *nibObjects;

- (void)loadView;

@end

@implementation PMPlayerView

@synthesize player;

@synthesize avatarPlayerImageView;
@synthesize usernamePlayerLabel;
@synthesize rankPlayerLabel;
@synthesize winCountPlayerLabel;
@synthesize loseCountPlayerLabel;
@synthesize playedCountPlayerLabel;
@synthesize handednessPlayerImageView;
@synthesize legendLabels;

@synthesize mainView;
@synthesize nibObjects;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self loadView];
}

- (void)loadView {
    NSString *className = NSStringFromClass([self class]);
    self.nibObjects = [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil];
	self.mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.mainView.frame = self.bounds;
    [self addSubview:mainView];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.shouldRasterize = YES;
    
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
}

- (void)setPlayer:(PMPlayer *)aPlayer {
    player = aPlayer;
    [self refreshUI];
}

- (void)refreshUI {
    if (self.player.photo) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:self.player.photo];
        self.avatarPlayerImageView.image = [UIImage imageWithData:data];
    }
    
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
    
    if ([self.player.handedness isEqualToString:@"L"]) {
        self.handednessPlayerImageView.image = [UIImage imageNamed:@"icon-lefty"];
    } else if ([self.player.handedness isEqualToString:@"R"]) {
        self.handednessPlayerImageView.image = [UIImage imageNamed:@"icon-righty"];
    }
}

@end
