//
//  JWAutoScrollViewCell.m
//  SunGuide
//
//  Created by 朱建伟 on 16/4/5.
//  Copyright © 2016年 jryghq. All rights reserved.
//

#import "JWAutoScrollViewCell.h"
@interface JWAutoScrollViewCell()

@end

@implementation JWAutoScrollViewCell
/**
 *   初始化
 */
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self  = [super initWithFrame:frame]) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.bgImageView];
    }
    return self;
}

/**
 *   布局
 */
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bgImageView.frame = self.bounds; 
    
}


@end
