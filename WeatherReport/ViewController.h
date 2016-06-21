//
//  ViewController.h
//  WeatherReport
//
//  Created by yxhe on 16/5/24.
//  Copyright © 2016年 yxhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *cityTextField;

- (IBAction)clicked:(id)sender;

//show the current weather data
@property (weak, nonatomic) IBOutlet UILabel *curWeatherLabel;
//show 7-days weather data
@property (weak, nonatomic) IBOutlet UITableView *dailyWeatherTable;

@end

