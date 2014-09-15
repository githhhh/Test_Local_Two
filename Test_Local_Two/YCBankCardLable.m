//
//  YCBankCardLable.m
//  iWeidao
//
//  Created by yongche on 13-11-20.
//  Copyright (c) 2013年 Weidao. All rights reserved.
//

#import "YCBankCardLable.h"

@interface YCBankCardLable()

@property (nonatomic,retain) UITextField *textField;
@property (nonatomic,retain) UILabel *lable;

@end

@implementation YCBankCardLable

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setAliPayNumber:(NSString *)aliPayNumber
{
    NSString *formaterAliPayNumber = [self formaterAliPayNumber:aliPayNumber];
    _lable = [[UILabel alloc] init];
    _lable.frame = CGRectMake(0, 0, 0, self.frame.size.height);
    _lable.text = formaterAliPayNumber;
    _lable.font = [UIFont systemFontOfSize:17.0f];
    _lable.textColor = [UIColor blackColor];
    _lable.textAlignment = NSTextAlignmentLeft;
    _lable.backgroundColor = [UIColor clearColor];
    CGSize size = CGSizeMake(MAXFLOAT, _lable.frame.size.height);
    size = [formaterAliPayNumber sizeWithFont:self.lable.font constrainedToSize:size];
    [_lable setFrame:CGRectMake(0, 0, size.width, self.frame.size.height)];
    [self addSubview:_lable];
}

- (void)setCardNum:(NSString *)cardNum
{
    if (![cardNum isEqualToString:_cardNum]) {
        self.textColor=[UIColor blackColor];
        self.textAlignment = NSTextAlignmentLeft;
        self.font = [UIFont systemFontOfSize:17.0f];
        self.backgroundColor = [UIColor clearColor];
        _cardNum = cardNum;
        //显示前6位
        if (_cardNum.length < 6) {
            return;
        }
        [self viewDisplay:[self formaterBankCard:[_cardNum substringToIndex:6]]];
    }
}

- (NSString *)formaterBankCard:(NSString *)num
{
    NSString *resulte = @"";
    if (num && (num.length > 0)) {
        //格式化银行卡
        NSNumber *number = [NSNumber numberWithLongLong:[num longLongValue]];
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setUsesGroupingSeparator:YES];
        [formatter setGroupingSize:4];
        [formatter setGroupingSeparator:@" "];
        resulte = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:number]];
    }
    return resulte;
}

- (void)viewDisplay:(NSString *)value
{
    if ([value length] == 0) {
        return;
    }
    
    _lable = [[UILabel alloc] init];
    _lable.frame = CGRectMake(0, 0, 0, self.frame.size.height);
    _lable.text = value;
    _lable.font = self.font;
    _lable.textColor = self.textColor;
    _lable.textAlignment = self.textAlignment;
    [_lable setBackgroundColor:self.backgroundColor];
    CGSize size = CGSizeMake(MAXFLOAT, _lable.frame.size.height);
    size = [value sizeWithFont:self.lable.font constrainedToSize:size];
    [_lable setFrame:CGRectMake(0, 0, size.width, self.frame.size.height)];
    [self addSubview:_lable];
    
    _textField = [[UITextField alloc] init];
    _textField.text = @"00 0000 0000";
    _textField.frame = CGRectMake(self.lable.frame.size.width,
                                  0,
                                  self.frame.size.width - self.lable.frame.size.width,
                                  self.frame.size.height);
    _textField.secureTextEntry = YES;
    _textField.userInteractionEnabled = NO;
    _textField.textColor = self.textColor;
    _textField.textAlignment = self.textAlignment;
    _textField.borderStyle =  UITextBorderStyleNone;
    _textField.backgroundColor = self.backgroundColor;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self addSubview:_textField];
}

- (NSString *)formaterAliPayNumber:(NSString *)aliPayNumber
{
    NSString *item = @"";
    NSRange range = [aliPayNumber rangeOfString:@"@"];
    if (range.location != NSNotFound) {
        item = [NSString stringWithFormat:@"%@****%@", [aliPayNumber substringToIndex:1], [aliPayNumber substringFromIndex:range.location]];
    } else {
        item = [NSString stringWithFormat:@"%@****%@", [aliPayNumber substringToIndex:3], [aliPayNumber substringFromIndex:aliPayNumber.length - 4]];
    }
    return item;
}

@end
