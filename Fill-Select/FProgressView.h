//
//  FProgressView.h
//  
//
//  Created by fcz on 2017/7/15.
//  Copyright © 2017年 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FProgressView : UIView

- (id)initWithFrame:(CGRect)frame cancelAction:(BasicBlock)cancel;

- (void)setProgressTitle:(NSString *)title andProgress:(NSString *)progress;

- (void)setProgressAlpha:(CGFloat)alpha;

- (void)showProgress;

- (void)showProgressValue:(NSString *)progress;

- (void)showResult:(NSString *)result;

- (void)dismiss;

@end
