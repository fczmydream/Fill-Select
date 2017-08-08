//
//  SettingView.h
//
//
//  Created by fcz on 2017/7/17.
//  Copyright © 2017年 ZKR. All rights reserved.
//

typedef NS_ENUM(NSInteger, SettingViewType) {
    SettingViewText,
    SettingViewSelect
};

typedef NS_ENUM(NSInteger, FieldTypeId) {
    FieldTypeNumeric,
    FieldTypeString,
    FieldTypeDate,
    FieldTypeTime
};

#import <UIKit/UIKit.h>

@interface SettingView : UIView

@property (nonatomic,copy) BasicBlock cancelBlock;

- (id)initWithFrame:(CGRect)frame sureAction:(ObjBlock)sureAction;

- (id)initWithFrame:(CGRect)frame selectAction:(ObjBlock)selectAction;

- (void)setFillTitle:(NSString *)title;

- (void)setKeyboradNumber;

- (void)setFieldType:(NSInteger)typeId;

- (void)setBackAlpha:(CGFloat)alpha;

- (void)showAnimation;

- (void)showAnimationWithValue:(id)obj;

- (void)reloadSelectView:(NSArray *)selects andRow:(NSInteger)row;

@end
