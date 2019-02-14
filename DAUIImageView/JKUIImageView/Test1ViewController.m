//
//  Test1ViewController.m
//  JKUIImageView
//
//  Created by duia on 2019/1/26.
//  Copyright © 2019年 duia. All rights reserved.
//

#import "Test1ViewController.h"

@interface Test1ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong) UIImageView *imageView1;
@property(nonatomic,strong) UIImageView *imageView2;

@end

@implementation Test1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 100, 100, 100)];
    [button1 setTitle:@"相册" forState:UIControlStateNormal];
    [button1 setBackgroundColor:[UIColor brownColor]];
    [button1 addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    button1.tag = 101;
    [button1 setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(button1.frame)+50, 100, 100)];
    [button2 setTitle:@"相机" forState:UIControlStateNormal];
    [button2 setBackgroundColor:[UIColor brownColor]];
    [button2 addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag = 102;
    [button2 setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.view addSubview:button2];
    
    self.imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button1.frame)+50, CGRectGetMinY(button1.frame), 150, 100)];
    self.imageView1.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageView1];
    
    self.imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button2.frame)+50, CGRectGetMinY(button2.frame), 150, 100)];
    self.imageView2.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageView2];
    
}

#pragma mark 选择相册
-(void)selectImage:(UIButton *)sender{
    
    NSInteger tag = sender.tag - 100;
    NSUInteger sourceType = 0;
    
    if (tag == 1) {
        // 相册
        // 1.判断能否打开照片库(不支持直接返回)
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            
            NSLog(@"不支持相册");
            
            return;
        }
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }else if (tag == 2){
        // 拍照
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            
             NSLog(@"不支持相机");
            return;
        }
        
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }

    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //设置代理
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    
     // 获取到的图片
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage * image;
        // 判断，图片是否允许修改
        if ([picker allowsEditing]){
            //获取用户编辑之后的图像
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的元数据参数
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        // 压缩图片
        
        /**
          1.PNG压缩
          NSData *dataPNG = UIImagePNGRepresentation(image);
          UIImage *compressPNGImage = [UIImage imageWithData:dataPNG];
          NSLog(@"%@",[self length:dataPNG.length]);
         */

        /**
           2.JPG压缩
           第一个参数：UIIMage 对象
           第二个参数：图片质量（压缩系数）0~1 之间
           NSData *dataJPG = UIImageJPEGRepresentation(image, 0.1);
           UIImage *compressJPGImage = [UIImage imageWithData:dataJPG];
           NSLog(@"%@",[self length:dataJPG.length]);
         */
        
        /**
          3.通过上下文压缩图片
         */
        UIImage *compressImg = [self compressOriginalImage:image withImageSize:CGSizeMake(200, 200)];
        NSLog(@"%@",NSStringFromCGSize(compressImg.size));
        
        self.imageView1.image = compressImg;
        // self.imageView2.image = compressJPGImage;
        
        // 用于上传
        // NSData *tmpData = UIImageJPEGRepresentation(compressImg, 0.5);
        
        
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}


// 当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    NSLog(@"取消相册使用 --- %s", __func__);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 压缩图片
- (UIImage *)compressOriginalImage:(UIImage *)originalImage withImageSize:(CGSize)size{
    
    // 开启图片上下文
    UIGraphicsBeginImageContext(size);
    // 将图片渲染到图片上下文
    [originalImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图片上下文
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark 计算  NSData 的大小
- (NSString*)length:(NSInteger)length{
    
    if (length > 1024 * 1024) {
        
        int mb = (int)length/(1024*1024);
        int kb = (length%(1024*1024))/1024;
        return [NSString stringWithFormat:@"%dMb%dKB",mb, kb];
    }else{
        
        return [NSString stringWithFormat:@"%ldKB",length/1024];
    }
    
}

@end
