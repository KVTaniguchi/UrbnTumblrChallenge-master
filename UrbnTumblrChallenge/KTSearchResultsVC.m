//
//  KTSearchResultsVC.m
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 7/2/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "KTSearchResultsVC.h"

@interface KTSearchResultsVC ()

@end

@implementation KTSearchResultsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewThisFeedButtonPress:(id)sender {
    [[self delegate] pushToCollectionView];
}
@end
