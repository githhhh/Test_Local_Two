//
//  YCViewController.h
//  Test_Arr
//
//  Created by 唐斌 on 14-7-25.
//  Copyright (c) 2014年 com.yongche. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef   void(^RefreshTitleBlock)(NSString *str);
@interface YCViewController : UIViewController

@property (nonatomic, strong) NSMutableDictionary *refreshBlockDic;
-(void)refreshTitle:(NSString *)keyStr :(RefreshTitleBlock)rtb;
@end
