//
//  PMCollectionViewPlayerSelectionLayout.m
//  Pong Madness
//
//  Created by Ludovic Landry on 3/2/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMCollectionViewPlayerSelectionLayout.h"

@implementation PMCollectionViewPlayerSelectionLayout

- (void)prepareLayout {
    self.minimumLineSpacing = 22.f;
    self.minimumInteritemSpacing = 22.f;
    self.itemSize = CGSizeMake(176.f, 224.f);
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.headerReferenceSize = CGSizeMake(0.f, 2.f);
}

@end
