//
//  PMPlayerCell.m
//  Pong Madness
//
//  Created by Ludovic Landry on 3/2/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMPlayerCell.h"
#import "UIFont+PongMadness.h"

@interface PMPlayerCell ()

- (void)setupView;

@end

@implementation PMPlayerCell

@synthesize imageView;
@synthesize nameLabel;
@synthesize sinceLabel;

@synthesize selectionImageView;
@synthesize deleteButton;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [self setupView];
}

- (void)setupView {
    self.imageView.layer.cornerRadius = 2.f;
    self.nameLabel.font = [UIFont brothersBoldFontOfSize:23.f];
    self.sinceLabel.font = [UIFont brothersBoldFontOfSize:12.f];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
