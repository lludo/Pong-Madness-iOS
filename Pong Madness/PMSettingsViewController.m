//
//  PMSettingsViewController.m
//  Pong Madness
//
//  Created by Ludovic Landry on 3/2/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMSettingsViewController.h"
#import "UIFont+PongMadness.h"

@interface PMSettingsViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *robinImageView;
@property (nonatomic, strong) IBOutlet UILabel *robinNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *robinJobTitleLabel;

@property (nonatomic, strong) IBOutlet UIImageView *ludoImageView;
@property (nonatomic, strong) IBOutlet UILabel *ludoNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *ludoJobTitleLabel;

- (IBAction)sendMessageToRobin:(id)sender;
- (IBAction)sendMessageToLudo:(id)sender;

@end

@implementation PMSettingsViewController

@synthesize robinImageView;
@synthesize robinNameLabel;
@synthesize robinJobTitleLabel;
@synthesize ludoImageView;
@synthesize ludoNameLabel;
@synthesize ludoJobTitleLabel;

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Settings";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil)
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self action:@selector(close:)];
    
    self.robinImageView.layer.cornerRadius = 2.f;
    self.robinNameLabel.font = [UIFont brothersBoldFontOfSize:23.f];
    self.robinJobTitleLabel.font = [UIFont brothersBoldFontOfSize:12.f];
    
    self.ludoImageView.layer.cornerRadius = 2.f;
    self.ludoNameLabel.font = [UIFont brothersBoldFontOfSize:23.f];
    self.ludoJobTitleLabel.font = [UIFont brothersBoldFontOfSize:12.f];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMessageToRobin:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:@[@"robin.clediere@me.com"]];
        [controller setSubject:@"Hello from Pong Madness"];
        [controller setMessageBody:@"Great design! I love this app, thank you!" isHTML:NO];
        [self presentViewController:controller animated:YES completion:NULL];
    } else {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Email Settings"
                                                             message:@"No email account configured on this device" delegate:nil
                                                   cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errorAlert show];
    }
}

- (IBAction)sendMessageToLudo:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:@[@"dev.mirageteam@gmail.com"]];
        [controller setSubject:@"Hello from Pong Madness"];
        [controller setMessageBody:@"Great iPad app! I love it, thank you!" isHTML:NO];
        [self presentViewController:controller animated:YES completion:NULL];
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
}

@end
