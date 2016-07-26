//
//  JWPageControl.h
//  JWPageControl_demo
//
//  Created by 朱建伟 on 16/5/30.
//  Copyright © 2016年 com.zjw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWPageControl : UIControl

/**
 *  一共有多少页
 */
@property(nonatomic) NSInteger numberOfPages;

/**
 *  当前页面
 */
@property(nonatomic) NSInteger currentPage;
/**
 *  只有一个选项 隐藏  默认 NO
 */
@property(nonatomic) BOOL hidesForSinglePage;

 
/**
 *  返回Size 返回控件的实际尺寸
 */
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;

/**
 *  未选中的颜色
 */
@property(nullable, nonatomic,strong) UIColor *pageIndicatorTintColor;

/**
 *  选中的颜色
 */
@property(nullable, nonatomic,strong) UIColor *currentPageIndicatorTintColor;


@end
