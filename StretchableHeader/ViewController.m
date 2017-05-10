//
//  ViewController.m
//  StretchableHeader
//
//  Created by hechao on 17/5/10.
//  Copyright © 2017年 hc. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+StretchableHeader.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *stretchableHeaderTable;

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action



#pragma mark - Http



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL_ID"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




#pragma mark - Private Methods



#pragma mark - UI

- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //add subview
    [self.view addSubview:self.stretchableHeaderTable];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];
    header.backgroundColor = [UIColor purpleColor];
    self.stretchableHeaderTable.stretchableHeader = header;
    //set frame
}

#pragma mark - Getter && Setter

- (UITableView *)stretchableHeaderTable
{
    if (_stretchableHeaderTable == nil)
    {
        _stretchableHeaderTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
        _stretchableHeaderTable.dataSource = self;
        _stretchableHeaderTable.delegate = self;
        _stretchableHeaderTable.rowHeight = 88.0f;
    }
    
    return _stretchableHeaderTable;
}


@end
