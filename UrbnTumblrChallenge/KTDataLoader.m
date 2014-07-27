//
//  KTDataLoader.m
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 6/30/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//
//Usage of cocoa pods and third party libraries is fine
//Enter a username or tumblr url to load a user's feed
//Display feed items for all posts
//Feed should be infinitely scrollable collection view supporting a way to refresh
//If the post originated from another user, I should be able to tap another users avatar/user to transition to that users feed using a custom navigation transition
//Full HTML rendering of posts (without web view)
//Client side persistence for using core data
//App should properly update when coming in and out of active states
//App should be resilient to loss of network connectivity where possible
//Unit tests are encouraged
//Use of animations are encouraged
//All code should be in Github

#import "KTDataLoader.h"
#import "KTPostStore.h"

@interface KTDataLoader ()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionConfiguration *config;
@property (nonatomic,weak) NSURLSessionDownloadTask *downloadTask;
@end

@implementation KTDataLoader


-(void)makeSession{
    self.config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:self.config delegate:self delegateQueue:nil];
    self.downloadedImage = [UIImage new];
}

-(void)grabBlogInfoForUser:(NSString*)textFieldEntry{
    NSString *link = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@.tumblr.com/info?api_key=oRjHa869ZJYZAhypDvVx20gDcy0RDF6KS07OXC8VdCZMPNR7sG", textFieldEntry];
    NSURL *url = [NSURL URLWithString:link];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (response) {
            NSHTTPURLResponse *status = (NSHTTPURLResponse*)response;
            if (status.statusCode != 200) {
                [[self completionDelegate] searchReturnedNoResults];
            }else if (status.statusCode == 200){
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    NSDictionary *response = [jsonData objectForKey:@"response"];
                    NSDictionary *blog = [response objectForKey:@"blog"];
                    self.blogtitle = [blog objectForKey:@"title"];
                    self.usernameToLoad = [blog objectForKey:@"name"];
                    NSString *blogDescription = [NSString stringWithString:[blog objectForKey:@"description"]];
                    [[self completionDelegate] setSearchResultsVCBlogTitle:self.blogtitle userName:self.usernameToLoad description:blogDescription];
                });
            }
        }else{
            NSLog(@"no response with response %@", response.description);
            [[self completionDelegate] searchReturnedNoResults];
        }
    }];
    [dataTask resume];
}

-(void)grabReblogAvatarForUser:(NSString *)userName :(myCompletion)compBlock{
    NSString *link = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@.tumblr.com/avatar/info?api_key=oRjHa869ZJYZAhypDvVx20gDcy0RDF6KS07OXC8VdCZMPNR7sG", userName];
    NSURL *url = [NSURL URLWithString:link];
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        self.downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        compBlock(YES);
    }];
    [downloadTask resume];
}

-(void)grabBlogAvatarForUser:(NSString*)userName{
    NSString *link = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@.tumblr.com/avatar/info?api_key=oRjHa869ZJYZAhypDvVx20gDcy0RDF6KS07OXC8VdCZMPNR7sG", userName];
    NSURL *url = [NSURL URLWithString:link];
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        self.downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        [[self completionDelegate] setAvatarImage];
    }];
    [downloadTask resume];
}

-(void)getPostsForUser:(NSString*)userName{
    NSString *link = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@.tumblr.com/posts/?api_key=oRjHa869ZJYZAhypDvVx20gDcy0RDF6KS07OXC8VdCZMPNR7sG&reblog_info=true", userName];
    NSURL *url = [NSURL URLWithString:link];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [self parseJSON:jsonData];
    }];
    [dataTask resume];
}

-(void)parseJSON:(NSDictionary*)json{
    NSDictionary *response = [json objectForKey:@"response"];
    _posts = [response objectForKey:@"posts"];
//    for (NSDictionary *dict in _posts){
//       NSLog(@"date: %@", [dict objectForKey:@"date"]);
//        NSLog(@"timestamp: %@", [dict objectForKey:@"timestamp"]);
//    }
//    NSLog(@"posts: %@", _posts.debugDescription);
    for (NSInteger x = 0; x < _posts.count; x++) {
        [[KTPostStore sharedStore]setPosts:[_posts objectAtIndex:x] withSequence:x];
    }
    [[KTPostStore sharedStore]saveChanges];
    [[self completionDelegate] finishedDownloadingPosts];
}

@end
