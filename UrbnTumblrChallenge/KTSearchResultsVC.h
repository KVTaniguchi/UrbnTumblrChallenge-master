//
//  KTSearchResultsVC.h
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 7/2/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchDelegate <NSObject>

-(void)pushToCollectionView;

@end

@interface KTSearchResultsVC : UIViewController
@property (weak,nonatomic) id<SearchDelegate>delegate;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *blogTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *viewThisFeedButton;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
- (IBAction)viewThisFeedButtonPress:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *noResultsLabel;
@property (strong, nonatomic) IBOutlet UITextView *instructionsTextView;
@property (strong, nonatomic) IBOutlet UITextView *myIntroLabel;

@end
