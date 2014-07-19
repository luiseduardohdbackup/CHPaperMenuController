//
//  CHMainViewController.h
//  CHPaperMenuController
//
//  Created by Christian Hatch on 6/21/14.
//  Copyright (c) 2014 Christian Hatch. All rights reserved.
//

@protocol CHPaperMenuControllerFrontPageProtocol <NSObject>

@optional
///The view to attach the pan gesture to. Usually this is @property self.view. If method returns nil, panning will not be enabled. 
- (UIView *)viewForPanGesture;

@end

@interface CHPaperMenuController : UINavigationController

+ (instancetype)appMenuControllerWithFrontWindow:(UIWindow *)window;

-(void)openOrClose;


@property (nonatomic, readonly) UIViewController <CHPaperMenuControllerFrontPageProtocol> *frontViewController;

///Sets a new front view controller, optionally animating the operation.
- (void)setFrontViewController:(UIViewController /*<CHPaperMenuControllerFrontPageProtocol> */ *)viewController
                      animated:(BOOL)animated;


@end
