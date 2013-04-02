//
//  PMPlayerListViewController.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMPlayerListViewController.h"
#import "PMCollectionViewPlayerManagementLayout.h"
#import "PMCollectionViewPlayerSelectionLayout.h"
#import "PMAutomaticKeyboardDismissingNavigationController.h"
#import "PMPlayerCardViewController.h"
#import "PMPlayerEditViewController.h"
#import "PMDocumentManager.h"
#import "PMValueFormatter.h"
#import "PMAddPlayerView.h"
#import "PMPlayerCell.h"
#import "PMPlayer.h"

@interface PMPlayerListViewController () <NSFetchedResultsControllerDelegate, UIAlertViewDelegate> {
    NSMutableArray *_objectChanges;
    NSMutableArray *_sectionChanges;
}

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, assign) PMPlayerListMode mode;
@property (nonatomic, strong) NSMutableArray *playersSelection;

- (void)setPlayButtonHidden:(BOOL)hidden;

@end

@implementation PMPlayerListViewController

static NSString *cellIdentifier = @"PlayerCell";
static NSString *viewIdentifier = @"AddPlayerView";

@synthesize collectionView;
@synthesize fetchedResultsController;
@synthesize mode;
@synthesize playersSelection;
@synthesize delegate;

- (id)init {
    self = [super init];
    if (self) {
        self.mode = PMPlayerListModeConsult;
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
        case PMPlayerListModeConsult: {
            self.title = @"The Players";
            PMCollectionViewPlayerManagementLayout *collectionViewLayout = [[PMCollectionViewPlayerManagementLayout alloc] init];
            [self.collectionView setCollectionViewLayout:collectionViewLayout];
            break;
        }
        case PMPlayerListModeEdit: {
            self.title = @"The Players";
            PMCollectionViewPlayerManagementLayout *collectionViewLayout = [[PMCollectionViewPlayerManagementLayout alloc] init];
            [self.collectionView setCollectionViewLayout:collectionViewLayout];
            break;
        }
        case PMPlayerListModeSelectForSingle: {
            self.title = @"Select 2 Players";
            PMCollectionViewPlayerSelectionLayout *collectionViewLayout = [[PMCollectionViewPlayerSelectionLayout alloc] init];
            [self.collectionView setCollectionViewLayout:collectionViewLayout];
            break;
        }
        case PMPlayerListModeSelectForDouble: {
            PMCollectionViewPlayerSelectionLayout *collectionViewLayout = [[PMCollectionViewPlayerSelectionLayout alloc] init];
            [self.collectionView setCollectionViewLayout:collectionViewLayout];
            self.title = @"Select the Players";
            break;
        }
    }
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:nil action:nil];
    
    if (self.mode == PMPlayerListModeConsult) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil)
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self action:@selector(edit:)];
    }
    
    NSError *error;
	if (![self.fetchedResultsController performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    UINib *addPlayerViewNib = [UINib nibWithNibName:@"PMAddPlayerView" bundle:nil];
    [self.collectionView registerNib:addPlayerViewNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:viewIdentifier];
    UINib *playerCellNib = [UINib nibWithNibName:@"PMPlayerCell" bundle:nil];
    [self.collectionView registerNib:playerCellNib forCellWithReuseIdentifier:cellIdentifier];
    
    _objectChanges = [NSMutableArray array];
    _sectionChanges = [NSMutableArray array];
    
    if (self.mode == PMPlayerListModeSelectForSingle || self.mode == PMPlayerListModeSelectForDouble) {
        self.playersSelection = [NSMutableArray array];
    }
}

- (IBAction)edit:(id)sender {
    self.mode = PMPlayerListModeEdit;
    [self.collectionView reloadData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil)
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self action:@selector(done:)];
}

- (IBAction)done:(id)sender {
    self.mode = PMPlayerListModeConsult;
    [self.collectionView reloadData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil)
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self action:@selector(edit:)];
}

- (IBAction)play:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
    if ([self.delegate respondsToSelector:@selector(didSelectParticipants:)]) {
        [self.delegate didSelectParticipants:[NSArray arrayWithArray:playersSelection]];
    }
}

- (IBAction)deletePlayer:(id)sender {
    CGPoint buttonPositionClicked = [self.collectionView convertPoint:CGPointZero fromView:sender];
    NSInteger x = (buttonPositionClicked.x + 12) / 201;
    NSInteger y = (buttonPositionClicked.y +12) / 246;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(x + 5 * y) - 1 inSection:0];
    PMPlayer *player = [fetchedResultsController objectAtIndexPath:indexPath];
    self.playersSelection = [NSArray arrayWithObject:player];
    
    UIAlertView *confirmAlert = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                           message:[NSString stringWithFormat:@"Are you sure you want to delete %@?", player.username]
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"Ok", nil];
    [confirmAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 && self.playersSelection && [self.playersSelection count] == 1) {
        PMPlayer *player = [self.playersSelection lastObject];
        [player descativate];
    }
}

- (void)setPlayButtonHidden:(BOOL)hidden {
    if (hidden) {
        self.navigationItem.rightBarButtonItem = nil;
    } else if (self.navigationItem.rightBarButtonItem == nil) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Play", nil)
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self action:@selector(play:)];
    }
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (!fetchedResultsController) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"username" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"active == YES"]];
        [fetchRequest setFetchBatchSize:20];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                            managedObjectContext:managedObjectContext sectionNameKeyPath:nil
                                                                                       cacheName:@"Root"];
        fetchedResultsController.delegate = self;
    }
    return fetchedResultsController;
}

#pragma mark table collection delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)aCollectionView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)collectionView:(UICollectionView *)aCollectionView numberOfItemsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)aCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PMPlayerCell *cell = [aCollectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PMPlayer *player = [fetchedResultsController objectAtIndexPath:indexPath];
    cell.nameLabel.text = player.username;
    
    NSString *dateString = [[PMValueFormatter formatterDateShortStyle] stringFromDate:player.sinceDate];
    cell.sinceLabel.text = [NSString stringWithFormat:@"Since %@", dateString];
    
    if (player.photo) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *photoName = [NSString stringWithFormat:@"%@-medium", player.photo];
        NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:photoName];
        
        NSData *data = [[NSData alloc] initWithContentsOfFile:fullPathToFile];
        cell.imageView.image = [UIImage imageWithData:data];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"default-avatar"];
    }
    
    // No selection in manage mode
    if (self.mode == PMPlayerListModeConsult || self.mode == PMPlayerListModeEdit) {
        cell.selectionImageView.hidden = YES;
    } else {
        cell.selectionImageView.hidden = NO;
        cell.selectionImageView.highlighted = [self.playersSelection containsObject:player];
        if ([self.playersSelection count] == 2 && !cell.selectionImageView.highlighted) {
            cell.contentView.alpha = 0.1f;
        } else {
            cell.contentView.alpha = 1.f;
        }
    }
    
    cell.deleteButton.hidden = (self.mode != PMPlayerListModeEdit);
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)aCollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    PMAddPlayerView *cell = [aCollectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:viewIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [aCollectionView deselectItemAtIndexPath:indexPath animated:YES];
    PMPlayer *player = [fetchedResultsController objectAtIndexPath:indexPath];
    
    switch (self.mode) {
        case PMPlayerListModeConsult: {
            PMPlayerCardViewController *playerViewController = [[PMPlayerCardViewController alloc] initWithPlayer:player];
            PMAutomaticKeyboardDismissingNavigationController *navigationController = [[PMAutomaticKeyboardDismissingNavigationController alloc] initWithRootViewController:playerViewController];
            navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:navigationController animated:YES completion:NULL];
            break;
        }
        case PMPlayerListModeEdit: {
            PMPlayerEditViewController *playerEditViewController = [[PMPlayerEditViewController alloc] initWithPlayer:player];
            PMAutomaticKeyboardDismissingNavigationController *navigationController = [[PMAutomaticKeyboardDismissingNavigationController alloc] initWithRootViewController:playerEditViewController];
            navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:navigationController animated:YES completion:NULL];
            break;
        }
        case PMPlayerListModeSelectForSingle: {
            
            // Select or deselect the player
            if ([self.playersSelection containsObject:player]) {
                [self.playersSelection removeObject:player];
            } else {
                if ([self.playersSelection count] != 2) {
                    [self.playersSelection addObject:player];
                }
            }
            
            // Display/hide the play button
            [self setPlayButtonHidden:([self.playersSelection count] != 2)];
            
            // Reload the view
            [aCollectionView reloadData];
            
            break;
        }
        case PMPlayerListModeSelectForDouble: {
            
            //TODO: later
            
            break;
        }
    }
}

#pragma mark fetched results controller delegate

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    NSMutableDictionary *change = [NSMutableDictionary new];
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = @(sectionIndex);
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = @(sectionIndex);
            break;
    }
    
    [_sectionChanges addObject:change];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    NSMutableDictionary *change = [NSMutableDictionary new];
    switch(type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = newIndexPath;
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeUpdate:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeMove:
            change[@(type)] = @[indexPath, newIndexPath];
            break;
    }
    [_objectChanges addObject:change];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if ([_sectionChanges count] > 0) {
        [self.collectionView performBatchUpdates:^{
            
            for (NSDictionary *change in _sectionChanges) {
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                    
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch (type) {
                        case NSFetchedResultsChangeInsert:
                            [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        case NSFetchedResultsChangeUpdate:
                            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                    }
                }];
            }
        } completion:nil];
    }
    
    if ([_objectChanges count] > 0 && [_sectionChanges count] == 0) {
        
        if ([self shouldReloadCollectionViewToPreventKnownIssue]) {
            [self.collectionView reloadData];
        } else {
            [self.collectionView performBatchUpdates:^{
                
                for (NSDictionary *change in _objectChanges)
                {
                    [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                        
                        NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                        switch (type)
                        {
                            case NSFetchedResultsChangeInsert:
                                [self.collectionView insertItemsAtIndexPaths:@[obj]];
                                break;
                            case NSFetchedResultsChangeDelete:
                                [self.collectionView deleteItemsAtIndexPaths:@[obj]];
                                break;
                            case NSFetchedResultsChangeUpdate:
                                [self.collectionView reloadItemsAtIndexPaths:@[obj]];
                                break;
                            case NSFetchedResultsChangeMove:
                                [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                                break;
                        }
                    }];
                }
            } completion:nil];
        }
        
        [_sectionChanges removeAllObjects];
        [_objectChanges removeAllObjects];
    }
}

- (BOOL)shouldReloadCollectionViewToPreventKnownIssue {
    __block BOOL shouldReload = NO;
    for (NSDictionary *change in _objectChanges) {
        [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSFetchedResultsChangeType type = [key unsignedIntegerValue];
            NSIndexPath *indexPath = obj;
            switch (type) {
                case NSFetchedResultsChangeInsert:
                    if ([self.collectionView numberOfItemsInSection:indexPath.section] == 0) {
                        shouldReload = YES;
                    } else {
                        shouldReload = NO;
                    }
                    break;
                case NSFetchedResultsChangeDelete:
                    if ([self.collectionView numberOfItemsInSection:indexPath.section] == 1) {
                        shouldReload = YES;
                    } else {
                        shouldReload = NO;
                    }
                    break;
                case NSFetchedResultsChangeUpdate:
                    shouldReload = NO;
                    break;
                case NSFetchedResultsChangeMove:
                    shouldReload = NO;
                    break;
            }
        }];
    }
    
    return shouldReload;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
