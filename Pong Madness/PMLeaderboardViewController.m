//
//  PMLeaderboardViewController.m
//  Pong Madness
//
//  Created by Ludovic Landry on 3/2/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMLeaderboardViewController.h"
#import "PMPlayerCardViewController.h"
#import "PMLeaderboardCell.h"
#import "UIFont+PongMadness.h"
#import "UIImage+Stretch.h"
#import "PMValueFormatter.h"
#import "PMLeaderboardPlayer.h"
#import "PMLeaderboard.h"
#import "PMPlayerView.h"
#import "PMPlayer.h"

@interface PMLeaderboardViewController () <UITableViewDelegate, UITableViewDataSource, UITabBarDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *tableHeaderView;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *legendLabels;
@property (nonatomic, strong) IBOutlet PMPlayerView *playerCardView;
@property (nonatomic, strong) IBOutlet UIView *nobodyView;
@property (nonatomic, strong) IBOutlet UITabBar *tabBar;
@property (nonatomic, strong) NSArray *leaderboardPlayers;

- (void)updateView;

@end

@implementation PMLeaderboardViewController

@synthesize tableView;
@synthesize tableHeaderView;
@synthesize leaderboardPlayers;
@synthesize playerCardView;
@synthesize nobodyView;

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Leaderboard";
    
    UINib *leaderboardCellNib = [UINib nibWithNibName:@"PMLeaderboardCell" bundle:nil];
    [self.tableView registerNib:leaderboardCellNib forCellReuseIdentifier:@"LeaderboardCell"];
    [self.legendLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.font = [UIFont brothersBoldFontOfSize:12.f];
    }];
    
    UITabBarItem *allTimeTabBarItem = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *thisWeekTabBarItem = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *lastWeekTabBarItem = [self.tabBar.items objectAtIndex:2];
    
    self.tabBar.selectedItem = allTimeTabBarItem;
    float tabbarImageOffset = 7;
    
    self.nobodyView.alpha = 0.f;
    self.playerCardView.transform = CGAffineTransformConcat(
        CGAffineTransformMakeTranslation(420, -180),
        CGAffineTransformMakeRotation(M_PI_4/2)
    );
    
    [allTimeTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar-item-alltime-selected.png"]
             withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar-item-alltime.png"]];
    allTimeTabBarItem.imageInsets = UIEdgeInsetsMake(tabbarImageOffset, 0, -tabbarImageOffset, 0);
    
    [thisWeekTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar-item-thisweek-selected.png"]
             withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar-item-thisweek.png"]];
    thisWeekTabBarItem.imageInsets = UIEdgeInsetsMake(tabbarImageOffset, 0, -tabbarImageOffset, 0);
    
    [lastWeekTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar-item-lastweek-selected.png"]
                     withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar-item-lastweek.png"]];
    lastWeekTabBarItem.imageInsets = UIEdgeInsetsMake(tabbarImageOffset, 0, -tabbarImageOffset, 0);
    
    UIImage *tabbarBackground = [UIImage stretchableHorizontalImageNamed:@"tabbar-background.png"];
    [self.tabBar setBackgroundImage:tabbarBackground];
    
    [self.tabBar setSelectionIndicatorImage:[[UIImage alloc] init]];
    
    
    // Setup data in the views
    
    [self updateView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    PMPlayer *playerOfTheWeek = [PMLeaderboard playerOfTheWeek];
    if (playerOfTheWeek) {
        self.playerCardView.player = playerOfTheWeek;
        [UIView animateWithDuration:0.4 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.playerCardView.transform = CGAffineTransformIdentity;
        } completion:NULL];
    } else {
        [UIView animateWithDuration:0.4 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.nobodyView.alpha = 1.f;
        } completion:NULL];
    }
}

- (void)updateView {
    PMLeaderboard *leaderboard;
    
    // All time
    if (self.tabBar.selectedItem == [self.tabBar.items objectAtIndex:0]) {
        leaderboard = [PMLeaderboard globalLeaderboard];
    // This week
    } else if (self.tabBar.selectedItem == [self.tabBar.items objectAtIndex:1]) {
        leaderboard = [PMLeaderboard currentWeekLeaderboard];
    // Last week
    } else {
        leaderboard = [PMLeaderboard lastWeekLeaderboard];
    }
    
    NSSortDescriptor *ratingSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:NO];
    NSSortDescriptor *gamesPlayedCountSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"gamesPlayedCount" ascending:NO];
    self.leaderboardPlayers = [leaderboard.leaderboardPlayerSet sortedArrayUsingDescriptors:@[ratingSortDescriptor, gamesPlayedCountSortDescriptor]];
    
    [self.tableView reloadData];
}

#pragma mark tableview delegate 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.leaderboardPlayers count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMLeaderboardCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"LeaderboardCell" forIndexPath:indexPath];
    PMLeaderboardPlayer *leaderboardPlayer = [self.leaderboardPlayers objectAtIndex:indexPath.row];
    
    if (leaderboardPlayer.player.photo) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *photoName = [NSString stringWithFormat:@"%@-small", leaderboardPlayer.player.photo];
        NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:photoName];
        
        NSData *data = [[NSData alloc] initWithContentsOfFile:fullPathToFile];
        cell.imageView.image = [UIImage imageWithData:data];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"default-avatar-small"];
    }
    
    cell.rankLabel.text = [NSString stringWithFormat:@"#%i", indexPath.row + 1];
    cell.usernameLabel.text = leaderboardPlayer.player.username;
    cell.winCountLabel.text = [leaderboardPlayer.gamesWonCount stringValue];
    cell.lostCountLabel.text = [NSString stringWithFormat:@"%i", [leaderboardPlayer.gamesPlayedCount intValue] - [leaderboardPlayer.gamesWonCount intValue]];
    cell.playedCountLabel.text = [leaderboardPlayer.gamesPlayedCount stringValue];
    cell.ratingLabel.text = [[PMValueFormatter formatterNumberDecimalStyle] stringFromNumber:leaderboardPlayer.rating];
    
    cell.contentView.backgroundColor = [UIColor colorWithWhite:1.f alpha:(indexPath.row % 2) ? 0.03f : 0.f];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.tableHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PMLeaderboardPlayer *leaderboardPlayer = [self.leaderboardPlayers objectAtIndex:indexPath.row];
    
    PMPlayerCardViewController *playerViewController = [[PMPlayerCardViewController alloc] initWithPlayer:leaderboardPlayer.player];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:playerViewController];
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark tabbar delegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [self updateView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
