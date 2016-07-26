//
//  UIImage+Extension.h
//  SunGuide
//
//  Created by 朱建伟 on 16/4/12.
//  Copyright © 2016年 jryghq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  获取图片的圆形图
 */
-(instancetype)circleImage;


/**
 *  获取一个指定颜色的圆形图片
 */
+(instancetype)imageCircleWithRadius:(CGFloat)radius andColor:(UIColor*)circleColor;



/**
 *  获取一个指定颜色的矩形图片
 */
+(instancetype)imageRectWithSize:(CGSize)size andColor:(UIColor*)rectColor;



/**
 *  获取一个指定颜色的矩形图片  指定圆角
 */
+(instancetype)imageRectWithSize:(CGSize)size andColor:(UIColor*)rectColor corerRadius:(CGFloat)corerRadius;

/**
 *  获取一个箭头图像 >  direction  0上  1左  2下  3右
 */
+(instancetype)imageArrowWithSize:(CGSize)size lineWidth:(CGFloat)lineWidth andColor:(UIColor*)arrowColor andArrowDirection:(NSInteger)direction;

+(UIImage *)fixOrientation:(UIImage *)aImage;
@end
