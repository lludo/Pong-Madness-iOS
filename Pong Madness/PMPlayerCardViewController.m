//
//  PMPlayerCardViewController.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMPlayerCardViewController.h"
#import "PMPlayerEditViewController.h"
#import "PMPlayerView.h"
#import "PMLeaderboardPlayer.h"
#import "PMLeaderboard.h"
#import "UIFont+PongMadness.h"
#import "PMValueFormatter.h"

@interface PMPlayerCardViewController () <MFMailComposeViewControllerDelegate>

- (IBAction)close:(id)sender;

@property (nonatomic, strong) IBOutlet PMPlayerView *playerCardView;
@property (nonatomic, strong) IBOutlet UILabel *playedSinceLabel;
@property (nonatomic, strong) IBOutlet UIButton *messageButton;

@property (nonatomic, strong) MFMailComposeViewController *mailController;

@end

@implementation PMPlayerCardViewController

@synthesize player;
@synthesize playerCardView;
@synthesize messageButton;

- (id)init {
    self = [super init];
    return self;
}

- (id)initWithPlayer:(PMPlayer *)aPlayer {
    self = [self init];
    if (self) {
        self.player = aPlayer;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.player.username;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil)
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self action:@selector(close:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil)
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self action:@selector(edit:)];
    
    NSInteger timePlayed = [[self.player timePlayed] integerValue];
    NSInteger minutes = timePlayed / 60;
    NSInteger seconds = timePlayed % 60;
    
    self.playedSinceLabel.text = [NSString stringWithFormat:@"Played %i minutes and %i seconds since %@.", minutes, seconds, [[PMValueFormatter formatterDateShortStyle] stringFromDate:self.player.sinceDate]];
    self.playedSinceLabel.font = [UIFont brothersBoldFontOfSize:15.f];
    
    self.playerCardView.player = self.player;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.playerCardView refreshUI];
    self.messageButton.hidden = ([self.player.email length] < 6);
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)edit:(id)sender {
    PMPlayerEditViewController *playerEditViewController = [[PMPlayerEditViewController alloc] initWithPlayer:self.player];
    [self.navigationController pushViewController:playerEditViewController animated:YES];
}

- (IBAction)messagePlayer:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        self.mailController = [[MFMailComposeViewController alloc] init];
        self.mailController.mailComposeDelegate = self;
        [self.mailController setToRecipients:@[self.player.email]];
        [self.mailController setSubject:@"Pong Madness game request!"];
        [self.mailController setMessageBody:@"You think you will stay on top of this leaderboard without playing against me? Let's sort this out!" isHTML:NO];
        [self presentViewController:self.mailController animated:YES completion:NULL];
    } else {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Email Settings"
                                                             message:@"No email account configured on this device" delegate:nil
                                                   cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errorAlert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    if (result == MFMailComposeResultSent) {
        NSLog(@"Message sent");
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
    self.mailController = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
