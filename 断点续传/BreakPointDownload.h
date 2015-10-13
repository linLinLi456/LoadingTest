//
//  BreakPointDownload.h
//  BreakPointDownloadDemo
//
//  Created by lzxuan on 15/9/1.
//  Copyright (c) 2015年 lzxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 封装一个类 专门进行断点续传
 如果哪个界面要想进行断点续传 直接创建这个类的对象就可以了
 
 这个类的对象 只进行 下载数据，如果其他界面要想获取这个数据，可以使用代理设计模式
 
 可以把下载数据通过block给 需要的界面
 使用block 回调的步骤
 1.定义 block 类型 (主动方定义) 还有定义变量
 2.调用block  回调block(主动方)
 3.传入block (block 的代码块在 被动方写)
 */
@class BreakPointDownload;//前向引用声明

typedef void (^DownloadBlock)(BreakPointDownload *download) ;

@interface BreakPointDownload : NSObject <NSURLConnectionDataDelegate>
{
    NSURLConnection *_httpRequest;//下载请求链接
}
@property (nonatomic,copy) NSString *url;
//保存block
@property (nonatomic,copy) DownloadBlock myblock;
//文件总大小
@property (nonatomic) unsigned long long totalFileSize;
//已经下载的文件大小
@property (nonatomic) unsigned long long loadedFileSize;

//通过url 进行下载数据  从外界传入block
- (void)downloadDataFromUrl:(NSString *)url successBlock:(DownloadBlock)myblock;


//停止下载
- (void)stopDownload;
@end












