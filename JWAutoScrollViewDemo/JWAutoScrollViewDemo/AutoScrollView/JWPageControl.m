//
//  JWPageControl.m
//  JWPageControl_demo
//
//  Created by 朱建伟 on 16/5/30.
//  Copyright © 2016年 com.zjw. All rights reserved.
//

#define JWPageControlItemW 10//单个选项宽度
#define JWPageControlItemH 5 //当个选项高度
#define JWPageControlH 15  //默认高度
#define JWPageControlPadding 10 //默认间隙


#define KInitTag 100

#import "UIImage+Extension.h"
#import "JWPageControl.h"
@interface JWPageControl()
/**
 *  用于存储布局
 */
@property(nonatomic,strong)UIView *bgView;

/**
 *  当前选中
 */
@property(nonatomic,strong)UIButton *selectedBtn;

@end

@implementation JWPageControl
/**
 *  初始化
 */
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.bgView = [[UIView alloc]init];
        self.bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bgView];
    }
    return self;
}

/**
 *  设置当前选中
 */
-(void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    
    if (currentPage>=self.numberOfPages||(self.hidesForSinglePage&&self.numberOfPages<=1)) {
        return;//越界
    }
    
    if(self.selectedBtn)
    {
        if (self.selectedBtn.tag==currentPage) {
            return;
        }
        self.selectedBtn.selected = NO;
    }
    
    UIButton *btn =  [self.bgView viewWithTag:currentPage+KInitTag];
    if (btn&&[btn isKindOfClass:[UIButton class]]) {
        btn.selected = YES;
        self.selectedBtn = btn;
    }
    
}

/**
 *  设置控件
 */
-(void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    
    NSInteger currentItemsCount = self.bgView.subviews.count;
    
    if (currentItemsCount>numberOfPages) {//如果目前的选项个数多于 设置的选项个数 那么移除
        [[self.bgView.subviews subarrayWithRange:NSMakeRange(numberOfPages, currentItemsCount-numberOfPages)] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
            [view removeFromSuperview];
        }];
    }else//如果目前的选项个数少于 设置的选项个数 那么补充添加
    {
        UIImage *normalImage = [UIImage imageRectWithSize:CGSizeMake(JWPageControlItemH, JWPageControlItemH) andColor:self.pageIndicatorTintColor?self.pageIndicatorTintColor:[UIColor whiteColor] corerRadius:JWPageControlItemH*0.5];
        UIImage *selectedImage = [UIImage imageRectWithSize:CGSizeMake(JWPageControlItemW, JWPageControlItemH) andColor:self.currentPageIndicatorTintColor?self.currentPageIndicatorTintColor:[UIColor redColor] corerRadius:JWPageControlItemH*0.5];
 
        //补全item
        for (NSInteger i = currentItemsCount; i<numberOfPages; i++) {
            UIButton *btn = [[UIButton alloc] init];
            [btn setImage:normalImage forState:UIControlStateNormal];
            [btn setImage:selectedImage forState:UIControlStateSelected];
            btn.tag = i+KInitTag;
//            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];//暂时用不到
            [self.bgView addSubview:btn];
            if (i==0) {
                btn.selected =YES;
                self.selectedBtn = btn;
            }
        }
        
    }
    if(self.hidesForSinglePage&&numberOfPages<=1){
        self.bgView.hidden = YES;
    }else{
        self.bgView.hidden= NO;
        //初始化回0
        self.currentPage = 0;
        [self setNeedsLayout];
    }
}

/**
 *  设置
 */
-(void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    
    _pageIndicatorTintColor = pageIndicatorTintColor;
    if (pageIndicatorTintColor) {
        UIImage *normalImage = [UIImage imageRectWithSize:CGSizeMake(JWPageControlItemH, JWPageControlItemH) andColor:self.pageIndicatorTintColor?self.pageIndicatorTintColor:[UIColor whiteColor] corerRadius:JWPageControlItemH*0.5];
        [self.bgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
            if (view&&[view isKindOfClass:[UIButton class]]) {
                UIButton *btn =  view;
                [btn setImage:normalImage forState:UIControlStateNormal];
            }
        }];
    }
}

/**
 *  设置
 */
-(void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    _currentPageIndicatorTintColor =  currentPageIndicatorTintColor;
    if (currentPageIndicatorTintColor) {
        UIImage *selectedImage = [UIImage imageRectWithSize:CGSizeMake(JWPageControlItemW, JWPageControlItemH) andColor:self.currentPageIndicatorTintColor?self.currentPageIndicatorTintColor:[UIColor redColor] corerRadius:JWPageControlItemH*0.5];
        [self.bgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
            if (view&&[view isKindOfClass:[UIButton class]]) {
                UIButton *btn =  view;
                [btn setImage:selectedImage forState:UIControlStateSelected];
            }
        }];
   
    }
}

/**
 *   按钮点击
 */
-(void)btnClick:(UIButton*)btn
{
    
}

/**
 *  返回大小
 */
-(CGSize)sizeForNumberOfPages:(NSInteger)pageCount
{
    //高度为15，因为看系统的好像默认就是15  间隙16
    CGFloat width = JWPageControlItemW*pageCount+(pageCount+1)*JWPageControlPadding;
    return CGSizeMake(width, JWPageControlH);
}

 

/**
 *  布局
 */
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size =  [self sizeForNumberOfPages:self.numberOfPages];
    CGFloat bgViewW = size.width;
    CGFloat bgViewH = size.height;
    CGFloat bgViewX = (self.bounds.size.width-bgViewW)*0.5;
    CGFloat bgViewY = (self.bounds.size.height-bgViewH)*0.5;
    self.bgView.frame = CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH);
    
    [self.bgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = (JWPageControlItemW+JWPageControlPadding)*idx+JWPageControlPadding;
        CGFloat y = (bgViewH-JWPageControlItemH)*0.5;
        view.frame = CGRectMake(x, y, JWPageControlItemW, JWPageControlItemH);
    }];
    
}
@end
