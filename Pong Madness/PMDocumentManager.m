//
//  PMDocumentManager.m
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMDocumentManager.h"

@interface PMDocumentManager ()

@property (nonatomic, strong) NSString *storeType;
@property (nonatomic, strong) NSString *managedObjectModelName;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

- (void)addPersistentStoreToPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)aPersistentStoreCoordinator;

@end

@implementation PMDocumentManager

@synthesize storeType;
@synthesize managedObjectModelName;
@synthesize persistentStoreCoordinator;
@synthesize managedObjectContext;
@synthesize managedObjectModel;

- (id)init {
    self = [super init];
    if (self) {
        self.storeType = NSSQLiteStoreType;
        self.managedObjectModelName = @"PongMadnessModel";
        queue = dispatch_queue_create("PongMadnessModelQueue", NULL);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldSave) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldSave) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

+ (PMDocumentManager *)sharedDocument {
    static PMDocumentManager *_sharedDocument = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDocument = [[self alloc] init];
    });
    return _sharedDocument;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!managedObjectModel) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *modelURL = [bundle URLForResource:self.managedObjectModelName withExtension:@"momd"];
        NSAssert1(modelURL, @"unable to find URL for managed object model %@", self.managedObjectModelName);
        managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return managedObjectModel;
}

- (NSURL *)urlForStoreType:(NSString *)type andDocumentNamed:(NSString *)documentName {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *storePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", documentName]];
    return [NSURL fileURLWithPath:storePath];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    __block id result = nil;
    dispatch_sync(queue, ^{
        if (!persistentStoreCoordinator)  {
            persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
            [self addPersistentStoreToPersistentStoreCoordinator:persistentStoreCoordinator];
        }
        result = persistentStoreCoordinator;
    });
    return result;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (!managedObjectContext) {
        managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    }
    return managedObjectContext;
}

- (void)addPersistentStoreToPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)aPersistentStoreCoordinator {
    NSURL *storeURL = [self urlForStoreType:self.storeType andDocumentNamed:self.managedObjectModelName];
    
    NSDictionary *options = @{
        NSInferMappingModelAutomaticallyOption: @(YES),
        NSMigratePersistentStoresAutomaticallyOption: @(YES)
    };
    
    NSError *openError = nil;
    id persistentStore = [aPersistentStoreCoordinator addPersistentStoreWithType:self.storeType
                                                                   configuration:nil URL:storeURL
                                                                         options:options error:&openError];
    if (!persistentStore) {
        NSError *deleteError = nil;
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&deleteError];
        persistentStore = [aPersistentStoreCoordinator addPersistentStoreWithType:self.storeType
                                                                    configuration:nil URL:storeURL
                                                                          options:options error:&openError];
    }
    NSAssert(persistentStore, @"failed to add persistent store, error is %@", [openError localizedDescription]);
}

- (void)shouldSave {
    if ([managedObjectContext hasChanges]) {
        NSError *error = nil;
        BOOL saved = [managedObjectContext save:&error];
        NSAssert(saved, @"failed to save with error %@", [error localizedDescription]);
        NSLog(@"saved document");
    }
}

- (void)save {
    [self shouldSave];
}

- (BOOL)resetStore {
    
    __block NSError *error = nil;
    [managedObjectContext performBlockAndWait:^{
        
        // Save pending changes to avoid crash
        [self save];
        
        // Remove persistent store from coordinator
        
        [persistentStoreCoordinator.persistentStores enumerateObjectsUsingBlock:^(NSPersistentStore *persistentStore, NSUInteger idx, BOOL *stop) {
            [persistentStoreCoordinator removePersistentStore:persistentStore error:&error];
        }];
        
        if (!error) {
            // Erase the store on the disk
            NSURL *storeURL = [self urlForStoreType:self.storeType andDocumentNamed:self.managedObjectModelName];
            [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
            
            if (!error) {
                // Recreate an empty store ready to be used
                [self addPersistentStoreToPersistentStoreCoordinator:persistentStoreCoordinator];
            }
        }
    }];
    
    return (!error);
}

@end
