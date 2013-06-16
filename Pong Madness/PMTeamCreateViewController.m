//
//  PMTeamCreateViewController.m
//  Pong Madness
//
//  Created by Ludovic Landry on 4/1/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMTeamCreateViewController.h"
#import "PMDocumentManager.h"
#import "PMTeam.h"

@interface PMTeamCreateViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *nameTextField;

@end

@implementation PMTeamCreateViewController

@synthesize nameTextField;

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Add Team";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil)
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self action:@selector(done:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.nameTextField becomeFirstResponder];
}

- (void)done:(id)sender {
    [self.nameTextField resignFirstResponder];
    [self createTeam];
    [[PMDocumentManager sharedDocument] save];
}

- (void)createTeam {
    NSString *teamName = self.nameTextField.text;
    
    if (teamName && [teamName length] > 0) {
        [PMTeam teamWithName:teamName];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self createTeam];
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
