//
//  KTPostCell.m
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 7/1/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "KTPostCell.h"

@implementation KTPostCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    
    _color = [color copy];
    
    self.slugTextView.backgroundColor = self.color;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)reblogButtonPressed:(id)sender {
    [[self delegate] loadReblogger:self.rebloggerNameLabel.text];
}
@end
