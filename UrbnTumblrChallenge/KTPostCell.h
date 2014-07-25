//
//  KTPostCell.h
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 7/1/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTPostCellDelegate <NSObject>

@optional
-(void)loadReblogger:(NSString*)rebloggerName;
@end


@interface KTPostCell : UICollectionViewCell
@property (strong, nonatomic) id<KTPostCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet UITextView *slugTextView;
@property (strong, nonatomic) IBOutlet UIImageView *postImagesView;
@property (strong, nonatomic) IBOutlet UITextView *captionTextView;
@property (strong, nonatomic) IBOutlet UILabel *rebloggerNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *rebloggerAvatarImage;
@property (strong, nonatomic) IBOutlet UILabel *rebloggedLabel;
@property (strong, nonatomic) IBOutlet UIButton *reblogLoadButton;
- (IBAction)reblogButtonPressed:(id)sender;

@end
