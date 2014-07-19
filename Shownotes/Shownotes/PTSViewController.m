//
//  PTSViewController.m
//  Shownotes
//
//  Created by Thomas Denney on 19/07/2014.
//  Copyright (c) 2014 Programming Thomas. All rights reserved.
//

#import "PTSViewController.h"

@interface PTSViewController ()

@property UIView * scrollViewContainer;
@property UIScrollView * artworkScrollView;
@property UIImageView * artworkImageView;
@property UIWebView * shownotesWebview;

@end

@implementation PTSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    
    self.scrollViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    self.scrollViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollViewContainer];
    
    self.artworkScrollView = [[UIScrollView alloc] initWithFrame:self.scrollViewContainer.bounds];
    self.artworkScrollView.showsHorizontalScrollIndicator = NO;
    self.artworkScrollView.showsVerticalScrollIndicator = NO;
    [self.scrollViewContainer addSubview:self.artworkScrollView];
    
    self.artworkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Artwork"]];
    [self.artworkScrollView addSubview:self.artworkImageView];
    
    self.shownotesWebview = [[UIWebView alloc] initWithFrame:self.scrollViewContainer.bounds];
    self.shownotesWebview.scrollView.contentInset = UIEdgeInsetsMake(320, 0, 0, 0);
    self.shownotesWebview.scrollView.delegate = self;
    self.shownotesWebview.opaque = NO;
    self.shownotesWebview.backgroundColor = [UIColor clearColor];
    self.shownotesWebview.scrollView.backgroundColor = [UIColor clearColor];
    [self.shownotesWebview loadRequest:[[NSURLRequest alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"Shownotes" withExtension:@"html"]]];
    [self.scrollViewContainer addSubview:self.shownotesWebview];
    
    //Configure constraints
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_scrollViewContainer]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollViewContainer)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollViewContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scrollViewContainer attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollViewContainer attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.artworkScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollViewContainer.frame), self.shownotesWebview.scrollView.contentOffset.y + self.shownotesWebview.scrollView.contentSize.height);
    
    CGFloat miniSize = CGRectGetWidth(self.view.frame) / 3;
    
    if (scrollView.contentOffset.y < 0) {
        CGFloat size = miniSize;
        if (scrollView.contentOffset.y < -miniSize) {
            CGFloat offset = scrollView.contentOffset.y + 320;
            CGFloat fraction = 1 - offset / (320 - miniSize);
            size = fraction * (320 - miniSize) + miniSize;
        }
        self.artworkImageView.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - size, 0, size, size);
        self.artworkScrollView.contentOffset = CGPointZero;
    }
    else {
        self.artworkScrollView.contentOffset = scrollView.contentOffset;
    }
}

@end
