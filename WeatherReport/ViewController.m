//
//  ViewController.m
//  WeatherReport
//
//  Created by yxhe on 16/5/24.
//  Copyright © 2016年 yxhe. All rights reserved.
//

#import "ViewController.h"
#import "WeatherModel.h"



@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *httpUrl; //the basic http url
    NSString *httpArg; //the http args
    
    __block WeatherModel *weatherModel; //use the JSONModel
    __block NSData *responseData; //the json data
    
    //the json string and code received from network
//    __block NSInteger responseCode;
//    __block NSString *responseString;
    
}



@end

@implementation ViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //set the tableview
    self.dailyWeatherTable.dataSource = self;
    self.dailyWeatherTable.delegate = self;
    
    
    NSLog(@"the weather report");
    
    httpUrl = @"http://apis.baidu.com/heweather/weather/free"; //weather data from http://www.heweather.com
//    httpArg = @"city=wuhan";
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//http reques for the weather data through Internet
- (void)request:(NSString *)httpUrl withHttpArg:(NSString *)HttpArg
{
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:10];
    request.HTTPMethod = @"GET";
    [request addValue:@"7941288324b589ad9cf1f2600139078e" forHTTPHeaderField:@"apikey"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               if(connectionError)
                                   NSLog(@"Httperror: %@%d", connectionError.localizedDescription, connectionError.code);
                               else
                               {
                                   //get the response code
//                                   responseCode = ((NSHTTPURLResponse *)response).statusCode;
                                   //get the response json string
//                                   responseString = [[NSString alloc] initWithData:data
//                                                                                    encoding:NSUTF8StringEncoding];
//
//                                   
//                                   responseString = [responseString stringByReplacingOccurrencesOfString:
//                                                     @"HeWeather data service 3.0"
//                                                                                              withString:@"HeWeather_data_service_3_0"];//leave out the white space
                                   
                                   //get the response data and call back
                                   responseData = data;
                                   
                                   [self requestCallBack];
                                
                                   
                               }
                           }];
    
    
}


- (IBAction)clicked:(id)sender
{
    
    
    //send network request to get the weather data
    httpArg = [NSString stringWithFormat:@"city=%@", self.cityTextField.text]; //the city name can be chinese or english
    
    [self request:httpUrl withHttpArg:httpArg];
    
   
    
}

- (void)requestCallBack
{
    
    NSError *error;
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:responseData
                                                 options:NSJSONReadingMutableContainers error:&error];
    
    if (!jsonObj || error)
        NSLog(@"JSON parse failed!");
    
    NSMutableArray *jsonArray = [jsonObj objectForKey:@"HeWeather data service 3.0"];
    
//    NSLog(@"%@", jsonArray);
    
    //fill the weather model,
    weatherModel = [[WeatherModel alloc] init];
    weatherModel.city = jsonArray.firstObject[@"basic"][@"city"]; //because the json has only one big array
    weatherModel.country = jsonArray.firstObject[@"basic"][@"cnty"];
    weatherModel.curWeather = jsonArray.firstObject[@"now"][@"cond"][@"txt"];
    weatherModel.tmperature = jsonArray.firstObject[@"now"][@"tmp"];
    
    if([weatherModel.country isEqualToString:@"中国"]) //only china has the aqi data
    {
        weatherModel.pm25 = jsonArray.firstObject[@"aqi"][@"city"][@"pm25"];
        weatherModel.airQuality = jsonArray.firstObject[@"aqi"][@"city"][@"qlty"];
    }
    
    NSMutableArray *dailyForecastArray = [jsonArray.firstObject objectForKey:@"daily_forecast"];
    
    //fill the 7 day weather
    NSMutableArray *dailyArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < dailyForecastArray.count; i++)
    {
        WeatherDailyModel *dailyModel = [[WeatherDailyModel alloc] init];
        dailyModel.weatherDate = dailyForecastArray[i][@"date"];
        dailyModel.dayWeather = dailyForecastArray[i][@"cond"][@"txt_d"];
        dailyModel.nightWeather = dailyForecastArray[i][@"cond"][@"txt_n"];
        dailyModel.tmp_min = dailyForecastArray[i][@"tmp"][@"min"];
        dailyModel.tmp_max = dailyForecastArray[i][@"tmp"][@"max"];
        [dailyArray addObject:dailyModel];
    }
    
    weatherModel.dailyWeatherDatas = [NSMutableArray arrayWithArray:dailyArray]; //cannot directly add object to this array
    
    
    //display the the data in view
    [_curWeatherLabel setNumberOfLines:6];
    self.curWeatherLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@\ntemperature: %@\nPM2.5: %@\n%@",
                                 weatherModel.city,
                                 weatherModel.country,
                                 weatherModel.curWeather,
                                 weatherModel.tmperature,
                                 weatherModel.pm25,
                                 weatherModel.airQuality];
    
    [self.dailyWeatherTable reloadData];
    
//        weatherModel = [[WeatherModel alloc] initWithString:responseString
//                                                      error:&error];
//    
//    
//        NSLog(@"%@", weatherModel.pm25);
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return weatherModel.dailyWeatherDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    
    cell.backgroundColor = indexPath.row%2 ? [UIColor lightGrayColor]:[UIColor greenColor];
    cell.textLabel.numberOfLines = 5;
    cell.textLabel.text = [NSString stringWithFormat:@"date: %@\nday weather: %@\nnight weather: %@\ntmperature: %@-%@",
                           [weatherModel.dailyWeatherDatas[indexPath.row] weatherDate],
                           [weatherModel.dailyWeatherDatas[indexPath.row] dayWeather],
                           [weatherModel.dailyWeatherDatas[indexPath.row] nightWeather],
                           [weatherModel.dailyWeatherDatas[indexPath.row] tmp_min],
                           [weatherModel.dailyWeatherDatas[indexPath.row] tmp_max]];
   
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //set the tableview cell height
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"you clicked %dth row", indexPath.row);
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"message"
                                                       message:[NSString stringWithFormat:@"cell %d clicked", indexPath.row]
                                                      delegate:self
                                             cancelButtonTitle:@"ok"
                                             otherButtonTitles:nil];
    [alerView show];
    
    
}



@end
