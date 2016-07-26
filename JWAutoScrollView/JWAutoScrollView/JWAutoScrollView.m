//
//  JWAutoScrollView.m
//  SunGuide
//
//  Created by 朱建伟 on 16/4/5.
//  Copyright © 2016年 jryghq. All rights reserved.
//

/**
 *  这里是用了SDWebImage 依赖
 */
#import <SDWebImage/UIImageView+WebCache.h>

#define SDSetImageP(imageView,url,placeholder)  [imageView sd_setImageWithURL:[NSURL URLWithString:(url)] placeholderImage:placeholder]

#define SDSetImage(imageView,url)  [imageView sd_setImageWithURL:[NSURL URLWithString:url]]




#define MaxMutipl 200

#import "JWPageControl.h"
#import "JWAutoScrollViewCell.h"
#import "JWAutoScrollView.h"
@interface JWAutoScrollView()<UICollectionViewDataSource,UICollectionViewDelegate>
/**
 *  collectionView
 */
@property(nonatomic,strong)JWAutoColletionView *collectionView;

/**
 *  定时器
 */
@property(nonatomic,strong)NSTimer *timer;

/**
 *  总页数
 */
@property(nonatomic,assign)NSInteger totalCount;

/**
 *  pageControl
 */
@property(nonatomic,strong)JWPageControl *pageControl;

/**
 *  布局
 */
@property(nonatomic,strong)UICollectionViewFlowLayout *layout;

/**
 *  底部提示按钮
 */
@property(nonatomic,strong)UIButton *bottomBtn;

/**
 *  当前索引
 */
@property(nonatomic,assign)NSInteger currentIndex;

/**
 *  底部按钮的高度
 */
@property(nonatomic,assign)CGFloat bottomBtnH;

@end

@implementation JWAutoScrollView

//重用ID
static NSString* reuseIdentifer = @"resuseIdentifier";

/**
 *  初始化控件
 */
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        self.duration =3;
        self.currentIndex = 0;
        _isAutoScroll = YES;
        _collectionView = [[JWAutoColletionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.showsVerticalScrollIndicator =NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[JWAutoScrollViewCell class] forCellWithReuseIdentifier:reuseIdentifer];
        _collectionView.pagingEnabled = YES;
        [self addSubview:_collectionView];
        
        _pageControl = [[JWPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor =  [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor =  [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
        [self addSubview:_pageControl];
        
        _bottomBtn = [[UIButton alloc] init];
        CGFloat value = 0;
        _bottomBtn.backgroundColor = [UIColor colorWithRed:(value/255.0) green:(value/255.0) blue:(value/255.0) alpha:0.8];
        _bottomBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_bottomBtn addTarget:self action:@selector(bottomClick) forControlEvents:(UIControlEventTouchUpInside)];
        _bottomBtn.titleLabel.numberOfLines = 0;
        _bottomBtn.hidden= YES;
        [self addSubview:_bottomBtn];
        
    }
    return self;
}

/**
 *  底部的提示点击
 */
-(void)bottomClick
{
    if(self.didClickBottomBtnBlock)
    {
        self.didClickBottomBtnBlock();
    }
}

/**
 *  布局
 */
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
     
    self.pageControl.frame = CGRectMake(0, 0, self.bounds.size.width*0.5,15);
    
    self.pageControl.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height-15);
    
    self.bottomBtn.frame = CGRectMake(0, self.bounds.size.height-(self.bottomBtnH?self.bottomBtnH:30), self.bounds.size.width, (self.bottomBtnH?self.bottomBtnH:30));
    
    self.layout.itemSize = self.collectionView.bounds.size;
}


/**
 *  numberOfItemsInSection
 */
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.totalCount<=1) {
        return self.totalCount;
    }else{
        return self.totalCount*MaxMutipl;
    }
    
}

/**
 *  numberOfSectionsInCollectionView
 */
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

/**
 *  返回  cell
 */
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JWAutoScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifer forIndexPath:indexPath];
    
    NSInteger item = indexPath.item;
    NSInteger tempItem =  0;
    
    if(item!=0)tempItem=(item%self.totalCount);
    
    id obj  = self.imageOrUrlAtPageIndexBlock(tempItem);
    if (obj) {
       [self setDataWithObj:obj andImageView:cell.bgImageView];
    }
    
    return cell;
}

/**
 *  设置数据
 */
-(void)setDataWithObj:(id)obj andImageView:(UIImageView*)imageView
{
    switch (self.imageType) {
        case JWAutoScrollViewImageTypeUrl:
            if ([obj isKindOfClass:[NSString class]]) {
                if (self.placeHolderImage) {
                    SDSetImageP(imageView, (NSString*)obj,self.placeHolderImage);
                }else
                {
                    SDSetImage(imageView, (NSString*)obj);
                }
            }
            break;
        case JWAutoScrollViewImageTypeImage:
            if ([obj isKindOfClass:[UIImage class]]) {
                imageView.image = (UIImage*)obj;
            }
            break;
        case JWAutoScrollViewImageTypeImageName:
            if ([obj isKindOfClass:[NSString class]]) {
                imageView.image = [UIImage imageNamed:(NSString*)obj];
            }
            break;
        default:
            if ([obj isKindOfClass:[NSString class]]) {
                if (self.placeHolderImage) {
                     SDSetImageP(imageView, (NSString*)obj,self.placeHolderImage);
                }else
                {
                     SDSetImage(imageView, (NSString*)obj);
                }
            }
            break;
    }
}


/**
 *  定时 更换选项
 */
-(void)changePosition
{
    if(self.isAutoScroll&&self.totalCount>1)
    {
        if (_timer) {
            [self.timer invalidate];
            self.timer = nil;
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    }
    
    NSIndexPath *path = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];//
    
    if(path==nil)return;
    
     NSInteger item = path.item>=self.totalCount*MaxMutipl-1?self.totalCount*MaxMutipl/2:path.item+1;
    
    if (item<0)return;
    
    if (path.item>=self.totalCount*MaxMutipl-1) {
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item-1 inSection:0] atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:NO];
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:YES];
    
}

/**
 *  定时器
 */
-(NSTimer *)timer
{
    if (_timer==nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.duration>0?self.duration:2 target:self selector:@selector(changePosition) userInfo:nil repeats:YES];
         
    }
    return _timer;
}

/**
 *  开始拖拽
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_timer) {
        [_timer invalidate];
        _timer  = nil;
    }
}

/**
 *  结束拖拽
 */
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.totalCount>1&&self.isAutoScroll) {
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

/**
 *  滚动
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.bounds.size.width<=0)return;
    NSInteger index =  (NSUInteger)(scrollView.contentOffset.x/scrollView.bounds.size.width+0.5);
    self.currentIndex= index;
    self.pageControl.currentPage = index%self.totalCount;
}

/**
 *  点击了选项
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tempItem = indexPath.item%self.totalCount;
    if (self.didSelectedPageAtIndexBlock) {
        self.didSelectedPageAtIndexBlock(tempItem);
    }
}


/**
 *  layout
 */
-(UICollectionViewFlowLayout *)layout
{
    if (_layout==nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.sectionInset =  UIEdgeInsetsMake(0, 0, 0, 0);
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}


/**
 *  刷新数据
 */
-(void)reloadData
{
    if (self.numberOfPageBlock&&self.imageOrUrlAtPageIndexBlock) {
        self.totalCount = self.numberOfPageBlock();
        self.pageControl.numberOfPages = self.totalCount;
        self.pageControl.hidden = NO;
        if (self.isAutoScroll&&self.totalCount>1) {
            if (!_timer) {
                [self.timer invalidate];
                self.timer = nil;
                [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            }
        }else
        {
            if (self.totalCount<=1) {
                self.pageControl.hidden =YES;
            }
            if (_timer) {
                [self.timer invalidate];
                self.timer = nil;
            }
        }
        [self.collectionView reloadData];
    }
}


/**
 *  设置底部的文字
 */
-(void)setBottomTitle:(NSString *)bottomTitle
{
    if (bottomTitle&&bottomTitle.length) {
        self.bottomBtn.hidden = NO;
        [self.bottomBtn setTitle:bottomTitle forState:UIControlStateNormal];
        CGFloat height = [self sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(self.bottomBtn.bounds.size.width, MAXFLOAT) string:bottomTitle].height+5;
        
        self.bottomBtnH = height;

        [self setNeedsLayout];
        
        self.pageControl.hidden = YES;
    }else
    {
        self.bottomBtn.hidden = YES;
        if (self.totalCount>1) {
            self.pageControl.hidden = NO;
        }
        self.pageControl.numberOfPages= self.totalCount;
    }
}


/**
 *  添加到superView上 reloadData
 */
-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self reloadData];
    
}

/**
 *  开始
 */
-(void)start
{
    if (!_timer) {
        if (self.totalCount>1) {
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    }
}

/**
 *  停止
 */
-(void)stop
{
    if (_timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


/**
 *  计算尺寸
 */
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize string:(NSString*)str
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end


@implementation JWAutoColletionView

-(void)setContentInset:(UIEdgeInsets)contentInset
{
    
}
@end