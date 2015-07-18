//
//  ViewController.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/2/9.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "ViewController.h"
#import "DandelionViewController.h"

static NSString* KUNG_FU_CELL_REUSE_ID = @"kung_fu_cell";
@interface ViewController ()
{
    NSArray* kungfuDemos;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* demoInfoPath = [[NSBundle mainBundle] pathForResource:@"KungFu" ofType:@"plist"];
    NSDictionary* dataDic = [NSDictionary dictionaryWithContentsOfFile:demoInfoPath];
    kungfuDemos = [dataDic objectForKey:@"demos"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:KUNG_FU_CELL_REUSE_ID];
    
    self.view.layer.cornerRadius = 8;
    self.view.layer.masksToBounds = YES;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kungfuDemos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:KUNG_FU_CELL_REUSE_ID forIndexPath:indexPath];
    NSString* numberStr = [NSString stringWithFormat:@" %@ ", @(indexPath.row)];
    NSString* title = [kungfuDemos[indexPath.row] objectForKey:@"title"];
    cell.textLabel.text = [numberStr stringByAppendingString:title];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController* vc = nil;
    NSString* vcName = [kungfuDemos[indexPath.row] objectForKey:@"viewControllerName"];
    if (vcName) {
        Class VcCls = NSClassFromString(vcName);
        vc = [[VcCls alloc] init];
    } else {
        vc = [[UIViewController alloc] init];
        NSString* viewName = [kungfuDemos[indexPath.row] objectForKey:@"viewName"];
        Class ViewCls = NSClassFromString(viewName);
        UIView* view = [[ViewCls alloc] initWithFrame:vc.view.bounds];
        [vc.view addSubview:view];
    }
    vc.title = [kungfuDemos[indexPath.row] objectForKey:@"title"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
