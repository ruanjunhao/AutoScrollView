//
//  UIImage+Extension.m
//  SunGuide
//
//  Created by 朱建伟 on 16/4/12.
//  Copyright © 2016年 jryghq. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

/**
 *  获取图片的圆形图
 */
-(instancetype)circleImage
{
    
    CGSize imageSize = self.size;
    CGFloat imageWH  = imageSize.width<imageSize.height?imageSize.width:imageSize.height;
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageWH,imageWH), 0, 2);
    
     
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0,imageWH,imageWH)];
    
    [path addClip];
    
    
    [self drawInRect:CGRectMake(0, 0,imageWH,imageWH)];
    
    
    UIImage *image  =  UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  获取一个指定颜色的圆形图片
 */
+(instancetype)imageCircleWithRadius:(CGFloat)radius andColor:(UIColor*)circleColor
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(radius*2, radius*2), 0, 2);
    
    
    if (circleColor) {
        [circleColor set];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius*2, radius*2)];
    [path fill];
    
    UIImage *image  =  UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  获取一个指定颜色的矩形图片
 */
+(instancetype)imageRectWithSize:(CGSize)size andColor:(UIColor *)rectColor
{
    UIGraphicsBeginImageContextWithOptions(size, 0, 2);
    
    if (rectColor) {
        [rectColor set];
    }
     
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
    [path fill];
    
    UIImage *image  =  UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;

}



/**
 *  获取一个指定颜色的矩形图片  指定圆角
 */
+(instancetype)imageRectWithSize:(CGSize)size andColor:(UIColor *)rectColor corerRadius:(CGFloat)corerRadius
{
    UIGraphicsBeginImageContextWithOptions(size, 0, 2);
    
    if (rectColor) {
        [rectColor set];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:corerRadius];
    
    [path fill];
    
    UIImage *image  =  UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  箭头图标
 */
+(instancetype)imageArrowWithSize:(CGSize)size lineWidth:(CGFloat)lineWidth andColor:(UIColor *)arrowColor andArrowDirection:(NSInteger)direction
{
    UIGraphicsBeginImageContextWithOptions(size, 0, 2);
    
    if (arrowColor) {
        [arrowColor set];
    }
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path setLineWidth:lineWidth];
    if(direction==3){//右 >
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(size.width-lineWidth, size.height*0.5)];
        [path addLineToPoint:CGPointMake(0, size.height)];
    }else if (direction==2)//下
    {
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(size.width*0.5, size.height-lineWidth)];
        [path addLineToPoint:CGPointMake(size.width, 0)];
    }else if(direction ==1)//左 <
    {
        [path moveToPoint:CGPointMake(size.width,0)];
        [path addLineToPoint:CGPointMake(lineWidth, size.height*0.5)];
        [path addLineToPoint:CGPointMake(size.width, size.height)];
        
    }else//上
    {
        [path moveToPoint:CGPointMake(0, size.height)];
        [path addLineToPoint:CGPointMake(size.width*0.5, lineWidth)];
        [path addLineToPoint:CGPointMake(size.width,size.height)];
    }
    
    [path stroke];
    
    UIImage *image  =  UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+(UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


@end
