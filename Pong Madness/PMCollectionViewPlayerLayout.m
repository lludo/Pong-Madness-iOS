//
//  PMCollectionViewPlayerLayout.m
//  Pong Madness
//
//  Created by Ludovic Landry on 3/2/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMCollectionViewPlayerLayout.h"

@implementation PMCollectionViewPlayerLayout

- (void)prepareLayout {
    self.minimumLineSpacing = 22.f;
    self.minimumInteritemSpacing = 22.f;
    self.itemSize = CGSizeMake(176.f, 224.f);
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.headerReferenceSize = CGSizeMake(0.f, 2.f);
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
}

- (void)modifyHeaderLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttribute {
    layoutAttribute.frame = CGRectMake(-self.headerReferenceSize.width, -self.headerReferenceSize.height, self.itemSize.width, self.itemSize.height);
}

@end
