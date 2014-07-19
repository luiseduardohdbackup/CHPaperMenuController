//
//  CHMainViewController.m
//  CHPaperMenuController
//
//  Created by Christian Hatch on 6/21/14.
//  Copyright (c) 2014 Christian Hatch. All rights reserved.
//

#import "CHPaperMenuController.h"
#import <pop/POP.h>

#define DefaultAnimationDuration 0.35f * 1.2
#define kHeaderHeight 60

NSString * const CHPaperMenuControllerID = @"CHPaperMenuController"; 

@interface CHPaperMenuController ()

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation CHPaperMenuController
{
    float firstX;
    float firstY;
    CGPoint _origin;
    CGPoint _final;
}

#pragma mark - Init

+ (instancetype)appMenuControllerWithFrontWindow:(UIWindow *)window
{
    CHPaperMenuController *apm = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:CHPaperMenuControllerID];
    apm.window = window; 
    return apm;
}

- (instancetype)initWithFrontWindow:(UIWindow *)window
{
    self = [super init];
    if (self) {
        self.window = [self addDropShadowToWindow:window];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationBarHidden:YES animated:NO]; 
    [self addGestureRecognizerToFrontViewController:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Public API


- (void)openOrClose
{
    //calculate the frame of the front window --> either in the 'normal' position or in the 'down' position
    CGPoint finalOrigin;
    CGRect f = self.window.frame;
    
    if (f.origin.y == CGPointZero.y)
        finalOrigin.y = CGRectGetHeight([UIScreen mainScreen].bounds) - kHeaderHeight;
    else
        finalOrigin.y = CGPointZero.y;
    
    finalOrigin.x = 0;
    f.origin = finalOrigin;
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.window.transform = CGAffineTransformIdentity;
                         self.window.frame = f;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
    
}



- (void)handlePanGesture:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:self.window];
    CGPoint velocity = [pan velocityInView:self.window];
    
    switch (pan.state) {
            
        case UIGestureRecognizerStateBegan:
            
            _origin = self.window.frame.origin;
            
            break;
        case UIGestureRecognizerStateChanged:
            
            if (_origin.y + translation.y >= 0){
                
                if(self.window.frame.origin.y != CGPointZero.y)
                    self.window.transform = CGAffineTransformMakeTranslation(0, translation.y);
                else
                    self.window.transform = CGAffineTransformMakeTranslation(0, translation.y);
                
            }
            
            break;
        case UIGestureRecognizerStateEnded:
            
        case UIGestureRecognizerStateCancelled:
        {
            CGPoint finalOrigin = CGPointZero;
            if (velocity.y >= 0) {
                finalOrigin.y = CGRectGetHeight([UIScreen mainScreen].bounds) - kHeaderHeight;
            }
            
            CGRect f = self.window.frame;
            f.origin = finalOrigin;
            [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.window.transform = CGAffineTransformIdentity;
                                 self.window.frame = f;
                                 
                             } completion:^(BOOL finished) {
                                 
                             }];
            
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - Private

- (UIWindow *)addDropShadowToWindow:(UIWindow *)window
{
    window.layer.shadowRadius = 5.0f;
    window.layer.shadowOffset = CGSizeMake(0,0);
    window.layer.shadowColor = [UIColor blackColor].CGColor;
    window.layer.shadowOpacity = .9f;
    return window;
}

- (void)addGestureRecognizerToFrontViewController:(BOOL)onlyNavigation
{
    
    if ([self.frontViewController respondsToSelector:@selector(viewForPanGesture)])
    {
        UIView *view = self.frontViewController.viewForPanGesture;
        
        if (view)
        {
            [view addGestureRecognizer:self.panGestureRecognizer];
        }
    }
}

#pragma mark - Getters

- (UIPanGestureRecognizer *)panGestureRecognizer
{
    if (!_panGestureRecognizer)
    {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    }
    return _panGestureRecognizer;
}

- (UIViewController *)frontViewController
{
    return self.viewControllers.firstObject;
}

#pragma mark - Setters

- (void)setFrontViewController:(UIViewController <CHPaperMenuControllerFrontPageProtocol> *)frontViewController animated:(BOOL)animated
{
    if (frontViewController) // || ![frontViewController conformsToProtocol:@protocol(CHPaperMenuControllerFrontPageProtocol)])
    {
        if (animated)
        {
            [self pullWindowOutOfViewExecuteBlockAndReturnWindow:^{
                [self setViewControllers:@[frontViewController] animated:NO];
            }];
        }
        [self setViewControllers:@[frontViewController] animated:NO];
    }
    else
    {
        NSLog(@"FrontViewController must be non-nil. Failed attempting to set %@ on %@", frontViewController, NSStringFromClass([self class]));
    }
}



- (void)pullWindowOutOfViewExecuteBlockAndReturnWindow:(void(^)(void))block
{
    CGRect originalFrame = self.window.frame;
    
    CGRect offScreenFrame = self.window.frame;
    offScreenFrame.origin.y = [UIScreen mainScreen].bounds.size.height;
    
    
    [UIView animateWithDuration:DefaultAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.window.frame = offScreenFrame;
                    }
                     completion:^(BOOL finished){
                        if (block) {
                            block();
                        }
                         [UIView animateWithDuration:DefaultAnimationDuration animations:^{
                            self.window.frame = originalFrame;
                        } completion:nil];
    }];
}



@end
