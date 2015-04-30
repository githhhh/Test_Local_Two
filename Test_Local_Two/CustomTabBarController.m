//
//  CustomTabBarController.m
//  Test_Local_Two
//
//  Created by 唐斌 on 15/4/30.
//  Copyright (c) 2015年 com.yongche. All rights reserved.
//

#import "CustomTabBarController.h"
#import "TestVC1.h"
#import "TestVC2.h"
#import "TestVC3.h"
#import "OpenVC.h"
@implementation CustomTabBarController



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UINavigationController *vc = self.viewControllers[idx];
        
        if ([vc.visibleViewController isKindOfClass:[TestVC1 class]]) {
            vc.tabBarItem.title = LocatizedStirngForkey(@"TestVC1");
        }else if([vc.visibleViewController isKindOfClass:[TestVC2 class]]){
            vc.tabBarItem.title = LocatizedStirngForkey(@"TestVC2");
        }else if([vc.visibleViewController isKindOfClass:[TestVC3 class]]){
            vc.tabBarItem.title = LocatizedStirngForkey(@"TestVC3");
        }else{
            self.selectedIndex = idx;
            vc.tabBarItem.title = LocatizedStirngForkey(@"Open");
        }
    }];
    
    
}



@end
