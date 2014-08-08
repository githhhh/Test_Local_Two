//
//  YCLanguageTools.m
//  Test_Arr
//
//  Created by 唐斌 on 14-7-28.
//  Copyright (c) 2014年 com.yongche. All rights reserved.
//

#import "YCLanguageTools.h"
#define BaseBundle  @"Base"
@implementation YCLanguageTools

+(YCLanguageTools *)shareInstance{
    static YCLanguageTools *languageTools;
    static  dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        languageTools = [[YCLanguageTools alloc] init];
    });
    return languageTools;
}
-(void)initUserLanguage{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *userLanguage = [def valueForKey:kUserLanguage];
    if (!userLanguage) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *languages = [defaults objectForKey : @"AppleLanguages" ];
        // 获得当前iPhone使用的语言
        NSString* currentLanguage = [languages objectAtIndex:0];
        userLanguage = currentLanguage;
        [self saveDefineUserLanguage:userLanguage];
    }
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:userLanguage ofType:@"lproj"];
    _languageBundle = [NSBundle bundleWithPath:path];//生成bundle
}
+(NSBundle *)baseBundel{
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:BaseBundle ofType:@"lproj"];
   return  [NSBundle bundleWithPath:path];//生成bundle
}


-(void)saveDefineUserLanguage:(NSString *)userLanguage{
    if (!userLanguage) {
        return;
    }
    //
    if (userLanguage == _currentLanguage) {
        return;
    }
    _currentLanguage = userLanguage;
    NSString *path = [[NSBundle mainBundle] pathForResource:userLanguage ofType:@"lproj" ];
    _languageBundle = [NSBundle bundleWithPath:path];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setValue:userLanguage forKey:kUserLanguage];
    [def synchronize];
#warning 这里发送通知不合理
    //发送change通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:kLanguageChangeNotifination object:self];
}
-(NSString *)defineUserLanguage{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *userLanguage = [def valueForKey:kUserLanguage];
    return userLanguage;
}


//获取标签
-(NSString *)locatizedStringForkey:(NSString *)keyStr{
    //默认为本地资源文件名 为Localizable.strings
    NSString *str = [_languageBundle localizedStringForKey:keyStr value:nil table:@"Localizable"];
    return str;
}


@end
