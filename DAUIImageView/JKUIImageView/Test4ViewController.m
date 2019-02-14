//
//  Test4ViewController.m
//  JKUIImageView
//
//  Created by duia on 2019/1/26.
//  Copyright © 2019年 duia. All rights reserved.
//

#import "Test4ViewController.h"

@interface Test4ViewController ()

@property(nonatomic,strong) UIImageView *imageView1;

@property(nonatomic,strong) UIImageView *imageView2;

@property(nonatomic,strong) UIImage *oriImage;

@end

@implementation Test4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 120, 100, 50)];
    [button1 setTitle:@"渲染图片" forState:UIControlStateNormal];
    [button1 setBackgroundColor:[UIColor brownColor]];
    [button1 addTarget:self action:@selector(blend) forControlEvents:UIControlEventTouchUpInside];
    button1.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [button1 setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.view addSubview:button1];

    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(button1.frame)+50, 100, 50)];
    [button2 setTitle:@"截屏" forState:UIControlStateNormal];
    [button2 setBackgroundColor:[UIColor brownColor]];
    [button2 addTarget:self action:@selector(snapshotImage) forControlEvents:UIControlEventTouchUpInside];
    button2.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [button2 setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.view addSubview:button2];

    
    // 图片的尺寸是：1920 × 1200
    self.oriImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"landscape" ofType:@"jpg"]];
    
    self.imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button1.frame)+40, CGRectGetMinY(button1.frame)+20, [UIScreen mainScreen].bounds.size.width-20-CGRectGetMaxX(button1.frame)-40, 130)];
    // self.imageView1.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView1.image = self.oriImage;
    [self.view addSubview:self.imageView1];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(button2.frame)+100, [UIScreen mainScreen].bounds.size.width-40, 300)];
    view1.backgroundColor = [UIColor brownColor];
    [self.view addSubview:view1];
    
    self.imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(40, 40, [UIScreen mainScreen].bounds.size.width-20-CGRectGetMaxX(button1.frame)-80, 200)];
    [view1 addSubview:self.imageView2];
}

#pragma mark 在图片上渲染一层半透明的红色
-(void)blend{
    
    // 原图的大小
    CGSize size = CGSizeMake(self.imageView1.frame.size.width, self.imageView1.frame.size.height);
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.oriImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 设置半透明红色的渲染
    UIColor *redColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    CGContextSetFillColorWithColor(context, redColor.CGColor);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    // 获取渲染的CGImageRef
    CGImageRef imageRef =  CGBitmapContextCreateImage(context);
    
    self.imageView1.image = [UIImage imageWithCGImage:imageRef];
    
    UIGraphicsEndImageContext();
    
}

#pragma mark 截屏
-(void)snapshotImage{
    
    self.imageView2.image = [self imageFromFullView];
    
}

- (UIImage *)jk_snapshotImage{
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}


// 截屏方式二
- (UIImage *)imageFromFullView{
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.view.layer renderInContext:context];
    
    CGImageRef imageRef =  CGBitmapContextCreateImage(context);
    
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];

    UIGraphicsEndImageContext();
    
    return newImage;

}


@end
