//
//  YCLanguageTools.h
//  Test_Arr
//
//  Created by 唐斌 on 14-7-28.
//  Copyright (c) 2014年 com.yongche. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kUserLanguage @"userLanguage"
#define kLanguageChangeNotifination   @"languageChangeNotifination"
@interface YCLanguageTools : NSObject

@property (nonatomic,strong)NSBundle *languageBundle;
@property (nonatomic,strong)NSString *currentLanguage;


+(YCLanguageTools *)shareInstance;
-(void)initUserLanguage;
-(void)saveDefineUserLanguage:(NSString *)userLanguage;
-(NSString *)locatizedStringForkey:(NSString *)keyStr;


-(NSString *)defineUserLanguage;
@end
