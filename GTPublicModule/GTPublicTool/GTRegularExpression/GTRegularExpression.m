//
//  GTRegularExpression.m
//  GTKit
//
//  Created by liuxc on 2018/5/25.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "GTRegularExpression.h"

@implementation GTRegularExpression


#pragma mark - ***** 是否为电话号码【简单写法】
+ (BOOL)gt_regularIsPhoneNumber:(NSString *)phoneNum
{
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[01235678]|8[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:phoneNum];
}

#pragma mark - ***** 是否为电话号码【复杂写法】
+ (BOOL)gt_regularIsMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,172,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,155,156,170,171,172,175,176,185,186
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|701256||8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,149,153,170,173,177,180,181,189
     */
    NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";


    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];

    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - ***** 判断是否是：移动手机号
+ (BOOL)gt_regularIsChinaMobile:(NSString *)phoneNum
{
    /*!
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    return [regextestcm evaluateWithObject:phoneNum];
}

#pragma mark - ***** 判断是否是：联通手机号
+ (BOOL)gt_regularIsChinaUnicom:(NSString *)phoneNum
{
    /*!
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    return [regextestcm evaluateWithObject:phoneNum];
}

#pragma mark - ***** 判断是否是：电信手机号
+ (BOOL)gt_regularIsChinaTelecom:(NSString *)phoneNum
{
    /*!
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    return [regextestcm evaluateWithObject:phoneNum];
}

#pragma mark - ***** 判断具体是哪个运营商的手机号
+ (NSString *)gt_getPhoneNumType:(NSString *)phoneNum
{
    return [GTRegularExpression gt_regularIsChinaMobile:phoneNum]? @"中国移动": ([GTRegularExpression gt_regularIsChinaUnicom:phoneNum]? @"中国联通":([GTRegularExpression gt_regularIsChinaTelecom:phoneNum]? @"中国电信": @"未知号码"));
}

#pragma mark - ***** 检测是否为邮箱
+ (BOOL)gt_regularIsEmailQualified:(NSString *)emailStr
{
    NSString *pattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:emailStr options:0 range:NSMakeRange(0, emailStr.length)];
    return results.count > 0;
}

#pragma mark - ***** 检测用户输入密码是否以字母开头，长度在6-18之间，只能包含字符、数字和下划线。
+ (BOOL)gt_regularIsPasswordQualified:(NSString *)passwordStr
{
    //    NSString *pattern = @"^[a-zA-Z]\\w.{5,17}$";
    //    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    //    NSArray *results = [regex matchesInString:passwordStr options:0 range:NSMakeRange(0, passwordStr.length)];
    //    return results.count > 0;

    NSString *passWordRegex = @"^[a-zA-Z]\\w.{5,17}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passwordStr];

    //    BOOL result = false;
    //    if ([passwordStr length] >= 6 && ([passwordStr length] <= 16))
    //    {
    //        /*! 判断长度大于6位后，再接着判断是否同时包含数字和字符 */
    //        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    //        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    //        result = [pred evaluateWithObject:passwordStr];
    //    }
    //    return result;
}

#pragma mark - ***** 验证身份证号（15位或18位数字）【最全的身份证校验，带校验位】
+ (BOOL)gt_regularIsIdCardNumberQualified:(NSString *)idCardNumberStr
{
    idCardNumberStr = [idCardNumberStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([idCardNumberStr length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];

    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:idCardNumberStr]) {
        return NO;
    }
    int summary = ([idCardNumberStr substringWithRange:NSMakeRange(0,1)].intValue + [idCardNumberStr substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([idCardNumberStr substringWithRange:NSMakeRange(1,1)].intValue + [idCardNumberStr substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([idCardNumberStr substringWithRange:NSMakeRange(2,1)].intValue + [idCardNumberStr substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([idCardNumberStr substringWithRange:NSMakeRange(3,1)].intValue + [idCardNumberStr substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([idCardNumberStr substringWithRange:NSMakeRange(4,1)].intValue + [idCardNumberStr substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([idCardNumberStr substringWithRange:NSMakeRange(5,1)].intValue + [idCardNumberStr substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([idCardNumberStr substringWithRange:NSMakeRange(6,1)].intValue + [idCardNumberStr substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [idCardNumberStr substringWithRange:NSMakeRange(7,1)].intValue *1 + [idCardNumberStr substringWithRange:NSMakeRange(8,1)].intValue *6
    + [idCardNumberStr substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    return [checkBit isEqualToString:[[idCardNumberStr substringWithRange:NSMakeRange(17,1)] uppercaseString]];

    //    if (idCardNumberStr.length <= 0) {
    //        return NO;
    //    }
    //    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    //    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //    return [identityCardPredicate evaluateWithObject:idCardNumberStr];
}

#pragma mark - ***** 验证IP地址（15位或18位数字）
+ (BOOL)gt_regularIsIPAddress:(NSString *)iPAddressStr
{
    NSString *pattern = @"((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:iPAddressStr options:0 range:NSMakeRange(0, iPAddressStr.length)];
    return results.count > 0;
}

#pragma mark - ***** 验证输入的是否全为数字
+ (BOOL)gt_regularIsAllNumber:(NSString *)allNumberStr
{
    NSString *pattern = @"^[0-9]*$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:allNumberStr options:0 range:NSMakeRange(0, allNumberStr.length)];
    return results.count > 0;
}

#pragma mark - ***** 验证由26个英文字母组成的字符串
+ (BOOL)gt_regularIsEnglishAlphabet:(NSString *)englishAlphabetStr
{
    NSString *pattern = @"^[A-Za-z]+$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:englishAlphabetStr options:0 range:NSMakeRange(0, englishAlphabetStr.length)];
    return results.count > 0;
}

#pragma mark - ***** 验证输入的是否是URL地址
+ (BOOL)gt_regularIsUrl:(NSString *)urlStr
{
    //    NSString* verifyRules=@"^http://([\\w-]+\.)+[\\w-]+(/[\\w-./?%&=]*)?$";
    //    NSPredicate *verifyRulesPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",verifyRules];
    //    return [verifyRulesPre evaluateWithObject:urlStr];

    NSString *pattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:urlStr options:0 range:NSMakeRange(0, urlStr.length)];
    return results.count > 0;
}

#pragma mark - ***** 验证输入的是否是中文
+ (BOOL)gt_regularIsChinese:(NSString *)chineseStr
{
    NSString *pattern = @"[\u4e00-\u9fa5]+";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:chineseStr options:0 range:NSMakeRange(0, chineseStr.length)];
    return results.count > 0;
}

#pragma mark - ***** 验证输入的是否是高亮显示
+ (BOOL)gt_regularIsNormalText:(NSString *)normalStr highLightText:(NSString *)highLightStr
{
    NSString *pattern = [NSString stringWithFormat:@"%@",highLightStr];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:normalStr options:0 range:NSMakeRange(0, normalStr.length)];
    for (NSTextCheckingResult *resltText in results) {
        NSLog(@"----------------%zd",resltText.range.length);
    }
    return results.count > 0;
}

#pragma mark - ***** 是否为常用用户名（根据自己需求改）
+ (BOOL)gt_regularIsUserNameInGeneral:(NSString *)userNameStr
{
    NSString* verifyRules = @"^[A-Za-z0-9]{8,20}+$";
    NSPredicate *verifyRulesPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",verifyRules];
    return [verifyRulesPre evaluateWithObject:userNameStr];
}

#pragma mark - ***** 车牌号验证
+ (BOOL)gt_regularIsValidateCarNumber:(NSString *)carNumber
{
    /*! 车牌号:湘K-DE829 香港车牌号码:粤Z-J499港 */
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    /*! 其中\u4e00-\u9fa5表示unicode编码中汉字已编码部分，\u9fa5-\u9fff是保留部分，将来可能会添加 */
    NSPredicate *catTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", carRegex];
    return [catTest evaluateWithObject:carNumber];
}

#pragma mark - ***** 车型验证
+ (BOOL)gt_regularIsValidateCarType:(NSString *)CarType
{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:CarType];
}

#pragma mark - ***** 昵称验证
+ (BOOL)gt_regularIsValidateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

#pragma mark - ***** 邮政编码验证
+ (BOOL)gt_regularIsValidPostalcode:(NSString *)postalcode
{
    NSString *postalRegex = @"^[0-8]\\d{5}(?!\\d)$";
    NSPredicate *postalcodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",postalRegex];

    return [postalcodePredicate evaluateWithObject:postalcode];
}

#pragma mark - ***** 工商税号验证
+ (BOOL)gt_regularIsValidTaxNo:(NSString *)taxNo
{
    NSString *taxNoRegex = @"[0-9]\\d{13}([0-9]|X)$";
    NSPredicate *taxNoPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",taxNoRegex];

    return [taxNoPredicate evaluateWithObject:taxNo];
}

#pragma mark - ***** Mac地址有效性验证
+ (BOOL)gt_regularIsMacAddress:(NSString *)macAddress
{
    NSString *macAddRegex = @"([A-Fa-f\\d]{2}:){5}[A-Fa-f\\d]{2}";
    NSPredicate *macAddressPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",macAddRegex];

    return [macAddressPredicate evaluateWithObject:macAddress];
}

/** 银行卡号有效性问题Luhn算法
 *  现行 16 位银联卡现行卡号开头 6 位是 622126～622925 之间的，7 到 15 位是银行自定义的，
 *  可能是发卡分行，发卡网点，发卡序号，第 16 位是校验码。
 *  16 位卡号校验位采用 Luhm 校验方法计算：
 *  1，将未带校验位的 15 位卡号从右依次编号 1 到 15，位于奇数位号上的数字乘以 2
 *  2，将奇位乘积的个十位全部相加，再加上所有偶数位上的数字
 *  3，将加法和加上校验位能被 10 整除。
 */
#pragma mark - ***** 银行卡号有效性问题Luhn算法
+ (BOOL)gt_regularIsBankCardlNumCheck:(NSString *)bankCardlNum
{
    NSString *lastNum = [[bankCardlNum substringFromIndex:(bankCardlNum.length-1)] copy];//取出最后一位
    NSString *forwardNum = [[bankCardlNum substringToIndex:(bankCardlNum.length -1)] copy];//前15或18位

    NSMutableArray * forwardArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<forwardNum.length; i++)
    {
        NSString * subStr = [forwardNum substringWithRange:NSMakeRange(i, 1)];
        [forwardArr addObject:subStr];
    }

    NSMutableArray * forwardDescArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = (int)(forwardArr.count-1); i> -1; i--)
    {//前15位或者前18位倒序存进数组
        [forwardDescArr addObject:forwardArr[i]];
    }

    NSMutableArray * arrOddNum = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 < 9
    NSMutableArray * arrOddNum2 = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 > 9
    NSMutableArray * arrEvenNum = [[NSMutableArray alloc] initWithCapacity:0];//偶数位数组

    for (int i=0; i< forwardDescArr.count; i++)
    {
        NSInteger num = [forwardDescArr[i] intValue];
        if (i%2)
        {//偶数位
            [arrEvenNum addObject:[NSNumber numberWithInteger:num]];
        }
        else
        {//奇数位
            if (num * 2 < 9)
            {
                [arrOddNum addObject:[NSNumber numberWithInteger:num * 2]];
            }
            else
            {
                NSInteger decadeNum = (num * 2) / 10;
                NSInteger unitNum = (num * 2) % 10;
                [arrOddNum2 addObject:[NSNumber numberWithInteger:unitNum]];
                [arrOddNum2 addObject:[NSNumber numberWithInteger:decadeNum]];
            }
        }
    }

    __block  NSInteger sumOddNumTotal = 0;
    [arrOddNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNumTotal += [obj integerValue];
    }];

    __block NSInteger sumOddNum2Total = 0;
    [arrOddNum2 enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNum2Total += [obj integerValue];
    }];

    __block NSInteger sumEvenNumTotal =0 ;
    [arrEvenNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumEvenNumTotal += [obj integerValue];
    }];

    NSInteger lastNumber = [lastNum integerValue];

    NSInteger luhmTotal = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal;

    return (luhmTotal%10 ==0)?YES:NO;
}

#pragma mark - ***** 判断字符串是否是字母或数字
+ (BOOL)gt_regularIsLetterOrNumberString:(NSString *)string
{
    NSString *letterOrNumberRegex = @"[A-Z0-9a-z]+";
    NSPredicate *letterOrNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", letterOrNumberRegex];
    return [letterOrNumberTest evaluateWithObject:string];
}

#pragma mark - ***** 判断字符串是否是小数点后两位
+ (BOOL)gt_regularIsValidateMoney:(NSString *)money
{
    NSString *phoneRegex = @"^[0-9]+(\\.[0-9]{1,2})?$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:money];
}


@end
