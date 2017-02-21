//
//  SRIndexController.m
//  SRIndexView
//
//  Created by Mag1cPanda on 2016/12/8.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "SRIndexController.h"
#import "SRIndexView.h"

@interface SRIndexController ()
<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    SRIndexView *indexView;
}
@end

@implementation SRIndexController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH - 40, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.showsVerticalScrollIndicator = NO;
    table.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:table];
    
    indexView = [[SRIndexView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 100, 40, SCREEN_HEIGHT - 140) indexArray:_indexArr];
    [self.view addSubview:indexView];
    
    [indexView selectIndexBlock:^(NSInteger section)
     {
         [table selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]
                            animated:NO
                      scrollPosition:UITableViewScrollPositionTop];
     }];
}

-(void)setIndexArr:(NSArray *)indexArr
{
    _indexArr = indexArr;
    [table reloadData];
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _indexArr[section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _indexArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithRed:35/255.0 green:94/255.0 blue:44/255.0 alpha:1.0];
    
    return cell;
}


@end
