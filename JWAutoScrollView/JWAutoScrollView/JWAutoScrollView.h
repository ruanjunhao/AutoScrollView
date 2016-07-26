//
//  JWAutoScrollView.h
//  SunGuide
//
//  Created by 朱建伟 on 16/4/5.
//  Copyright © 2016年 jryghq. All rights reserved.
//

#define JWWeakSelf __block typeof(self) weakSelf = self;

#import <UIKit/UIKit.h>
typedef NS_OPTIONS(NSInteger, JWAutoScrollViewImageType) {
  JWAutoScrollViewImageTypeUrl,//url
  JWAutoScrollViewImageTypeImage,//图片
  JWAutoScrollViewImageTypeImageName//图片名称
} ;

@interface JWAutoScrollView : UIView

/**
 *  滚动的时间 在realoadData 和 被addSubView之前  调用
 */
@property(nonatomic,assign)NSTimeInterval duration;

/**
 *  图片来源  默认为url 网址
 */
@property(nonatomic,assign)JWAutoScrollViewImageType imageType;

/**
 *  多少页
 */
@property(nonatomic,copy)NSUInteger(^numberOfPageBlock)();

/**
 *  每页的图片或者Url
 */
@property(nonatomic,copy)id(^imageOrUrlAtPageIndexBlock)(NSInteger pageIndex);

/**
 *  点击了指定url
 */
@property(nonatomic,copy)void(^didSelectedPageAtIndexBlock)(NSInteger pageIndex);

/**
 *  点击了底部的按钮
 */
@property(nonatomic,copy)void(^didClickBottomBtnBlock)();

/**
 *  是否自动轮播 默认YES  一张图 默认不轮播
 */
@property(nonatomic,assign)BOOL isAutoScroll;


@property(nonatomic,strong)UIImage *placeHolderImage;

/**
 *  刷新
 */
-(void)reloadData;

/**
 *  底部文字
 */
@property(nonatomic,copy)NSString *bottomTitle;

/**
 *  开始轮播  默认自动轮播 不用掉用
 */
-(void)start;

/**
 *  停止轮播
 */
-(void)stop;

@end

/**
 *  为了重写setContentInset方法 有无导航条都不会修改ContentInset
 */
@interface JWAutoColletionView : UICollectionView

@end
