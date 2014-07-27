//
//  KTFlowLayout.m
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 7/25/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "KTFlowLayout.h"

@implementation KTFlowLayout

-(instancetype)init{
    self = [super init];
    return self;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *answer = [[super layoutAttributesForElementsInRect:rect]mutableCopy];
    
    for (int i = 1; i < [answer count]; ++i){
        UICollectionViewLayoutAttributes *currentAttr = answer[i];
        UICollectionViewLayoutAttributes *prevAttr = answer[i - 1];
        NSInteger maxSpacing = .1;
        NSInteger origin = CGRectGetMaxY(prevAttr.frame);
        if (origin + maxSpacing + currentAttr.frame.size.height < self.collectionViewContentSize.height) {
            CGRect frame = currentAttr.frame;
            frame.origin.y = origin + maxSpacing;
            currentAttr.frame = frame;
        }
    }
    return  answer;
}

//-(UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//}

@end
