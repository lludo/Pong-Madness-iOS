//
//  PMTeamTableViewCell.m
//  Pong Madness
//
//  Created by Ludovic Landry on 4/1/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMTeamTableViewCell.h"

@interface PMTeamTableViewCell ()

- (void)setupView;

@end

@implementation PMTeamTableViewCell

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
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
