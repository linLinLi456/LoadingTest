//
//  ViewController.m
//  LoadingTest
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "ViewController.h"

#import "LeoLoadingView.h"
#define kDotColor               [UIColor colorWithRed:200/255.0 green:206/255.0 blue:221/255.0 alpha:1.0]

@interface ViewController ()
{
     UILabel *_loadingLabel;
}
@property (strong, nonatomic) IBOutlet LeoLoadingView *loadingView1,*loadingView2;
@end

@implementation ViewController

CGFloat minX(UIView *view) {
    return CGRectGetMinX(view.frame);
}
CGFloat maxY(UIView *view) {
    return CGRectGetMaxY(view.frame);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _loadingView2 = [[LeoLoadingView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [_loadingView2 showView:YES];
    _loadingView2.center = self.view.center;
    _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(minX(_loadingView2), maxY(_loadingView2)+10, 100, 40)];
    _loadingLabel.text = @"Loading...";
    _loadingLabel.textColor = kDotColor;
    _loadingLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:_loadingLabel];
    [self.view addSubview:_loadingView2];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
