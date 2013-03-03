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
#import "PMPlayerCardViewController.h"
#import "PMDocumentManager.h"
#import "PMValueFormatter.h"
#import "PMAddPlayerView.h"
#import "PMPlayerCell.h"
#import "PMPlayer.h"

@interface PMPlayerListViewController () <NSFetchedResultsControllerDelegate> {
    NSMutableArray *_objectChanges;
    NSMutableArray *_sectionChanges;
}

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, assign) PMPlayerListMode mode;
@property (nonatomic, strong) NSMutableArray *playersSelection;

@end

@implementation PMPlayerListViewController

static NSString *cellIdentifier = @"PlayerCell";
static NSString *viewIdentifier = @"AddPlayerView";

@synthesize collectionView;
@synthesize fetchedResultsController;
@synthesize mode;
@synthesize playersSelection;

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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self action:@selector(close:)];
    
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
    
    if (self.mode != PMPlayerListModeManage) {
        self.playersSelection = [NSMutableArray array];
    }
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
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

#pragma mark table collection delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)aCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PMPlayerCell *cell = [aCollectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PMPlayer *player = [fetchedResultsController objectAtIndexPath:indexPath];
    cell.nameLabel.text = player.username;
    
    NSString *dateString = [[PMValueFormatter formatterDateShortStyle] stringFromDate:player.sinceDate];
    cell.sinceLabel.text = [NSString stringWithFormat:@"Since %@", dateString];
    
    // No selection in ma
    if (self.mode == PMPlayerListModeManage) {
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
        case PMPlayerListModeManage: {
            PMPlayerCardViewController *playerViewController = [[PMPlayerCardViewController alloc] initWithPlayer:player mode:PMPlayerCardModeConsult];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:playerViewController];
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
