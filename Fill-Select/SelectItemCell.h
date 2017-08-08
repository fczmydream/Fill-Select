//
//  SelectItemCell.h
//  
//
//  Created by fcz on 2017/7/17.
//  Copyright © 2017年 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectItemCell : UITableViewCell

- (void)setItemValue:(NSString *)value selected:(BOOL)b isLast:(BOOL)last;

@end
