//
//  YCLanguageTools.m
//  Test_Arr
//
//  Created by 唐斌 on 14-7-28.
//  Copyright (c) 2014年 com.yongche. All rights reserved.
//

#import "YCLanguageTools.h"
#define BaseBundle  @"Base"
@interface YCLanguageTools(){
    NSBundle *_languageBundle;
}
@end
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
    NSString *languagePath = [[NSBundle mainBundle] pathForResource:userLanguage ofType:@"lproj"];
    _languageBundle = [NSBundle bundleWithPath:languagePath];//生成bundle
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
}
-(NSString *)defineUserLanguage{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *userLanguage = [def valueForKey:kUserLanguage];
    return userLanguage;
}
//获取sb
-(UIStoryboard *)locatizedStoryboardWithName:(NSString *)storyBoardName{
    UIStoryboard *storyboard = [UIStoryboard   storyboardWithName:storyBoardName bundle:_languageBundle];
    return storyboard ;
}

//获取标签
-(NSString *)locatizedStringForkey:(NSString *)keyStr{
    //默认为本地资源文件名 为Localizable.strings
    NSString *str = [_languageBundle localizedStringForKey:keyStr value:nil table:@"Localizable"];
    return str;
}


@end
