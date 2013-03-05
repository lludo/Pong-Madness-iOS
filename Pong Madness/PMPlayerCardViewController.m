//
//  PMPlayerCardViewController.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMPlayerCardViewController.h"
#import "PMPlayerView.h"
#import "PMLeaderboardPlayer.h"
#import "PMLeaderboard.h"
#import "UIFont+PongMadness.h"

@interface PMPlayerCardViewController ()

- (IBAction)close:(id)sender;

@property (nonatomic, assign) PMPlayerCardMode mode;
@property (nonatomic, strong) IBOutlet PMPlayerView *playerCardView;

@end

@implementation PMPlayerCardViewController

@synthesize player;
@synthesize mode;
@synthesize playerCardView;

- (id)init {
    self = [super init];
    if (self) {
        self.mode = PMPlayerCardModeConsult;
    }
    return self;
}

- (id)initWithMode:(PMPlayerCardMode)aMode {
    self = [super init];
    if (self) {
        self.mode = aMode;
    }
    return self;
}

- (id)initWithPlayer:(PMPlayer *)aPlayer mode:(PMPlayerCardMode)aMode {
    self = [self initWithMode:aMode];
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
    
    self.playerCardView.transform = CGAffineTransformMakeTranslation(0.f, -466.f);
    self.playerCardView.player = self.player;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.playerCardView refreshUI];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
