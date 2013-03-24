//
//  PMCollectionViewPlayerLayout.m
//  Pong Madness
//
//  Created by Ludovic Landry on 3/2/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMCollectionViewPlayerManagementLayout.h"

@interface PMCollectionViewPlayerManagementLayout ()

@property (nonatomic, assign) float newMinHeight;

@end

@implementation PMCollectionViewPlayerManagementLayout

@synthesize newMinHeight;

- (void)prepareLayout {
    [super prepareLayout];
    self.headerReferenceSize = CGSizeMake(0.f, 2.f);
    self.newMinHeight = 0.f;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *layoutAttributes = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes *layoutAttribute in layoutAttributes) {
        if (!layoutAttribute.representedElementKind) {
            [self modifyCellLayoutAttributes:layoutAttribute];
        } else {
            [self modifyHeaderLayoutAttributes:layoutAttribute];
        }
    }
    
    return layoutAttributes;
}

- (void)modifyCellLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttribute {
    NSIndexPath *itemIndexPath = layoutAttribute.indexPath;
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:itemIndexPath.item + 1 inSection:itemIndexPath.section];
    layoutAttribute.frame = [super layoutAttributesForItemAtIndexPath:nextIndexPath].frame;
    
    if (layoutAttribute.frame.origin.y > self.newMinHeight) {
        self.newMinHeight = layoutAttribute.frame.origin.y;
    }
}

- (void)modifyHeaderLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttribute {
    layoutAttribute.frame = CGRectMake(-self.headerReferenceSize.width, -self.headerReferenceSize.height, self.itemSize.width, self.itemSize.height);
}

- (CGSize)collectionViewContentSize {
    CGSize size = [super collectionViewContentSize];
    if (size.height < self.newMinHeight) {
        size.height += self.itemSize.height + self.minimumInteritemSpacing;
    }
    return size;
}

@end
