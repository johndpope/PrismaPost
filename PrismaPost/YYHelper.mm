//
//  YYHelper.cpp
//  YYHOOK
//
//  Created by hongyangyi on 15/7/1.
//
//

#include "YYHelper.h"


@implementation YYHelper


+(NSArray *)getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath
{

        
    
    NSMutableArray *filenamelist = [NSMutableArray arrayWithCapacity:10];
    NSFileManager *tempManger=[[NSFileManager alloc]init];
    NSArray *tmplist = [tempManger contentsOfDirectoryAtPath:dirPath error:nil];
    
    for (NSString *filename in tmplist) {
        NSString *fullpath = [dirPath stringByAppendingPathComponent:filename];
        if ([self isFileExistAtPath:fullpath]) {
            if ([[filename pathExtension] isEqualToString:type]) {
                [filenamelist  addObject:filename];
            }
        }
    }
  
  //  [tempManger release];
    return filenamelist;

}

+(BOOL)isFileExistAtPath:(NSString*)fileFullPath {

        

    BOOL isExist = NO;
    NSFileManager *tempManger=[[NSFileManager alloc]init];
    isExist = [tempManger fileExistsAtPath:fileFullPath];
        
 //   [tempManger release];
    return isExist;

}



+(void)GetClassMessageByAlertViewWithClass:(id) object AndMessage:(SEL) sel;
{
    UIAlertView* alertview=[[UIAlertView alloc]initWithTitle:NSStringFromClass([object class]) message:NSStringFromSelector(sel) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview show];
}

+(void)GetClassMessageByLogWithClass:(id) object AndMessage:(SEL) sel;
{
    //获取document路径,括号中属性为当前应用程序独享
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //传递0代表时找在Documents目录下的文件。
    NSString *documentsDirectory = [directoryPaths objectAtIndex:0];
    
    NSString* logHelpPath = [documentsDirectory stringByAppendingPathComponent:@"YYhelp"];
    BOOL isDir = FALSE;
    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:logHelpPath isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:logHelpPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    //Log文件的路径
    NSString* logFilePath = [logHelpPath stringByAppendingPathComponent:@"Log"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:logFilePath])
    {
        [[NSFileManager defaultManager] createFileAtPath:logFilePath contents:nil attributes:nil];
    }
    
    NSMutableString *log = [NSMutableString stringWithContentsOfFile:logFilePath encoding:NSUTF8StringEncoding error:nil];
    
    [log appendString:NSStringFromClass([object class])];
    [log appendString:@"\t"];
    [log appendString:NSStringFromSelector(sel)];
    [log appendString:@"\n"];
    
    [log writeToFile:logFilePath atomically:YES encoding:NSASCIIStringEncoding error:nil];
    
}
+(void)YYLog:(NSString*)str,...;
{
    //NSFileManager用来访问文件系统的主要类
    NSFileManager *fileManager = [[NSFileManager alloc]init]; //最好不要用defaultManager。
    //获取app目录下Documents目录下的文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //传递0代表时找在Documents目录下的文件。
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //查找文件，文件全名
    NSString *OpenGL_log=[documentsDirectory stringByAppendingPathComponent:@"YYLog"];
    //判断文件是否存在，不存在则创建一个文件
    BOOL isfileExists=[fileManager fileExistsAtPath:OpenGL_log];
    if(!isfileExists)
    {
        [fileManager createFileAtPath:OpenGL_log contents:nil attributes:nil];
    }
    //读取文件流
    NSMutableString *log_String = [NSMutableString stringWithContentsOfFile:OpenGL_log encoding:NSUTF8StringEncoding error:nil];
    if(isfileExists)
    {
        [log_String appendString:@"\n"];
    }
    
    va_list params;  //定义一个指向个数可变的参数列表指针；
    NSString* argument;
    if (str) {
        //使参数列表指针arg_ptr指向函数参数列表中的第一个可选参数，说明：argN是位于第一个可选参数之前的固定参数，（或者说，最后一个 固定参数；…之前的一个参数），函数参数列表中参数在内存中的顺序与函数声明时的顺序是一致的。如果有一va函数的声明是void va_test(char a, char b, char c, …)，则它的固定参数依次是a,b,c，最后一个固定参数argN为c，因此就是va_start(arg_ptr, c)。
        va_start(params, str);
        [log_String appendString:str];
        [log_String appendString:@"\t"];
        while ((argument = va_arg(params, NSString*))) {//返回参数列表中指针arg_ptr所指的参数，返回类型为type，并使指针arg_ptr指向参数列表中下一个参数
            [log_String appendString:argument];
            [log_String appendString:@"\t"];
        }
        va_end(params);//释放列表指针
    }

    
    
    [log_String writeToFile:OpenGL_log atomically:YES encoding:NSASCIIStringEncoding error:nil];
   // [fileManager release];
}



@end