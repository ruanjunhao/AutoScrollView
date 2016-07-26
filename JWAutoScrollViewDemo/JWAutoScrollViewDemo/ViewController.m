//
//  ViewController.m
//  JWAutoScrollViewDemo
//
//  Created by 朱建伟 on 16/6/16.
//  Copyright © 2016年 zhujianwei. All rights reserved.
//
#import "JWAutoScrollView.h"

#import "ViewController.h"

@interface ViewController ()
/**
 *  autoScrollView
 */
@property(nonatomic,strong)JWAutoScrollView* autoScrollView;

/**
 *  数据
 */
@property(nonatomic,strong)NSMutableArray* picDataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    //添加
    [self.view addSubview:self.autoScrollView];
    
    
}

/**
 *  autoScrollView
 */
-(JWAutoScrollView *)autoScrollView
{
    if (_autoScrollView==nil) {
        _autoScrollView = [[JWAutoScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 200)];
        
        //1.先设置图片类型 本demo 加载本地图片
        _autoScrollView.imageType = JWAutoScrollViewImageTypeImage;
        _autoScrollView.duration = 2;
        
        JWWeakSelf
        //2.设置返回的图片个数
        _autoScrollView .numberOfPageBlock = ^{
            return weakSelf.picDataArray.count;
        };
        
        //3.设置
        _autoScrollView.imageOrUrlAtPageIndexBlock = ^(NSInteger index)
        {
            return weakSelf.picDataArray[index];
        };
        
        //4.设置 点击单个选项的回调
        _autoScrollView.didSelectedPageAtIndexBlock  =^(NSInteger index){
            NSLog(@"点击了:%zd",index);
        };
        
        //5.刷新 默认被添加的时候会自动调用一次  异步网络请求需要显示调用 该方法
//        [_autoScrollView reloadData];
    }
    return _autoScrollView;
}

/**
 *  图片数据
 */
-(NSMutableArray *)picDataArray
{
    if (_picDataArray==nil) {
        _picDataArray = [NSMutableArray array];
        for(NSInteger i = 0;i<=4;i++)
        {
            [_picDataArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%zd",i]]];
        }
    }
    return _picDataArray;
}
@end
