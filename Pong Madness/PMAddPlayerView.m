//
//  PMAddPlayerView.m
//  Pong Madness
//
//  Created by Ludovic Landry on 3/2/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMAddPlayerView.h"
#import "PMDocumentManager.h"
#import "UIFont+PongMadness.h"
#import "PMPlayer.h"

@interface PMAddPlayerView () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;

- (void)setupView;

@end

@implementation PMAddPlayerView

@synthesize usernameField;
@synthesize backgroundImageView;

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
    self.usernameField.font = [UIFont brothersBoldFontOfSize:18.f];
}

- (IBAction)createNewPlayer:(id)sender {
    
    // If no text in the field we just select the field
    if ([self.usernameField.text length] == 0) {
        [self.usernameField becomeFirstResponder];
        return;
    }
    
    NSString *username = [self.usernameField.text capitalizedString];
    self.usernameField.text = nil;
    [self.usernameField resignFirstResponder];
    
    [PMPlayer playerWithUsername:username];
    [[PMDocumentManager sharedDocument] save];
}

#pragma mark text field delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.backgroundImageView.highlighted = YES;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    self.backgroundImageView.highlighted = NO;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self createNewPlayer:textField];
    return NO;
}

@end
