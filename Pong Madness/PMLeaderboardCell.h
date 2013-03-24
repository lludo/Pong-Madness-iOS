//
//  PMLeaderboardCell.h
//  Pong Madness
//
//  Created by Ludovic Landry on 3/3/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMLeaderboardCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *rankLabel;
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) IBOutlet UILabel *winCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *lostCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *playedCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *ratingLabel;

@end
