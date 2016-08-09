//
//  ViewController.m
//  PrismaPost
//
//  Created by zj-dt0094 on 16/8/9.
//  Copyright © 2016年 zj-dt0094. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import "YYHelper.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)startGetImage:(id)sender{
    UIAlertView* alertview=[[UIAlertView alloc]initWithTitle:@"处理" message:@"已经开始处理....." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertview show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       // [self PostPic11];
    });
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        [self PostPic22];
    //    });
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        [self PostPic33];
    //    });
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        [self PostPic44];
    //    });
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        [self PostPic55];
    //    });
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        [self PostPic66];
    //    });
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        [self PostPic77];
    //    });
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        [self PostPic88];
    //    });
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        [self PostPic99];
    //    });

}
-(void)getStyles{
    //   https://api2.neuralprisma.com/styles
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *afMan = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    afMan.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURL *url = [NSURL URLWithString:@"https://api2.neuralprisma.com/styles"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置request
    [request setHTTPMethod:@"POST"];
    //  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary *dicTmp=[NSMutableDictionary dictionary];
    [dicTmp setObject:@"public" forKey:@"codes"];
    NSData *dataTemp=[NSJSONSerialization dataWithJSONObject:dicTmp options:0 error:nil];
    [request  setHTTPBody:dataTemp];
    NSURLSessionUploadTask *uploadTask=[afMan dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
        }
    }];
    [uploadTask resume];
}



- (void)doUpLoad:(NSString *)fileDir forPicName:(NSString *)picName  arg3:(void(^)(void)) completion
{
    @autoreleasepool {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *afMan = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        afMan.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSURL *url = [NSURL URLWithString:URL_UPLOAD];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        NSString *path=[NSString stringWithFormat:@"%@%@",fileDir,picName];
        NSData *fileData = [NSData dataWithContentsOfFile:path];
        NSUInteger dataLen = [fileData length];
        NSString *str1=[self getImageSign:fileData];
        //设置request
        [request setHTTPMethod:@"POST"];
        [request setValue:@"B177DECE-0740-4AF4-A3F6-6DCA814F51D6" forHTTPHeaderField:@"prisma-device-id"];
        [request setValue:str1 forHTTPHeaderField:@"prisma-image-sign"];
        
        NSURLSessionUploadTask *uploadTask =[afMan uploadTaskWithRequest:request fromData:fileData
                                                                progress:^(NSProgress * _Nonnull uploadProgress) {
                                                                } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                                    if (error) {
                                                                        if (completion) {
                                                                            completion();
                                                                        }
                                                                    }
                                                                    if ([responseObject isKindOfClass:[NSData class]]) {
                                                                        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                                                                        NSString *keyId=[dic1 objectForKey:@"id"];
                                                                        if ([keyId isKindOfClass:[NSString class]])
                                                                        {
                                                                            [self doProcess:fileDir forPicName:picName forkeyId:keyId  arg3:completion];
                                                                        }
                                                                    }
                                                                }];
        [uploadTask resume];
    }
}

- (void)doProcess:(NSString *)fileDir forPicName:(NSString *)picName forkeyId:(NSString *)keyId  arg3:(void(^)(void)) completion
{
    //开始第二次请求：
    NSURLSessionConfiguration *configuration2 = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *afMan2 = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration2];
    afMan2.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSURL *URL2 = [NSURL URLWithString:URL_PROCESS];
    NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:URL2];
    [request2 setHTTPMethod:@"POST"];
    [request2 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary *dicTmp=[NSMutableDictionary dictionary];
    [dicTmp setObject:keyId forKey:@"id"];
    [dicTmp setObject:STYLE forKey:@"style"];
    NSData *dataTemp=[NSJSONSerialization dataWithJSONObject:dicTmp options:0 error:nil];
    [request2 setHTTPBody:dataTemp];
    [request2 setValue:@"B177DECE-0740-4AF4-A3F6-6DCA814F51D6" forHTTPHeaderField:@"prisma-device-id"];
    NSURLSessionUploadTask *uploadTask2=[afMan2 dataTaskWithRequest:request2 completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (completion) {
                completion();
            }
        }
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *resultUrl=[responseObject objectForKeyedSubscript:@"result_url"];
            if ([resultUrl isKindOfClass:[NSString class]])
            {
                //第三次Download
                [self doDwonLoadPic:fileDir forPicName:picName forResult:resultUrl arg3:completion];
            }
        }
    }];
    [uploadTask2 resume];
}

- (void)doDwonLoadPic:(NSString *)fileDir forPicName:(NSString *)picName  forResult:(NSString *)urlResult arg3:(void(^)(void)) completion
{
    NSURLSessionConfiguration *configuration3= [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *afMan3 = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration3];
    afMan3.responseSerializer = [AFImageResponseSerializer serializer];
    
    NSURL *URL3 = [NSURL URLWithString:urlResult];
    NSMutableURLRequest *request3 = [NSMutableURLRequest requestWithURL:URL3];
    [request3 setHTTPMethod:@"GET"];
    NSURLSessionDownloadTask *downloadTask3=[afMan3 dataTaskWithRequest:request3 completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (completion) {
                completion();
            }
        }
        if ([responseObject isKindOfClass:[UIImage class]])
        {
            NSString *DesDirPath = [NSString stringWithFormat:@"%@/Documents/DesPic/%@", NSHomeDirectory(),picName];
            NSData *photoData=UIImageJPEGRepresentation(responseObject, 1.0);
            BOOL res=[photoData writeToFile:DesDirPath atomically:YES];
            if (res) {
                [YYHelper YYLog:[NSString stringWithFormat:@"%@写入文件成功",picName],nil];
            }
            else
            {
                [YYHelper YYLog:[NSString stringWithFormat:@"%@写入文件失败",picName],nil];
            }
        }
        if (completion) {
            completion();
        }
    }];
    [downloadTask3 resume];
    
    
}


//获取prisma-image-sign参数
-(NSString* ) getImageSign:(NSData *)a1
{
    
    //duGB^Vy3Q&FQrJz2guKJBxNH3dAr/sQx
    
    unsigned char v27[120]={0};
    // const unsigned char* str0="duGB^Vy3Q&FQrJz2guKJBxNH3dAr/sQx";
    int32_t v15=0;
    unsigned char * v16=NULL;
    NSString *str1=[NSString stringWithString:@"duGB^Vy3Q&FQrJz2guKJBxNH3dAr/sQx"];
    unsigned char*str0=[str1 cStringUsingEncoding:1];
    int32_t len1=a1.length;
    if (len1>0x53) {
        v15=84;
        v16=malloc(0x54);
        [a1 getBytes:v16 range:NSMakeRange(0,42)];
        [a1 getBytes:v16+42 range:NSMakeRange(len1-42,42)];
    }
    else
    {
        v16=malloc((size_t)len1);
        [a1 getBytes:v16 length:len1];
        v15=len1;
    }
    int32_t len=strlen(str0);
    CCHmac(2, str0, len, v16, v15, v27);
    free(v16);
    
    NSData *data2=[NSData dataWithBytes:v27 length:32];
    
    
    NSString *str3= [data2 base64EncodedStringWithOptions:0];
    
    UILabel *ps=[[UILabel alloc] init];
    
    
    return str3;
}


-(void) LoopSavePostHairMaskPic: (NSMutableArray *)files arg2:(NSString *)fileDir
{
    if (files.count == 0) {
        UIAlertView* alertview=[[UIAlertView alloc]initWithTitle:@"处理" message:@"处理完成" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertview show];
        //  [alertview release];
    } else {
        [YYHelper YYLog:fileDir,[NSString stringWithFormat:@"%d  %@",[files count],[files lastObject]],nil];
        [self doUpLoad:fileDir forPicName:[files lastObject] arg3:^(){
            [files removeLastObject];
            [self LoopSavePostHairMaskPic:files arg2:fileDir];
        }];
    }
    
}
-(void) PostPic11
{
    
    NSFileManager *fileManager=[[NSFileManager alloc] init];
    NSString *homeStr=NSHomeDirectory();
    NSString* documentDir =[NSString stringWithFormat:@"%@/Documents/SrcPic/GroupSrc11/",homeStr];
    NSError *error = nil;
    NSMutableArray *fileList  = [[fileManager contentsOfDirectoryAtPath:documentDir error:&error] mutableCopy] ;
    [self LoopSavePostHairMaskPic:fileList arg2:documentDir];
    
}
-(void) PostPic22
{
    
    NSFileManager *fileManager=[[NSFileManager alloc] init];
    NSString *homeStr=NSHomeDirectory();
    NSString* documentDir =[NSString stringWithFormat:@"%@/Documents/SrcPic/GroupSrc22/",homeStr];
    NSError *error = nil;
    NSMutableArray *fileList  = [[fileManager contentsOfDirectoryAtPath:documentDir error:&error] mutableCopy] ;
    [self LoopSavePostHairMaskPic:fileList arg2:documentDir];
    
}
-(void) PostPic33
{
    
    NSFileManager *fileManager=[[NSFileManager alloc] init];
    NSString *homeStr=NSHomeDirectory();
    NSString* documentDir =[NSString stringWithFormat:@"%@/Documents/SrcPic/GroupSrc33/",homeStr];
    NSError *error = nil;
    NSMutableArray *fileList  = [[fileManager contentsOfDirectoryAtPath:documentDir error:&error] mutableCopy] ;
    [self LoopSavePostHairMaskPic:fileList arg2:documentDir];
    
}
-(void) PostPic44
{
    
    NSFileManager *fileManager=[[NSFileManager alloc] init];
    NSString *homeStr=NSHomeDirectory();
    NSString* documentDir =[NSString stringWithFormat:@"%@/Documents/SrcPic/GroupSrc44/",homeStr];
    NSError *error = nil;
    NSMutableArray *fileList  = [[fileManager contentsOfDirectoryAtPath:documentDir error:&error] mutableCopy] ;
    [self LoopSavePostHairMaskPic:fileList arg2:documentDir];
    
}
-(void) PostPic55
{
    
    NSFileManager *fileManager=[[NSFileManager alloc] init];
    NSString *homeStr=NSHomeDirectory();
    NSString* documentDir =[NSString stringWithFormat:@"%@/Documents/SrcPic/GroupSrc55/",homeStr];
    NSError *error = nil;
    NSMutableArray *fileList  = [[fileManager contentsOfDirectoryAtPath:documentDir error:&error] mutableCopy] ;
    [self LoopSavePostHairMaskPic:fileList arg2:documentDir];
    
}
-(void) PostPic66
{
    
    NSFileManager *fileManager=[[NSFileManager alloc] init];
    NSString *homeStr=NSHomeDirectory();
    NSString* documentDir =[NSString stringWithFormat:@"%@/Documents/SrcPic/GroupSrc66/",homeStr];
    NSError *error = nil;
    NSMutableArray *fileList  = [[fileManager contentsOfDirectoryAtPath:documentDir error:&error] mutableCopy] ;
    [self LoopSavePostHairMaskPic:fileList arg2:documentDir];
    
}
-(void) PostPic77
{
    
    NSFileManager *fileManager=[[NSFileManager alloc] init];
    NSString *homeStr=NSHomeDirectory();
    NSString* documentDir =[NSString stringWithFormat:@"%@/Documents/SrcPic/GroupSrc77/",homeStr];
    NSError *error = nil;
    NSMutableArray *fileList  = [[fileManager contentsOfDirectoryAtPath:documentDir error:&error] mutableCopy] ;
    [self LoopSavePostHairMaskPic:fileList arg2:documentDir];
    
}
-(void) PostPic88
{
    
    NSFileManager *fileManager=[[NSFileManager alloc] init];
    NSString *homeStr=NSHomeDirectory();
    NSString* documentDir =[NSString stringWithFormat:@"%@/Documents/SrcPic/GroupSrc88/",homeStr];
    NSError *error = nil;
    NSMutableArray *fileList  = [[fileManager contentsOfDirectoryAtPath:documentDir error:&error] mutableCopy] ;
    [self LoopSavePostHairMaskPic:fileList arg2:documentDir];
    
}
-(void) PostPic99
{
    
    NSFileManager *fileManager=[[NSFileManager alloc] init];
    NSString *homeStr=NSHomeDirectory();
    NSString* documentDir =[NSString stringWithFormat:@"%@/Documents/SrcPic/GroupSrc99/",homeStr];
    NSError *error = nil;
    NSMutableArray *fileList  = [[fileManager contentsOfDirectoryAtPath:documentDir error:&error] mutableCopy] ;
    [self LoopSavePostHairMaskPic:fileList arg2:documentDir];
    
}
@end
