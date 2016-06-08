//
//  WeatherModel.m
//  WeatherReport
//
//  Created by yxhe on 16/5/25.
//  Copyright © 2016年 yxhe. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeatherModel

//map the exact key to the variables
+ (JSONKeyMapper *)keyMapper
{
    //map the key to the exact string
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"HeWeather_data_service_3_0.basic.city":@"city",
                                                       @"HeWeather_data_service_3_0.basic.cnty":@"country",
                                                       @"HeWeather_data_service_3_0.now.cond.txt":@"curWeather",
                                                       @"HeWeather_data_service_3_0.now.tmp":@"temperature",
                                                       @"HeWeather_data_service_3_0.aqi.city.pm25":@"pm25",
                                                       @"HeWeather_data_service_3_0.aqi.city.qlty":@"airQuality",
                                                       @"HeWeather_data_service_3_0.daily_forecast":@"dailyWeatherDatas"
                                                       }];
}

@end
