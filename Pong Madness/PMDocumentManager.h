//
//  PMDocumentManager.h
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PMDocumentManager : NSObject {
    dispatch_queue_t queue;
}

+ (PMDocumentManager *)sharedDocument;

/*
 * Save the managed object context if needed.
 */
- (void)save;

/*
 * Reset the persistent store to an empty one ready to be used. Returns YES if succeed.
 */
- (BOOL)resetStore;

//moc bound to the main thread
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

@end