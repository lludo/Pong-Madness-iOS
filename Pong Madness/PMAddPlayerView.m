//
//  PMAddPlayerView.m
//  Pong Madness
//
//  Created by Ludovic Landry on 3/2/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMAddPlayerView.h"
#import "PMDocumentManager.h"
#import "PMPlayer.h"

@interface PMAddPlayerView () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *usernameField;

@end

@implementation PMAddPlayerView

@synthesize usernameField;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)createNewPlayer:(id)sender {
    NSString *username = [self.usernameField.text capitalizedString];
    self.usernameField.text = nil;
    [self.usernameField resignFirstResponder];
    
    NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:managedObjectContext];
    PMPlayer *player = [[PMPlayer alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:managedObjectContext];
    
    player.username = username;
    player.sinceDate = [NSDate date];
    
    [[PMDocumentManager sharedDocument] save];
}

#pragma mark text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self createNewPlayer:textField];
    return NO;
}

@end
