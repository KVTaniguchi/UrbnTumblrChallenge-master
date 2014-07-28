//
//  KTPostCVC.m
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 7/2/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "KTPostCVC.h"
#import "KTPostStore.h"
#import "KTDataLoader.h"
#import <TGLExposedLayout.h>

@interface UIColor (randomColor)

+ (UIColor *)randomColor;

@end

@implementation UIColor (randomColor)

+ (UIColor *)randomColor {
    
    CGFloat comps[3];
    
    for (int i = 0; i < 3; i++) {
        
        NSUInteger r = arc4random_uniform(256);
        comps[i] = (CGFloat)r/255.f;
    }
    
    return [UIColor colorWithRed:comps[0] green:comps[1] blue:comps[2] alpha:1.0];
}

@end

@interface KTPostCVC ()
@property (nonatomic,strong) NSNumber *numberOfItemsToShow;
@property (nonatomic,strong) KTDataLoader *dataLoader;
@property (nonatomic,strong) NSMutableArray *posts;
@end

@implementation KTPostCVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataLoader = [KTDataLoader new];
    [_dataLoader makeSession];
    _dataLoader.completionDelegate = self;
//    // Set to NO to prevent a small number
//    // of cards from filling the entire
//    // view height evenly and only show
//    // their -topReveal amount
//    //
//    self.stackedLayout.fillHeight = YES;
//    
//    // Set to NO to prevent a small number
//    // of cards from being scrollable and
//    // bounce
//    //
//    self.stackedLayout.alwaysBounce = YES;
//    
//    // Set to NO to prevent unexposed
//    // items at top and bottom from
//    // being selectable
//    //
//    self.unexposedItemsAreSelectable = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KTPostCell *postCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"postCell" forIndexPath:indexPath];
    postCell.delegate = self;
    postCell.color = [UIColor randomColor];
    
    postCell.postImagesView.layer.shouldRasterize = YES;
    postCell.postImagesView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    Post *fetchedPost = [self.fetchedPostsForUser objectAtIndex:indexPath.row];
    NSLog(@"slug: %@", fetchedPost.slug);
    [postCell.reblogLoadButton setHidden:YES];
    if (fetchedPost.caption) {
        NSString *caption = fetchedPost.caption;
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[caption dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        postCell.captionTextView.attributedText = attributedString;

        CGSize expectedCaptionSize = [attributedString size];
        double height = expectedCaptionSize.height * expectedCaptionSize.width / 320;
        dispatch_async(dispatch_get_main_queue(), ^{
            postCell.captionTextView.frame = CGRectMake(0, 230, 320, height);
            [postCell.captionTextView sizeToFit];
        });

    }else{
        postCell.captionTextView.frame = CGRectZero;
    }
    if (fetchedPost.image) {
        postCell.postImagesView.image = [UIImage imageWithData:fetchedPost.image];
        postCell.slugTextView.text = fetchedPost.slug;
    }else{
        postCell.postImagesView.image = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            postCell.postImagesView.frame = CGRectZero;
            postCell.captionTextView.frame = CGRectMake(0, 57, 320, 188);
        });
    }
    if (fetchedPost.body) {
        NSString *caption = fetchedPost.body;
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[caption dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        postCell.captionTextView.attributedText = attributedString;
    }
    if (fetchedPost.slug) {
        postCell.slugTextView.text = fetchedPost.slug;
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            postCell.slugTextView.frame = CGRectZero;
        });
    }
    if (fetchedPost.rebloggerName) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [postCell.reblogLoadButton setHidden:NO];
            [postCell.postImagesView setFrame:CGRectMake(0, 57, 165, 165)];
            [postCell.rebloggedLabel setHidden:NO];
            [postCell.rebloggerNameLabel setHidden:NO];
            [postCell.rebloggerAvatarImage setHidden:NO];
            NSString *reblogger = fetchedPost.rebloggerName;
            postCell.rebloggerNameLabel.text = reblogger;
            [_dataLoader grabReblogAvatarForUser:reblogger :^(BOOL completed) {
                if (completed) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        postCell.rebloggerAvatarImage.image = _dataLoader.downloadedImage;
                    });
                }
            }];
        });

    }else{
        [postCell.rebloggerNameLabel setHidden:YES];
        [postCell.rebloggedLabel setHidden:YES];
        [postCell.rebloggerAvatarImage setHidden:YES];
        [postCell.postImagesView setFrame:CGRectMake(0, 57, 165, 165)];
    }
    return postCell;
}

-(void)loadReblogger:(NSString *)rebloggerName{
    [[self reblogDelegate] rebloggerLoad:rebloggerName];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.fetchedPostsForUser.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//-(NSMutableArray*)posts{
//    if (!_posts) {
//        _posts = [NSMutableArray arrayWithArray:self.fetchedPostsForUser];
//    }
//    return _posts;
//}

//-(void)moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
//    Post *movePost = self.fetchedPostsForUser[fromIndexPath.item];
//    [_posts removeObjectAtIndex:fromIndexPath.item];
//    [_posts insertObject:movePost atIndex:toIndexPath.item];
//}

//-(CGFloat)setHeightOfItemForIndexPath:(NSIndexPath *)indexPath{
//        NSInteger index = indexPath.row;
//    
//        double height = 0.0;
//    
//        Post *p = [self.fetchedPostsForUser objectAtIndex:index];
//        NSLog(@" %@ height start at %f", p.slug, height);
//        // if no picture, adjust the cell to be containerview.y - the picture height is 165
//        if (p.image) {
//            //
//            height += 165.0f;
//            NSLog(@" %@ height IMAGE ADD is %f", p.slug, height);
//        }
//        // if no caption, adjust the cell to be containerview - the caption height is 188
//        if (p.caption) {
//            NSString *caption = p.caption;
//            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[caption dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//            CGSize expectedSize = [attributedString size];
//            height += expectedSize.height * expectedSize.width / 320;
//            NSLog(@"for %@ add caption h: %f", p.slug, expectedSize.height * expectedSize.width / 320);
//        }
//        if (p.slug) {
//            height += 54.0f;
//            NSLog(@"%@ slug add height is: %f", p.slug, height);
//        }
//    
//        NSLog(@"for %@ height is: %f", p.slug, height);
//        NSLog(@"************");
//    
//    return height;
//}

@end
