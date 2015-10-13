//
//  BreakPointDownload.m
//  BreakPointDownloadDemo
//
//  Created by lzxuan on 15/9/1.
//  Copyright (c) 2015年 lzxuan. All rights reserved.
//

#import "BreakPointDownload.h"
#import "NSString+Hashing.h"

@implementation BreakPointDownload
{
    NSFileHandle *_fileHandle;//文件句柄
}

- (void)downloadDataFromUrl:(NSString *)url successBlock:(DownloadBlock)myblock {
    if (_httpRequest) {
        [_httpRequest cancel];//取消
        _httpRequest = nil;
    }
    //保存block
    self.myblock = myblock;
    self.url = url;
    
    NSString *filePath = [self getFileFullPathWithFileName:url];
    //1.先判断本地有没有下载的文件
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        //不存在 要创建
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    //2.获取文件大小
    NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    //已经下载到本地的文件大小
    unsigned long long size  = fileDict.fileSize;
    self.loadedFileSize = size;
    
    //3.创建 请求链接，传Range 头域
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    //默认就是get请求
    //增加Range 头  告知 服务器 下载 size 字节大小之后的数据
    [request addValue:[NSString stringWithFormat:@"bytes=%llu-",size]forHTTPHeaderField:@"Range"];
    //下载之前打开文件
    _fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    
    //4.创建 下载链接
    _httpRequest = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSLog(@"filePath:%@",filePath);
}
#pragma mark - NSURLConnectionDataDelegate
//客户端 接收到 服务器的响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //服务器 响应 中 获取
    NSLog(@"url:%@",response.URL.absoluteString);
    NSLog(@"type:%@",response.MIMEType);
    //获取文件总大小
    //response.expectedContentLength 服务器 返回的数据 大小
    self.totalFileSize = self.loadedFileSize + response.expectedContentLength;
}
//客户端接收到 服务传过来的数据  一段 一段 传输
//服务器  每传一段数据  就会调用一次
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //下载过程  写文件 把下载文件的大小等信息 传给 界面
    //把文件偏移量定位到文件尾
    [_fileHandle seekToEndOfFile];
    //写文件 传一段 写到本地 一段
    [_fileHandle writeData:data];
    //立即同步到磁盘
    [_fileHandle synchronizeFile];
    //已经下载的数据大小
    self.loadedFileSize += data.length;
    
    //回调block 告知界面 当前的下载信息
    if (self.myblock) {
        self.myblock(self);
    }
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //下载完成
    NSLog(@"下载完成");
    [self stopDownload];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"下载失败");
    [self stopDownload];
    NSLog(@"error:%@",error);
    NSLog(@"code:%ld",error.code);
    if (error.code == -1005) {
        //The network connection was lost.
        //如果 中间 异常 断开 连接 重新请求连接
        [self downloadDataFromUrl:self.url successBlock:self.myblock];
    }
}

- (void)stopDownload {
    //取消 httpRequest
    if (_httpRequest) {
        [_httpRequest cancel];
        _httpRequest = nil;
    }
    //关闭文件
    [_fileHandle closeFile];
}


#pragma mark - 获取文件在沙盒 的路径
- (NSString *)getFileFullPathWithFileName:(NSString *)url {
    //对url 字符串 进行 md5加密 转化为 唯一的一个(十六进制的)数字字符串
    NSString * fileName = [url MD5Hash];
    //获取沙盒中Documents路径
    //NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //返回 文件在 Docments中的路径
    return [docPath stringByAppendingPathComponent:fileName];

}


@end






