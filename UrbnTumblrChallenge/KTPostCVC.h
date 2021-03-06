//
//  KTPostCVC.h
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 7/2/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTDataLoader.h"
#import "KTPostCell.h"
#import <UIScrollView+infiniteScrolling.h>
#import <CCInfiniteScrolling/UIScrollView+infiniteScrolling.h>
#import <TGLStackedViewController/TGLStackedViewController.h>

@protocol KTPostCVCDelegate <NSObject>

@optional
-(void)rebloggerLoad:(NSString*)rebloggerName;
@end

@interface KTPostCVC : TGLStackedViewController <KTDataloaderDelegate, KTPostCellDelegate>
@property (nonatomic,strong) id<KTPostCVCDelegate>reblogDelegate;
@property (nonatomic,strong) NSNumber *numberOfPostsToShow;
@property (nonatomic, strong) NSArray *fetchedPostsForUser;
@property (strong, nonatomic) NSIndexPath *exposedItemIndexPath;
@end
