//
//  CHFrontViewController.m
//  CHPaperMenuController
//
//  Created by Christian Hatch on 6/21/14.
//  Copyright (c) 2014 Christian Hatch. All rights reserved.
//

#import "CHFrontViewController.h"
#import "PaperButton.h"

@interface CHFrontViewController ()
@property (nonatomic, strong) PaperButton *paperButton;
@property (nonatomic, strong) UIView *panningView;
@end

@implementation CHFrontViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.view addSubview:self.panningView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleButtonTapped:(id)sender
{
//    UIViewController *vc = [[UIViewController alloc] init];
//    vc.view.backgroundColor = [UIColor redColor];
//    
//    [self.appMenuController setFrontViewController:vc animated:YES];
    [self.appMenuController openOrClose];
}

#pragma mark - Getters

- (CHPaperMenuController *)appMenuController
{
    CHPaperMenuController *menu = (CHPaperMenuController *)self.navigationController;
    return menu;
}

- (PaperButton *)paperButton
{
    if (!_paperButton) {
        _paperButton = [PaperButton buttonWithOrigin:CGPointZero];
        [_paperButton addTarget:self action:@selector(handleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _paperButton;
}

- (UIView *)panningView
{
    if (!_panningView) {
        _panningView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _panningView.backgroundColor = UIColor.clearColor;
        self.paperButton.center = _panningView.center;
        [_panningView addSubview:self.paperButton];
    }
    return _panningView;
}


- (UIView *)viewForPanGesture
{
    return self.panningView;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
