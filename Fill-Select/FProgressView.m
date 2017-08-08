//
//  FProgressView.m
//  
//
//  Created by fcz on 2017/7/15.
//  Copyright © 2017年 ZKR. All rights reserved.
//

#define backProgressWidth 250

#import "FProgressView.h"

@interface FProgressView ()

@property (nonatomic,strong) FView *alphaView;
@property (nonatomic,strong) FView *backView;
@property (nonatomic,strong) FLabel *titleLabel;
@property (nonatomic,strong) FLabel *progressLabel;
@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,copy) BasicBlock cancelBlock;
@property (nonatomic,assign) CGFloat alphaValue;

@end

@implementation FProgressView

- (id)initWithFrame:(CGRect)frame cancelAction:(BasicBlock)cancel
{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = Clear;
        self.cancelBlock = cancel;
        
        _alphaValue = 0.76;
        _alphaView = [[FView alloc] initWithFrame:frame bgColor:Black];
        _alphaView.alpha = 0;
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    CGFloat backW = backProgressWidth;
    CGFloat backH = 122;
    CGFloat leftP = 25;
    if(!_cancelBlock) backH = 75;
    _backView = [[FView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-backW)/2, SCREEN_HEIGHT, backW, backH) bgColor:White];
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 7.0;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_backView];
    
    _titleLabel = [[FLabel alloc] initWithFrame:CGRectMake(leftP, 5, backW-leftP*2, 35) text:@"" alignment:1 textColor:Color(61, 1) font:FontBold(17)];
    [_backView addSubview:_titleLabel];
    
    _progressLabel = [[FLabel alloc] initWithFrame:CGRectMake(leftP, _titleLabel.frame.origin.y+_titleLabel.frame.size.height, backW-leftP*2, 35) text:@"" alignment:1 textColor:RGB(63, 136, 71) font:Font(15)];
    [_backView addSubview:_progressLabel];
    
    if(_cancelBlock){
        FView *sepView = [[FView alloc] initWithFrame:CGRectMake(0, 75, backW, 1) bgColor:Color(215, 1)];
        [_backView addSubview:sepView];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, 77, backW, 45);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:RGB(53, 114, 215) forState:UIControlStateNormal];
        [_cancelButton.titleLabel setFont:Font(17)];
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_cancelButton];
    }
}

- (void)setProgressTitle:(NSString *)title andProgress:(NSString *)progress
{
    _titleLabel.text = title;
    _progressLabel.text = progress;
}

- (void)setProgressAlpha:(CGFloat)alpha
{
    _alphaValue = alpha;
}

- (void)showProgress
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window insertSubview:_alphaView belowSubview:_backView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alphaView.alpha = _alphaValue;
        self.backView.center = self.center;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showProgressValue:(NSString *)progress
{
    _progressLabel.text = progress;
}

- (void)showResult:(NSString *)result
{
    _progressLabel.text = result;
    
    [UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alphaView.alpha = 0;
        CGFloat height = self.backView.frame.size.height;
        self.backView.frame = CGRectMake((SCREEN_WIDTH-backProgressWidth)/2, SCREEN_HEIGHT, backProgressWidth, height);
    } completion:^(BOOL finished) {
        [self.alphaView removeFromSuperview];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alphaView.alpha = 0;
        CGFloat height = self.backView.frame.size.height;
        self.backView.frame = CGRectMake((SCREEN_WIDTH-backProgressWidth)/2, SCREEN_HEIGHT, backProgressWidth, height);
    } completion:^(BOOL finished) {
        [self.alphaView removeFromSuperview];
    }];
}

- (void)cancelAction
{
    if(_cancelBlock) _cancelBlock();
}

- (void)dealloc
{
    NSLog(@"FProgressView dealloc...");
}


@end
