//
//  SelectItemCell.m
//  
//
//  Created by fcz on 2017/7/17.
//  Copyright © 2017年 ZKR. All rights reserved.
//

#import "SelectItemCell.h"

@interface SelectItemCell ()

@property (nonatomic,strong) FLabel *label;
@property (nonatomic,strong) FImageView *imageV;
@property (nonatomic,strong) FView *lineV;

@end

@implementation SelectItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.contentView setBackgroundColor:White];
        [self setSelectionStyle:0];
        
        _imageV = [[FImageView alloc] initWithFrame:CGRectMake(20, 15, 15, 15) contentMode:2 select:nil tag:1];
        [_imageV setImage:[UIImage imageNamed:@"yes"]];
        [self.contentView addSubview:_imageV];
        
        _label = [[FLabel alloc] initWithFrame:CGRectMake(50, 2.5, self.frame.size.width-70, 40) text:@"" alignment:0 textColor:Black font:Font(14)];
        _label.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_label];
        
        _lineV = [[FView alloc] initWithFrame:CGRectMake(15, 44, self.frame.size.width-15, 1) bgColor:Color(205, 1)];
        [self.contentView addSubview:_lineV];
        
    }
    return self;
}

- (void)setItemValue:(NSString *)value selected:(BOOL)b isLast:(BOOL)last
{
    _label.text = value;
    _imageV.hidden = !b;
    _lineV.hidden = last;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
