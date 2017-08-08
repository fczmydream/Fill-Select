//
//  SettingView.m
//  
//
//  Created by fcz on 2017/7/17.
//  Copyright © 2017年 ZKR. All rights reserved.
//

#define backSettingWidth 250
#define PickerHeight 210

#import "SettingView.h"
#import "SelectItemCell.h"

@interface SettingView () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,assign) SettingViewType type;
@property (nonatomic,strong) id resultValue;

@property (nonatomic,strong) FView *alphaView;
@property (nonatomic,strong) FView *backView;
@property (nonatomic,strong) FLabel *titleLabel;
@property (nonatomic,strong) FView *lineV;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,assign) FieldTypeId fieldId;
@property (nonatomic,strong) UIDatePicker *picker;
@property (nonatomic,strong) UIButton *sureButton;
@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,copy) ObjBlock sureBlock;
@property (nonatomic,copy) ObjBlock selectBlock;
@property (nonatomic,assign) CGFloat alphaValue;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIActivityIndicatorView *spinner;
@property (nonatomic,assign) NSInteger selectRow;

@end

@implementation SettingView

- (id)initWithFrame:(CGRect)frame sureAction:(ObjBlock)sureAction
{
    if(self = [super initWithFrame:frame]){
        [self setBackgroundColor:Clear];
        self.type = SettingViewText;
        self.sureBlock = sureAction;
        
        _alphaValue = 0.3;
        [self createAlphaView:frame];
        [self createTextUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame selectAction:(ObjBlock)selectAction
{
    if(self = [super initWithFrame:frame]){
        [self setBackgroundColor:Clear];
        self.type = SettingViewSelect;
        self.selectBlock = selectAction;
        
        _alphaValue = 0.3;
        [self createAlphaView:frame];
        [self createSelectUI];
        
    }
    return self;
}

- (void)setBackAlpha:(CGFloat)alpha
{
    _alphaValue = alpha;
}

- (void)createAlphaView:(CGRect)frame
{
    UIColor *alphaColor = [Black colorWithAlphaComponent:0];
    _alphaView = [[FView alloc] initWithFrame:frame bgColor:alphaColor];
    _alphaView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [_alphaView addGestureRecognizer:tapGesture];
}

- (void)createTextUI
{
    CGFloat backH = 170.0;
    CGFloat leftP = 25.0;
    CGFloat textW = 130.0f;
    _backView = [[FView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-backSettingWidth)/2, SCREEN_HEIGHT, backSettingWidth, backH) bgColor:White];
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 7.0;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_backView];
    
    _titleLabel = [[FLabel alloc] initWithFrame:CGRectMake(leftP, 15, backSettingWidth-leftP*2, 45) text:@"" alignment:1 textColor:Black font:Font(15)];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [_backView addSubview:_titleLabel];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake((backSettingWidth-textW)/2, _titleLabel.frame.origin.y+_titleLabel.frame.size.height+5, textW, 35)];
    _textField.backgroundColor = Clear;
    _textField.textColor = Black;
    _textField.font = Font(15);
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.adjustsFontSizeToFitWidth = YES;
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeyDone;
    [_backView addSubview:_textField];
    
    _lineV = [[FView alloc] initWithFrame:CGRectMake((backSettingWidth-textW-20)/2, _textField.frame.origin.y+_textField.frame.size.height, textW+20, 1) bgColor:RGB(63, 136, 71)];
    [_backView addSubview:_lineV];
    
    [self addTwoButtons:CGRectMake(_lineV.frame.origin.x-5, _lineV.frame.origin.y+_lineV.frame.size.height+15, 70, 40)];
}

- (void)createSelectUI
{
    CGFloat backH = 230.0;
    CGFloat leftP = 25.0;
    _backView = [[FView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-backSettingWidth)/2, SCREEN_HEIGHT, backSettingWidth, backH) bgColor:Color(241, 1)];
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 7.0;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_backView];
    
    _titleLabel = [[FLabel alloc] initWithFrame:CGRectMake(leftP, 10, backSettingWidth-leftP*2, 45) text:@"" alignment:1 textColor:Black font:Font(17)];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [_backView addSubview:_titleLabel];
    
    FView *sepV = [[FView alloc] initWithFrame:CGRectMake(0, _titleLabel.frame.origin.y+_titleLabel.frame.size.height+10, backSettingWidth, 1) bgColor:Color(205, 1)];
    [_backView addSubview:sepV];
    
    _selectRow = -1;
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, sepV.frame.origin.y+sepV.frame.size.height, backSettingWidth, 90) style:UITableViewStylePlain];
    _tableView.backgroundColor = White;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerClass:[SelectItemCell class] forCellReuseIdentifier:@"SelectItemCell"];
    [_backView addSubview:_tableView];
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.hidesWhenStopped = YES;
    _spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    _spinner.center = _tableView.center;
    [_backView addSubview:_spinner];
    
    _lineV = [[FView alloc] initWithFrame:CGRectMake(0, _tableView.frame.origin.y+_tableView.frame.size.height, backSettingWidth, 1) bgColor:Color(205, 1)];
    [_backView addSubview:_lineV];
    
    [self addTwoButtons:CGRectMake((backSettingWidth-160)/2, _lineV.frame.origin.y+_lineV.frame.size.height+17, 70, 40)];
}

- (void)addTwoButtons:(CGRect)sureFrame
{
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.frame = sureFrame;
    [_sureButton setBackgroundColor:RGB(54, 111, 197)];
    [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [_sureButton setTitleColor:White forState:UIControlStateNormal];
    [_sureButton.titleLabel setFont:Font(15)];
    _sureButton.layer.masksToBounds = YES;
    _sureButton.layer.cornerRadius = 3.0f;
    [_sureButton addTarget:self action:@selector(sureTap:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_sureButton];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(_sureButton.frame.origin.x+_sureButton.frame.size.width+20, _sureButton.frame.origin.y, 70, 40);
    [_cancelButton setBackgroundColor:RGB(54, 111, 197)];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:White forState:UIControlStateNormal];
    [_cancelButton.titleLabel setFont:Font(15)];
    _cancelButton.layer.masksToBounds = YES;
    _cancelButton.layer.cornerRadius = 3.0f;
    [_cancelButton addTarget:self action:@selector(cancelTap:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_cancelButton];
}

- (void)layoutBottomItemView:(CGFloat)bottomH
{
    CGFloat bottomY = SCREEN_HEIGHT - bottomH;
    CGFloat distanceH = (SCREEN_HEIGHT - _backView.frame.size.height) / 2;
    CGFloat space = distanceH - bottomH;
    if(space < 5){
        [UIView animateWithDuration:0.1 animations:^{
            CGRect rect = _backView.frame;
            rect.origin.y = bottomY - _backView.frame.size.height - 5;
            _backView.frame = rect;
        }];
    }
}

- (void)setFillTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (void)setKeyboradNumber
{
    if(!_textField) return;
    
    _textField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)setFieldType:(NSInteger)typeId
{
    if(typeId == 3){
        _fieldId = FieldTypeNumeric;
    }else if(typeId == 4){
        _fieldId = FieldTypeDate;
    }else if(typeId == 10){
        _fieldId = FieldTypeTime;
    }else{
        _fieldId = FieldTypeString;
    }
    
    if(!_textField) return;
    
    if(_fieldId == FieldTypeString){
        _textField.keyboardType = UIKeyboardTypeDefault;
        [self addNotify];
    }else if(_fieldId == FieldTypeNumeric){
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        [self addNotify];
    }else if(_fieldId == FieldTypeDate){
        [self createPicker:FieldTypeDate];
    }else if(_fieldId == FieldTypeTime){
        [self createPicker:FieldTypeTime];
    }
}

- (void)createPicker:(FieldTypeId)typeId
{
    if(!_picker){
        _picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, PickerHeight)];
        _picker.backgroundColor = RGB(197, 201, 211);
        [_picker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [[UIApplication sharedApplication].keyWindow addSubview:_picker];
    }
    
    if(typeId == FieldTypeDate){
        _picker.datePickerMode = UIDatePickerModeDate;
    }else if(typeId == FieldTypeTime){
        _picker.datePickerMode = UIDatePickerModeTime;
    }
}

- (void)showPicker
{
    if(!_picker) return;
    
    [UIView animateWithDuration:0.25 animations:^{
        _picker.frame = CGRectMake(0, SCREEN_HEIGHT-PickerHeight, SCREEN_WIDTH, PickerHeight);
    } completion:^(BOOL finished) {
        
    }];
    
    [self layoutBottomItemView:PickerHeight];
}

- (void)hidePicker
{
    if(!_picker) return;
    
    [UIView animateWithDuration:0.25 animations:^{
        _picker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, PickerHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showAnimation
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window insertSubview:_alphaView belowSubview:_backView];
    
    if(_type == SettingViewSelect){
        [_spinner startAnimating];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alphaView.backgroundColor = [Black colorWithAlphaComponent:self.alphaValue];
        self.backView.center = self.center;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showAnimationWithValue:(id)obj
{
    _resultValue = obj;
    
    NSString *valueHolder = [NSString stringWithFormat:@"%@",obj];
    _textField.text = valueHolder;
    
    [self showAnimation];
}

- (void)dismiss
{
    _resultValue = nil;
    [self hidePicker];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alphaView.backgroundColor = [Black colorWithAlphaComponent:0];
        CGFloat height = self.backView.frame.size.height;
        self.backView.frame = CGRectMake((SCREEN_WIDTH-backSettingWidth)/2, SCREEN_HEIGHT, backSettingWidth, height);
    } completion:^(BOOL finished) {
        [self.alphaView removeFromSuperview];
        if(self.type == SettingViewSelect){
            [self.spinner stopAnimating];
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
        }else{
            [self removeNotify];
            self.textField.text = @"";
        }
    }];
}

- (void)scrollToCenter
{
    if(self.backView.center.y == self.center.y) return;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.backView.center = self.center;
    }];
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    if(_type == SettingViewText){
        [_textField resignFirstResponder];
    }
    
    if(_cancelBlock) _cancelBlock();
    [self dismiss];
}

- (void)sureTap:(UIButton *)button
{
    if(_type == SettingViewText){
        _resultValue = _textField.text;
        [_textField resignFirstResponder];
    }else if(_type == SettingViewSelect){
        if(_selectRow >=0 && _selectRow < _dataArray.count){
            _resultValue = [[_dataArray objectAtIndex:_selectRow] stringValue];
        }
    }
    
    if(_cancelBlock) _cancelBlock();
    
    if(_resultValue && [(NSString *) _resultValue length] > 0){
        if(_sureBlock) _sureBlock(_resultValue);
        if(_selectBlock) _selectBlock(_resultValue);
    }
    
    [self dismiss];
}

- (void)cancelTap:(UIButton *)button
{
    if(_type == SettingViewText){
        [_textField resignFirstResponder];
    }
    
    if(_cancelBlock) _cancelBlock();
    [self dismiss];
}

#pragma mark - UITextField代理

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self scrollToCenter];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(_fieldId == FieldTypeTime || _fieldId == FieldTypeDate){
        [self showPicker];
        return NO;
    }
    return YES;
}

#pragma mark - 监听键盘事件

- (void)keyboardDidShow:(NSNotification *)notification
{    
    CGRect rect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardH = rect.size.height;
    [self layoutBottomItemView:keyBoardH];
}

- (void)dateChanged:(UIDatePicker *)picker
{
    NSDate *selectDate = picker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if(picker.datePickerMode == UIDatePickerModeTime){
        [formatter setDateFormat:@"HH:mm"];
    }else{
        [formatter setDateFormat:@"YYYY-MM-dd"];
    }
    _textField.text = [formatter stringFromDate:selectDate];
}

#pragma mark - UITableView代理

- (void)reloadSelectView:(NSArray *)selects andRow:(NSInteger)row
{
    [_spinner stopAnimating];
    
    _selectRow = row;
    _dataArray = [NSMutableArray arrayWithArray:selects];
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectItemCell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    NSString *name = [NSString stringWithFormat:@"第%ld行",row];
    if(!name) name = @"";
    BOOL selected = NO;
    BOOL lasted = NO;
    
    if(row == _selectRow){
        selected = YES;
    }
    if(row == _dataArray.count - 1){
        lasted = YES;
    }
    [cell setItemValue:name selected:selected isLast:lasted];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(_selectRow == indexPath.row) return;
    _selectRow = indexPath.row;
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

- (void)addNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}

- (void)removeNotify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    NSLog(@"SettingView dealloc...");
}

@end
