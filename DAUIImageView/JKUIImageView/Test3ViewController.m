//
//  Test3ViewController.m
//  JKUIImageView
//
//  Created by duia on 2019/1/26.
//  Copyright © 2019年 duia. All rights reserved.
//

#import "Test3ViewController.h"

@interface Test3ViewController ()

@property(nonatomic,strong) UIImageView *imageView1;
@property(nonatomic,strong) UIImageView *imageView2;
@property(nonatomic,strong) UIImageView *imageView3;

@property(nonatomic,strong) UIImage *oriImage;


@end

@implementation Test3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 120, 100, 50)];
    [button1 setTitle:@"规则剪切图片" forState:UIControlStateNormal];
    [button1 setBackgroundColor:[UIColor brownColor]];
    [button1 addTarget:self action:@selector(clipImage) forControlEvents:UIControlEventTouchUpInside];
    button1.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [button1 setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.view addSubview:button1];

    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(button1.frame)+20, 100, 50)];
    [button2 setTitle:@"不规则剪切图片" forState:UIControlStateNormal];
    [button2 setBackgroundColor:[UIColor brownColor]];
    [button2 addTarget:self action:@selector(irRegularclipImage) forControlEvents:UIControlEventTouchUpInside];
    button2.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [button2 setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.view addSubview:button2];

    
    // 图片的尺寸是：1920 × 1200
    self.oriImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"landscape" ofType:@"jpg"]];
    
    self.imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button1.frame)+40, CGRectGetMinY(button1.frame)+20, [UIScreen mainScreen].bounds.size.width-20-CGRectGetMaxX(button1.frame)-40, 130)];
    self.imageView1.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView1.image = self.oriImage;
    [self.view addSubview:self.imageView1];
    
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(button2.frame)+100, [UIScreen mainScreen].bounds.size.width-40, 130)];
    view1.backgroundColor = [UIColor brownColor];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(view1.frame)+100, [UIScreen mainScreen].bounds.size.width-40, 200)];
    view2.backgroundColor = [UIColor brownColor];
    [self.view addSubview:view2];
    
    self.imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 130,130)];
    self.imageView2.contentMode = UIViewContentModeScaleAspectFill;
    [view1 addSubview:self.imageView2];
    
    self.imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(50, 50, 100,100)];
    self.imageView3.contentMode = UIViewContentModeScaleAspectFill;
    [view2 addSubview:self.imageView3];
    
    
}

#pragma mark 剪切图片（规则的剪切图）
-(void)clipImage{
    
    // 图片的尺寸是：1920 × 1200
    CGSize size = CGSizeMake(self.imageView1.frame.size.height, self.imageView1.frame.size.height);
    
    // 开启上下文
    UIGraphicsBeginImageContext(size);
    // 获取当前的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 设置路径剪切
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    // 把图片绘制上去
    [self.oriImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.imageView2.image = clipImage;
}

#pragma mark 剪切图片（不规则的剪切图）
-(void)irRegularclipImage{
    
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 非规则的path
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPoint lines[] = {
        CGPointMake(50,0),
        CGPointMake(100,0),
        CGPointMake(150,80),
        CGPointMake(0,80),
        CGPointMake(50,0)
    };
    CGPathAddLines(pathRef, NULL, lines, 5);
    CGContextAddPath(context, pathRef);
    CGContextClip(context);

    [self.oriImage drawInRect:CGRectMake(0, 0, 200, 200)];
    
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.imageView3.image = clipImage;
}

@end
