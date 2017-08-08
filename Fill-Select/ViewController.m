//
//  ViewController.m
//  Fill-Select
//
//  Created by fcz on 2017/8/8.
//  Copyright © 2017年 com.TulipSport. All rights reserved.
//

#import "ViewController.h"
#import "FProgressView.h"
#import "SettingView.h"

@interface ViewController ()

@property (nonatomic,strong) FProgressView *progressView;
@property (nonatomic,strong) SettingView *setFillView;
@property (nonatomic,strong) SettingView *setSelectView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"Fill & Select";
    self.view.backgroundColor = [UIColor whiteColor];
    
    __unsafe_unretained typeof(self) vc = self;
    _progressView = [[FProgressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) cancelAction:^{
        [vc.progressView dismiss];
    }];
    [_progressView setProgressTitle:@"设置" andProgress:@"获取中..."];
    [_progressView setProgressAlpha:0.3];
    [_progressView showProgress];
    double delayInSeconds = 0.6;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_progressView showResult:@"完成"];
    });

    
    _setFillView = [[SettingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) sureAction:^(id obj) {
        
    }];
    _setSelectView = [[SettingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) selectAction:^(id obj) {
        
    }];
    
    UIButton *fillButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fillButton.frame = CGRectMake(SCREEN_WIDTH/2-100, 130, 100, 50);
    [fillButton setTitle:@"FillButton" forState:UIControlStateNormal];
    [fillButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [fillButton.titleLabel setFont:Font(13)];
    [fillButton addTarget:self action:@selector(fillAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fillButton];
    
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton.frame = CGRectMake(SCREEN_WIDTH/2, 130, 100, 50);
    [selectButton setTitle:@"SelectButton" forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectButton.titleLabel setFont:Font(13)];
    [selectButton addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectButton];
}

- (void)fillAction
{
    [_setFillView setFillTitle:@"Fill"];
    [_setFillView showAnimationWithValue:@"默认值"];
}

- (void)selectAction
{
    [_setSelectView setFillTitle:@"Select"];
    [_setSelectView showAnimation];
    
    NSArray *array = @[@"1",@"2",@"3",@"4",@"5"];
    [_setSelectView reloadSelectView:array andRow:1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
