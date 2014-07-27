//
//  KTViewController.h
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 6/30/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTDataLoader.h"
#import "KTSearchResultsVC.h"
#import "KTPostCVC.h"

@interface KTViewController : UIViewController <KTDataloaderDelegate, UITextFieldDelegate, SearchDelegate, KTPostCVCDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *tumblrAvatar;
@property KTDataLoader *dataLoader;
-(void)refreshCurrentFeed;
@end
