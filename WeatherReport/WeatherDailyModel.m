//
//  WeatherDailyModel.m
//  WeatherReport
//
//  Created by yxhe on 16/5/25.
//  Copyright © 2016年 yxhe. All rights reserved.
//

#import "WeatherDailyModel.h"

@implementation WeatherDailyModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"date":@"weatherDate",
                                                       @"cond.txt_d":@"dayWeather",
                                                       @"cond.txt_n":@"nightWeather",
                                                       @"tmp.min":@"tmp_min",
                                                       @"tmp.max":@"tmp_max"
                                                       }];
}

@end
