//
//  CHMainViewController.h
//  CHPaperMenuController
//
//  Created by Christian Hatch on 6/21/14.
//  Copyright (c) 2014 Christian Hatch. All rights reserved.
//

@class CHPaperMenuController;

@protocol CHPaperMenuControllerViewControllerProtocol <NSObject>
@required
///Easy access to the paper menu controller.
- (CHPaperMenuController *)paperMenuController;

///Enables the enabling or disabling of the front viewcontroller by the
- (void)enableUI:(BOOL)enable;

@optional
///The view to attach the pan gesture to. Usually this is self.view, or a custom 'grabber' view. If method returns nil, panning will not be enabled.
- (UIView *)viewForPanGesture;



- (void)paperMenuControllerWillOpen:(CHPaperMenuController *)menuController;
- (void)paperMenuControllerWillClose:(CHPaperMenuController *)menuController;

- (void)paperMenuControllerDidOpen:(CHPaperMenuController *)menuController;
- (void)paperMenuControllerDidClose:(CHPaperMenuController *)menuController;

@end





#define kClosedFrontViewControllerHeight 60



@interface CHPaperMenuController : UINavigationController

+ (instancetype)paperMenuControllerWithFrontWindow:(UIWindow *)window
                                        backWindow:(UIWindow *)backWindow;



#pragma mark - Methods

///Opens or closes the front window depending on whether it is currently opened or closed.
-(void)openOrCloseAnimated:(BOOL)animated;


/**
 Sets a new front view controller.
 
 @param viewController The UIViewController to be the new front view controller. Must conform to @CHPaperMenuControllerFrontPageProtocol.
 @param animated       Sets whether to animate the operation or perform it without animation.
 @param isOpen         Sets whether the operation will finish with the controller open or closed.
 */
- (void)setFrontViewController:(UIViewController <CHPaperMenuControllerViewControllerProtocol> *)viewController
                      animated:(BOOL)animated
              finalStateIsOpen:(BOOL)isOpen;


#pragma mark - Properties

@property (nonatomic, readonly) UIViewController <CHPaperMenuControllerViewControllerProtocol> *frontViewController;

///Indicates whether the menu is open.
@property (nonatomic, readonly, getter = isOpen) BOOL open;

@property (nonatomic, assign, getter = isPanningEnabled) BOOL panningEnabled;

@end




