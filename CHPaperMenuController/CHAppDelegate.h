//
//  CHAppDelegate.h
//  CHPaperMenuController
//
//  Created by Christian Hatch on 6/21/14.
//  Copyright (c) 2014 Christian Hatch. All rights reserved.
//


@interface CHAppDelegate : UIResponder <UIApplicationDelegate>

///The front window, which covers the status bar.
@property (nonatomic, readonly) UIWindow *frontWindow;

///The back window, which holds the tableview.
@property (nonatomic, readonly) UIWindow *backWindow;

@end
