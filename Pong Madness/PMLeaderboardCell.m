//
//  PMLeaderboardCell.m
//  Pong Madness
//
//  Created by Ludovic Landry on 3/3/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMLeaderboardCell.h"
#import "UIFont+PongMadness.h"

@interface PMLeaderboardCell ()

- (void)setupView;

@end

@implementation PMLeaderboardCell

@synthesize rankLabel;
@synthesize usernameLabel;
@synthesize winCountLabel;
@synthesize lostCountLabel;
@synthesize playedCountLabel;
@synthesize ratioLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [self setupView];
}

- (void)setupView {
    self.rankLabel.font = [UIFont brothersBoldFontOfSize:23.f];
    self.usernameLabel.font = [UIFont brothersBoldFontOfSize:21.f];
    self.winCountLabel.font = [UIFont brothersBoldFontOfSize:18.f];
    self.lostCountLabel.font = [UIFont brothersBoldFontOfSize:18.f];
    self.playedCountLabel.font = [UIFont brothersBoldFontOfSize:18.f];
    self.ratioLabel.font = [UIFont brothersBoldFontOfSize:18.f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
