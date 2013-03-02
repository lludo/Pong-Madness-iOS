//
//  PMPlayerListViewController.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMPlayerListViewController.h"
#import "PMPlayerCardViewController.h"
#import "PMDocumentManager.h"
#import "PMPlayerCell.h"
#import "PMPlayer.h"

@interface PMPlayerListViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, assign) PMPlayerListMode mode;

@end

@implementation PMPlayerListViewController

@synthesize tableView;
@synthesize usernameField;
@synthesize fetchedResultsController;

- (id)init {
    self = [super init];
    if (self) {
        self.mode = PMPlayerListModeManage;
    }
    return self;
}

- (id)initWithMode:(PMPlayerListMode)aMode {
    self = [super init];
    if (self) {
        self.mode = aMode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.mode) {
        case PMPlayerListModeManage: {
            self.title = @"The Players";
            break;
        }
        case PMPlayerListModeSelectForSingle: {
            self.title = @"Select 2 Players";
            break;
        }
        case PMPlayerListModeSelectForDouble: {
            self.title = @"Select the Players";
            break;
        }
    }
    
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self action:@selector(close:)];
    
    NSError *error;
	if (![self.fetchedResultsController performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)createNewPlayer:(id)sender {
    NSString *username = [self.usernameField.text capitalizedString];
    self.usernameField.text = nil;
    [self.usernameField resignFirstResponder];
    
    NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:managedObjectContext];
    PMPlayer *player = [[PMPlayer alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:managedObjectContext];
    
    player.username = username;
    
    [[PMDocumentManager sharedDocument] save];
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (!fetchedResultsController) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"username" ascending:YES];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        [fetchRequest setFetchBatchSize:20];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                            managedObjectContext:managedObjectContext sectionNameKeyPath:nil
                                                                                       cacheName:@"Root"];
        fetchedResultsController.delegate = self;
    }
    return fetchedResultsController;
}

#pragma mark table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"PMPlayerCell";
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        [aTableView registerClass:[PMPlayerCell class] forCellReuseIdentifier:cellIdentifier];
        cell = [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    // Set up the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PMPlayer *player = [fetchedResultsController objectAtIndexPath:indexPath];
    
    PMPlayerCardViewController *playerViewController = [[PMPlayerCardViewController alloc] initWithPlayer:player];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:playerViewController];
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    PMPlayer *player = [fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = player.username;
}

#pragma mark fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

#pragma mark text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self createNewPlayer:textField];
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
