//
//  YYHelper.h
//  YYHOOK
//
//  Created by hongyangyi on 15/7/1.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface YYHelper : NSObject

+(void)GetClassMessageByAlertViewWithClass:(id) object AndMessage:(SEL) sel;

+(void)GetClassMessageByLogWithClass:(id) object AndMessage:(SEL) sel;

+(void)YYLog:(NSString*)str,...;

+(NSArray *)getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath;
+(BOOL)isFileExistAtPath:(NSString*)fileFullPath;
@end

