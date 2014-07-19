//
//  CHMainViewController.m
//  CHPaperMenuController
//
//  Created by Christian Hatch on 6/21/14.
//  Copyright (c) 2014 Christian Hatch. All rights reserved.
//

#import "CHPaperMenuController.h"
#import <pop/POP.h>
#import <Tweaks/FBTweakInline.h>

NSString * const CHPaperMenuControllerID = @"CHPaperMenuController";


#define CHPaperMenuControllerSpringBounciness       FBTweakValue(@"Animations", @"Springs", @"Bounciness", 4.0f, 0.0f, 20.0f)
#define CHPaperMenuControllerSpringSpeed            FBTweakValue(@"Animations", @"Springs", @"Speed", 12.0f, 0.0f, 20.0f)


@interface CHPaperMenuController ()

@property (nonatomic, readonly) UIViewController <CHPaperMenuControllerViewControllerProtocol> *backViewController;

@property (nonatomic, strong) UIWindow *frontWindow;
@property (nonatomic, strong) UIWindow *backWindow;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

///Sets whether or not the front view is enabled when the menu is open.
@property (nonatomic, assign) BOOL disablesFrontVCWhenOpen;

@end

@implementation CHPaperMenuController
{
    CGPoint panStartOrigin;
}


#pragma mark - Init

+ (instancetype)paperMenuControllerWithFrontWindow:(UIWindow *)frontWindow backWindow:(UIWindow *)backWindow
{
    CHPaperMenuController *apm = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:CHPaperMenuControllerID];
    apm.frontWindow = frontWindow;
    apm.backWindow = backWindow;
    return apm;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.disablesFrontVCWhenOpen = YES;
    self.panningEnabled = YES;
    
    [self setNavigationBarHidden:YES animated:NO];
    [self addDropShadowToWindow:self.frontWindow];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self addGestureRecognizerToFrontViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Public API

- (void)openOrCloseAnimated:(BOOL)animated
{
    if (self.isOpen)
    {
        [self closeAnimated:YES velocity:5];
    }
    else
    {
        [self openAnimated:YES velocity:5];
    }
}

- (void)setFrontViewController:(UIViewController <CHPaperMenuControllerViewControllerProtocol> *)frontViewController
                      animated:(BOOL)animated
              finalStateIsOpen:(BOOL)isOpen
{
    if (frontViewController || ![frontViewController conformsToProtocol:@protocol(CHPaperMenuControllerViewControllerProtocol)])
    {
        self.panGestureRecognizer = nil;
        [self addGestureRecognizerToFrontViewController];
        
        if (animated)
        {
            [self moveFrontWindowOutOfViewAnimated:animated
                                      executeBlock:^{
                                          [self setViewControllers:@[frontViewController] animated:NO];
                                      }
                                   andFinishOpened:isOpen];
        }
        
        [self setViewControllers:@[frontViewController] animated:NO];
    }
    else
    {
        NSLog(@"FrontViewController must be non-nil. Failed attempting to set %@ on %@", frontViewController, NSStringFromClass([self class]));
    }
}



#pragma mark - Private

#pragma mark - Open/Close/Pan

- (void)handlePanGesture:(UIPanGestureRecognizer *)pan
{
    if (self.isPanningEnabled)
    {
        CGPoint translation = [pan translationInView:self.frontWindow];
        CGPoint velocity = [pan velocityInView:self.frontWindow];
        
        switch (pan.state)
        {
            case UIGestureRecognizerStateBegan:
            {
                panStartOrigin = self.frontWindow.frame.origin;
                
            }break;
            case UIGestureRecognizerStateChanged:
            {
                self.frontWindow.transform = CGAffineTransformMakeTranslation(0, translation.y);
                //            DDLogDebug(@"translation %f", translation.y);
                //            DDLogDebug(@"origin %f", self.frontWindow.frame.origin.y);
                
            }break;
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            {
                BOOL hasDownVelocity = velocity.y >= 0;
                BOOL windowIsPastHalfWayDown = self.frontWindow.frame.origin.y > CGRectGetMidY(self.frontWindow.frame);
                BOOL isPullingFrontVCDown = panStartOrigin.y < self.frontWindow.frame.origin.y;
                
                NSLog(@"hasDownVelocity: %@", @(hasDownVelocity));
                NSLog(@"windowIsPastHalfWayDown: %@", @(windowIsPastHalfWayDown));
                NSLog(@"isPullingFrontVCDown: %@", @(isPullingFrontVCDown));
                
                
                if (hasDownVelocity)
                {
                    [self openAnimated:YES velocity:velocity.y];
                }
                else
                {
//                    [self closeAnimated:YES velocity:velocity.y];
                }
                
            }break;
            default:
                break;
        }
    }
}

- (void)closeAnimated:(BOOL)animated velocity:(CGFloat)velocity
{
    [self notifyVCsOfCallbackSelector:@selector(paperMenuControllerWillClose:)];
    
    [self.frontViewController enableUI:YES];
    
    if (animated)
    {
        POPSpringAnimation *transform = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
        transform.velocity = @(velocity);
        transform.springBounciness = CHPaperMenuControllerSpringBounciness;
        transform.springSpeed = CHPaperMenuControllerSpringSpeed;
        transform.toValue = @(0);
        //        [transform setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        //            self.frontWindow.frame = [self frameForClosedPosition];
        //        }];
        [self.frontWindow.layer pop_addAnimation:transform forKey:@"transformClose"];
    }
    else
    {
        self.frontWindow.frame = [self frameForClosedPosition];
    }
    
    [self notifyVCsOfCallbackSelector:@selector(paperMenuControllerDidClose:)];
    
    [self addGestureRecognizerToFrontViewController];
}

- (void)openAnimated:(BOOL)animated velocity:(CGFloat)velocity
{
    [self notifyVCsOfCallbackSelector:@selector(paperMenuControllerWillOpen:)];
    
    if (self.disablesFrontVCWhenOpen)
    {
        [self.frontViewController enableUI:NO];
    }
    
    if (animated)
    {
        POPSpringAnimation *transform = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
        transform.velocity = @(velocity);
        transform.springBounciness = CHPaperMenuControllerSpringBounciness;
        transform.springSpeed = CHPaperMenuControllerSpringSpeed;
        transform.toValue = @([self frameForOpenPosition].origin.y);
        [self.frontWindow.layer pop_addAnimation:transform forKey:@"transformOpen"];
    }
    else
    {
        self.frontWindow.frame = [self frameForOpenPosition];
    }
    
    
    [self notifyVCsOfCallbackSelector:@selector(paperMenuControllerDidOpen:)];
    
    [self addGestureRecognizerToFrontViewController];
}



#pragma mark - Private

- (void)moveFrontWindowOutOfViewAnimated:(BOOL)animated
                            executeBlock:(void(^)(void))block
                         andFinishOpened:(BOOL)finishOpened
{
    POPSpringAnimation *moveOffScreen = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
    moveOffScreen.velocity = @(10);
    moveOffScreen.springBounciness = CHPaperMenuControllerSpringBounciness;
    moveOffScreen.springSpeed = CHPaperMenuControllerSpringSpeed;
    moveOffScreen.toValue = @([UIScreen mainScreen].bounds.size.height + kClosedFrontViewControllerHeight/2);
    [moveOffScreen setCompletionBlock:^(POPAnimation *anim, BOOL finished)
     {
         if (finished)
         {
             finishOpened ? [self openAnimated:animated velocity:10] : [self closeAnimated:animated velocity:10];
             
         }
     }];
    
    [self.frontWindow.layer pop_addAnimation:moveOffScreen forKey:@"transformClose"];
}

- (UIWindow *)addDropShadowToWindow:(UIWindow *)window
{
    window.layer.shadowRadius = 5.0f;
    window.layer.shadowOffset = CGSizeMake(0,0);
    window.layer.shadowColor = [UIColor blackColor].CGColor;
    window.layer.shadowOpacity = .9f;
    return window;
}

- (void)addGestureRecognizerToFrontViewController
{
    if (self.isPanningEnabled)
    {
        if ([self.frontViewController respondsToSelector:@selector(viewForPanGesture)])
        {
            self.panGestureRecognizer = nil;
            
            UIView *view = self.frontViewController.viewForPanGesture;
            
            if (view)
            {
                [view addGestureRecognizer:self.panGestureRecognizer];
            }
        }
    }
    else
    {
        self.panGestureRecognizer = nil;
    }
}

- (void)notifyVCsOfCallbackSelector:(SEL)selector
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    for (UIViewController *vc in @[self.frontViewController, self.backViewController])
    {
        if ([vc respondsToSelector:selector])
        {
            [vc performSelector:selector withObject:self];
        }
    }
#pragma clang diagnostic pop
}


#pragma mark - Setters

- (void)setPanningEnabled:(BOOL)panningEnabled
{
    _panningEnabled = panningEnabled;
    
    if (_panningEnabled)
    {
        [self addGestureRecognizerToFrontViewController];
    }
    else
    {
        self.panGestureRecognizer = nil;
    }
}


#pragma mark - Getters

- (CGRect)frameForClosedPosition
{
    return [UIScreen mainScreen].bounds;
}

- (CGRect)frameForOpenPosition
{
    CGRect openFrame = [UIScreen mainScreen].bounds;
    openFrame.origin.y = [UIScreen mainScreen].bounds.size.height - kClosedFrontViewControllerHeight;
    return openFrame;
}

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

- (UIViewController *)backViewController
{
    return self.backWindow.rootViewController;
}

- (BOOL)isOpen
{
    return self.frontWindow.frame.origin.y != CGPointZero.y;
}

- (BOOL)disablesFrontVCWhenOpen
{
    return YES;
}




@end
