//
//  ViewController.m
//  SRIndexView
//
//  Created by Mag1cPanda on 2016/12/7.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "ViewController.h"
#import "SRIndexView.h"
//#import "SRIndexController.h"
#import "TestViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *indexArr;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"SRIndexView";
    self.automaticallyAdjustsScrollViewInsets = false;
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH - 40, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.showsVerticalScrollIndicator = NO;
    table.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:table];
    
    indexArr = [NSMutableArray new];
    for (int i = 0; i < 26; i ++)
    {
        unichar ch = 65 + i;
        NSString * str = [NSString stringWithUTF8String:(char *)&ch];
        [indexArr addObject:str];
    }
    
    SRIndexView *indexView = [[SRIndexView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 100, 40, SCREEN_HEIGHT - 140) indexArray:indexArr];
    [self.view addSubview:indexView];
    
    [indexView selectIndexBlock:^(NSInteger section)
     {
         [table selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]
                                 animated:NO
                           scrollPosition:UITableViewScrollPositionTop];
     }];
    
//    [self gcdTimerTest];
}

- (IBAction)buttonClicked:(id)sender {
//    SRIndexController *vc = [SRIndexController new];
    TestViewController *vc = [TestViewController new];
    vc.indexArr = indexArr;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)gcdTimerTest
{
    //*  DISPATCH_SOURCE_TYPE_TIMER 事件源的类型
    //*  dispatch_get_main_queue    在哪个线程上执行
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    
    /**
     * @param start 控制计时器第一次触发的时刻
     * @param interval 每隔多长时间执行一次
     * @param leeway 误差值，0表示最小误差，值越小性能消耗越大
     */
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    /**
     *  事件处理的回调
     */
    __block NSInteger second = 0;
    dispatch_source_set_event_handler(timer, ^{
        
        NSLog(@"Test");
        
        second++;
        
        if (second == 5) {
            //取消定时器
            dispatch_cancel(timer);
        }
        
    });
    /**
     *  Dispatch source启动时默认状态是挂起的，我们创建完毕之后得主动恢复，否则事件不会被传递，也不会被执行
     */
    dispatch_resume(timer);
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return indexArr[section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 26;
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
