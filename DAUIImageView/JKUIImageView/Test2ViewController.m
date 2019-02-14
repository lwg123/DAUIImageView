//
//  Test2ViewController.m
//  JKUIImageView
//
//  Created by duia on 2019/1/26.
//  Copyright © 2019年 duia. All rights reserved.
//

#import "Test2ViewController.h"

@interface Test2ViewController ()

@property(nonatomic,strong) UIImageView *imageView1;

@property(nonatomic,strong) UIImage *oriImage;


@end

@implementation Test2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 100, 100, 100)];
    [button1 setTitle:@"过滤图片" forState:UIControlStateNormal];
    [button1 setBackgroundColor:[UIColor brownColor]];
    [button1 addTarget:self action:@selector(filterImage) forControlEvents:UIControlEventTouchUpInside];
    button1.tag = 101;
    [button1 setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(button1.frame)+50, 100, 100)];
    [button2 setTitle:@"还原图片" forState:UIControlStateNormal];
    [button2 setBackgroundColor:[UIColor brownColor]];
    [button2 addTarget:self action:@selector(originalImage) forControlEvents:UIControlEventTouchUpInside];
    button2.tag = 102;
    [button2 setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.view addSubview:button2];
    
    self.oriImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"landscape" ofType:@"jpg"]];
    
    self.imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button1.frame)+40, CGRectGetMinY(button1.frame), 180, 130)];
    self.imageView1.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView1.image = self.oriImage;
    [self.view addSubview:self.imageView1];
    
}

#pragma mark 过滤图片：涉及到图片的像素处理，也是根据上下文进行操作的，进行一个绘制
/*
 从图片文件把 图片数据的像素拿出来(RGBA), 对像素进行操作， 进行一个转换（Bitmap （GPU））
 修改完之后，还原（图片的属性 RGBA,RGBA (宽度，高度，色值空间，拿到宽度和高度，每一个画多少个像素，画多少行)）
 //256(11111111)
 */
-(void)filterImage{
    
    CGImageRef imageRef = self.imageView1.image.CGImage;
    // 1 个字节 = 8bit  每行有 17152 每行有17152*8 位
    size_t width   = CGImageGetWidth(imageRef);
    size_t height  = CGImageGetHeight(imageRef);
    size_t bits    = CGImageGetBitsPerComponent(imageRef); // 8
    size_t bitsPerrow = CGImageGetBytesPerRow(imageRef); // width * bits
    
    // 颜色空间
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    // AlphaInfo: RGBA  AGBR  RGB  :AlphaInfo 信息
    CGImageAlphaInfo alpInfo =  CGImageGetAlphaInfo(imageRef);
    
    // bitmap的数据
    CGDataProviderRef providerRef = CGImageGetDataProvider(imageRef);
    CFDataRef bitmapData = CGDataProviderCopyData(providerRef);
    
    NSInteger pixLength = CFDataGetLength(bitmapData);
    // 像素byte数组
    Byte *pixbuf = CFDataGetMutableBytePtr((CFMutableDataRef)bitmapData);
    
    // RGBA 为一个单元
    for (int i = 0; i < pixLength; i+=4) {
        
        [self eocImageFiletPixBuf:pixbuf offset:i];
    }
    
    // 准备绘制图片了
    // bitmap 生成一个上下文  再通过上下文生成图片
    CGContextRef contextR = CGBitmapContextCreate(pixbuf, width, height, bits, bitsPerrow, colorSpace, alpInfo);
    
    CGImageRef filterImageRef = CGBitmapContextCreateImage(contextR);
    
    UIImage *filterImage =  [UIImage imageWithCGImage:filterImageRef];
    
    self.imageView1.image = filterImage;
}

// RGBA 为一个单元  彩色照变黑白照
- (void)eocImageFiletPixBuf:(Byte*)pixBuf offset:(int)offset{
    
    int offsetR = offset;
    int offsetG = offset + 1;
    int offsetB = offset + 2;
    // int offsetA = offset + 3;
    
    int red = pixBuf[offsetR];
    int gre = pixBuf[offsetG];
    int blu = pixBuf[offsetB];
    // int alp = pixBuf[offsetA];
    
    int gray = (red + gre + blu)/3;
    
    pixBuf[offsetR] = gray;
    pixBuf[offsetG] = gray;
    pixBuf[offsetB] = gray;
    
}


#pragma mark 还原图片
-(void)originalImage{
    
    self.imageView1.image = self.oriImage;
}


@end
