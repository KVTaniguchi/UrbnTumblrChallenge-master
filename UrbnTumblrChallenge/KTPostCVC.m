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

@interface KTPostCVC ()
@property (nonatomic,strong) NSNumber *numberOfItemsToShow;
@property (nonatomic,strong) KTDataLoader *dataLoader;
@end

@implementation KTPostCVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataLoader = [KTDataLoader new];
    [_dataLoader makeSession];
    _dataLoader.completionDelegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KTPostCell *postCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"postCell" forIndexPath:indexPath];
    postCell.delegate = self;
    postCell.postImagesView.layer.shouldRasterize = YES;
    postCell.postImagesView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    Post *fetchedPost = [self.fetchedPostsForUser objectAtIndex:indexPath.row];
    NSLog(@"slug: %@", fetchedPost.slug);
    // size to fit
    // intrinsicContentSize
    /// find a way to get data on the sizes of items within the post cell
    
    [postCell.reblogLoadButton setHidden:YES];
    if (fetchedPost.caption) {
        NSString *caption = fetchedPost.caption;
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[caption dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        postCell.captionTextView.attributedText = attributedString;

        CGSize expectedCaptionSize = [attributedString size];
        postCell.captionTextView.frame = CGRectMake(0, 188, expectedCaptionSize.width, expectedCaptionSize.height);
    }else{
        NSLog(@"no caption, adjust the cell");
        postCell.captionTextView.frame = CGRectZero;
    }
    if (fetchedPost.image) {
        postCell.postImagesView.image = [UIImage imageWithData:fetchedPost.image];
        postCell.slugTextView.text = fetchedPost.slug;
    }else{
        postCell.postImagesView.image = nil;
        NSLog(@"no image, adjust the cell");
        postCell.postImagesView.frame = CGRectZero;
    }
    if (fetchedPost.body) {
        NSString *caption = fetchedPost.body;
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[caption dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        postCell.captionTextView.attributedText = attributedString;
    }else{
        NSLog(@"no body");
    }
    if (fetchedPost.slug) {
        postCell.slugTextView.text = fetchedPost.slug;
    }
    if (fetchedPost.rebloggerName) {
        dispatch_async(dispatch_get_main_queue(), ^{
                [postCell.reblogLoadButton setHidden:NO];
            [UIView animateWithDuration:0.5 animations:^{
                [postCell.postImagesView setFrame:CGRectMake(0, 57, 165, 165)];
            } completion:^(BOOL finished) {
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
            }];
        });

    }else{
        [postCell.rebloggerNameLabel setHidden:YES];
        [postCell.rebloggedLabel setHidden:YES];
        [postCell.rebloggerAvatarImage setHidden:YES];
        [postCell.postImagesView setFrame:CGRectMake(58, 57, 165, 165)];
    }
    NSLog(@"***********************");
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


@end
