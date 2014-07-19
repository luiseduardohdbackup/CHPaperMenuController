//
//  CHBackViewController.h
//  CHPaperMenuController
//
//  Created by Christian Hatch on 6/21/14.
//  Copyright (c) 2014 Christian Hatch. All rights reserved.
//


@interface CHBackViewController : UIViewController 

+ (instancetype)backViewController; 

@property (nonatomic, strong) IBOutlet UITableView *table;

@end
