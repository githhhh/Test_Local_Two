//
//  YCViewController.m
//  Test_Arr
//
//  Created by 唐斌 on 14-7-25.
//  Copyright (c) 2014年 com.yongche. All rights reserved.
//

#import "YCViewController.h"
@interface YCViewController ()

@end

@implementation YCViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"=======%@=======viewDidLoad===注册通知====",self);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshAllTitle)
                                                 name:kLanguageChangeNotifination
                                               object:NULL];
    
}

-(void)dealloc{
    NSLog(@"super================dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLanguageChangeNotifination
                                                  object:nil];
}

#pragma mark -- public method
-(void)refreshTitle:(NSString *)keyStr :(RefreshTitleBlock)rtb{
    if (!keyStr || !rtb) {
        return;
    }
    NSString *resultStr = [[YCLanguageTools shareInstance] locatizedStringForkey:keyStr];
    if (!resultStr) {
        resultStr = @"";
    }
    rtb(resultStr);
    if (!_refreshBlockDic) {
        _refreshBlockDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    [_refreshBlockDic  setObject:rtb forKey:keyStr];
}

-(void)refreshAllTitle{
    if (!_refreshBlockDic||[_refreshBlockDic count] == 0 ) {
        return;
    }
    for (NSString *key in _refreshBlockDic) {
        NSString *resultStr = [[YCLanguageTools shareInstance] locatizedStringForkey:key];
        RefreshTitleBlock rtb = [_refreshBlockDic objectForKey:key];
        rtb(resultStr);
    }
    NSLog(@"刷新成功====%@=========%@",_refreshBlockDic,self);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
