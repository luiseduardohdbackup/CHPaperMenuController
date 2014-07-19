//
//  CHBackViewController.m
//  CHPaperMenuController
//
//  Created by Christian Hatch on 6/21/14.
//  Copyright (c) 2014 Christian Hatch. All rights reserved.
//

#import "CHBackViewController.h"
#import "CHFrontViewController.h"

NSString * const CHBackViewControllerID = @"CHBackViewController"; 

@interface CHBackViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *exampleItems;

@end

@implementation CHBackViewController



+ (instancetype)backViewController
{
    CHBackViewController *bck = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CHBackViewController"];
    return bck;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.exampleItems = @[@"First Cell",@"Second Cell",@"Third Cell",@"Fourth Cell",@"Fifth Cell",@"Sixth Cell"];
   
    [self.table reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Data Source 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.exampleItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    UIImageView *img = (UIImageView*)[cell viewWithTag:10];
    
    if (indexPath.row == 0)
    {
        [img setImage:[UIImage imageNamed:@"profile.jpg"]];
    }
    else
    {
        [img setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld", (long)indexPath.row]]];
    }
    
    UILabel *lbl = (UILabel *)[cell viewWithTag:11];
    lbl.text = self.exampleItems[indexPath.row];
    return  cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    view.backgroundColor = UIColor.clearColor;

    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 50)];
    
    lbl.text = @"Powered by Christian Hatch";
    lbl.font = [UIFont systemFontOfSize:15];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor = UIColor.whiteColor;
    
    [view addSubview:lbl];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
