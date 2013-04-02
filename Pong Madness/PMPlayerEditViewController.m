//
//  PMPlayerEditViewController.m
//  Pong Madness
//
//  Created by Ludovic Landry on 3/4/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMPlayerEditViewController.h"
#import "PMTeamListViewController.h"
#import "CZPhotoPickerController.h"
#import "PMDocumentManager.h"
#import "UIFont+PongMadness.h"
#import "UIImage+Resize.h"
#import "PMTeam.h"

@interface PMPlayerEditViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIButton *avatarButton;
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) IBOutlet UITextField *mailTextField;
@property (nonatomic, strong) IBOutlet UILabel *teamLabel;
@property (nonatomic, strong) IBOutlet UIButton *teamButton;
@property (nonatomic, strong) IBOutlet UIButton *handednessLeftyButton;
@property (nonatomic, strong) IBOutlet UIButton *handednessRightyButton;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *legendLabels;

@property(nonatomic, strong) CZPhotoPickerController *pickPhotoController;
@property(nonatomic, strong) UIPopoverController *teamPopoverController;

- (void)updateView;

@end

@implementation PMPlayerEditViewController

@synthesize player;
@synthesize avatarButton;
@synthesize usernameLabel;
@synthesize mailTextField;
@synthesize teamLabel;
@synthesize teamButton;
@synthesize handednessLeftyButton;
@synthesize handednessRightyButton;
@synthesize legendLabels;

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
    
    self.title = [NSString stringWithFormat:@"Edit %@", self.player.username];
    
    if ([self.navigationController.viewControllers count] == 1) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil)
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self action:@selector(done:)];
    }
    
    self.avatarButton.layer.cornerRadius = 2.f;
    
    self.usernameLabel.font = [UIFont brothersBoldFontOfSize:38.f];
    self.mailTextField.font = [UIFont brothersBoldFontOfSize:23.f];
    self.teamLabel.font = [UIFont brothersBoldFontOfSize:23.f];
    
    [self.legendLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.font = [UIFont brothersBoldFontOfSize:23.f];
    }];
    
    [self updateView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[PMDocumentManager sharedDocument] save];
}

- (void)updateView {
    if (self.player.photo) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:self.player.photo];
        
        NSData *data = [[NSData alloc] initWithContentsOfFile:fullPathToFile];
        UIImage *photo = [UIImage imageWithData:data];
        [self.avatarButton setBackgroundImage:photo forState:UIControlStateNormal];
    }
    
    self.usernameLabel.text = self.player.username;
    self.mailTextField.text = self.player.email;
    self.teamLabel.text = self.player.team.name;
    
    if ([self.player.handedness isEqualToString:@"L"]) {
        self.handednessLeftyButton.selected = YES;
        self.handednessRightyButton.selected = NO;
    } else if ([self.player.handedness isEqualToString:@"R"]) {
        self.handednessLeftyButton.selected = NO;
        self.handednessRightyButton.selected = YES;
    }
}

- (CZPhotoPickerController *)photoController {
    
    __weak PMPlayerEditViewController *weakSelf = self;
    
    return [[CZPhotoPickerController alloc] initWithPresentingViewController:self withCompletionBlock:^(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict) {
        UIImage *image = (imagePickerController.allowsEditing) ? imageInfoDict[UIImagePickerControllerEditedImage] : imageInfoDict[UIImagePickerControllerOriginalImage];
        if (image) {
            
            // Display image in the button
            [weakSelf.avatarButton setBackgroundImage:image forState:UIControlStateNormal];
            
            // Image name
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
            [dateFormatter setDateFormat:@"yyyyMMdd-HHmmss"];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            NSString *imageName = [NSString stringWithFormat:@"photo-%@", [dateFormatter stringFromDate:[NSDate date]]];
            
            // Images directory
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            // Save image to the disk and path into the user
            NSData *imageData = UIImagePNGRepresentation(image);
            NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
            [imageData writeToFile:fullPathToFile atomically:NO];
            self.player.photo = imageName;
            
            
            // Reduce the image for player cell (medium size = 152 points)
            {
                CGFloat mediumSize = 152.f * 2;
                UIImage *mediumImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit
                                                                bounds:CGSizeMake(mediumSize, mediumSize)
                                                  interpolationQuality:kCGInterpolationHigh];
                NSData *mediumImageData = UIImagePNGRepresentation(mediumImage);
                
                NSString *mediumImageName = [NSString stringWithFormat:@"%@-medium", imageName];
                NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:mediumImageName];
                [mediumImageData writeToFile:fullPathToFile atomically:NO];
            }
            
            
            // Reduce the image for leaderboard cell (small size = 51 points)
            {
                CGFloat smallSize = 51.f * 2;
                UIImage *smallImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit
                                                                   bounds:CGSizeMake(smallSize, smallSize)
                                                     interpolationQuality:kCGInterpolationHigh];
                NSData *smallImageData = UIImagePNGRepresentation(smallImage);
                
                NSString *smallImageName = [NSString stringWithFormat:@"%@-small", imageName];
                NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:smallImageName];
                [smallImageData writeToFile:fullPathToFile atomically:NO];
            }
        }
        if (weakSelf.presentedViewController) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
        weakSelf.pickPhotoController = nil;
    }];
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)choosePhoto:(id)sender {
    self.pickPhotoController = [self photoController];
    self.pickPhotoController.allowsEditing = YES;
    [self.pickPhotoController showFromRect:self.avatarButton.frame];
}

- (IBAction)selectTeam:(id)sender {
    
    PMTeamListViewController *teamListViewController = [[PMTeamListViewController alloc] init];
    [teamListViewController setContentSizeForViewInPopover:CGSizeMake(320, 240)];
    [teamListViewController setTitle:@"Pick Your Team"];
    
    UINavigationController *teamListNavController = [[UINavigationController alloc] initWithRootViewController:teamListViewController];
    
    self.teamPopoverController = [[UIPopoverController alloc] initWithContentViewController:teamListNavController];
    [self.teamPopoverController presentPopoverFromRect:self.teamButton.bounds
                                           inView:self.teamButton
                         permittedArrowDirections:UIPopoverArrowDirectionLeft
                                         animated:YES];
    
    self.player.team.name = [@"Kwarter" capitalizedString];
}

- (IBAction)selectRighty:(id)sender {
    self.handednessLeftyButton.selected = NO;
    self.handednessRightyButton.selected = YES;
    self.player.handedness = @"R";
}

- (IBAction)selectLefty:(id)sender {
    self.handednessLeftyButton.selected = YES;
    self.handednessRightyButton.selected = NO;
    self.player.handedness = @"L";
}

#pragma mark textfield delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.player.email = [self.mailTextField.text lowercaseString];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
