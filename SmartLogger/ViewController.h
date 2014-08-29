//
//  ViewController.h
//  SmartLogger
//
//  Created by ishimaru on 2013/12/11.
//  Copyright (c) 2013 ishimaru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SensorMonitor.h"
#import "FileWriter.h"

@interface ViewController : UIViewController<SensorMonitorDelegate>
- (IBAction)recordButtonWasPushed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *rollLabel;
@property (weak, nonatomic) IBOutlet UILabel *pitchLabel;
@property (weak, nonatomic) IBOutlet UILabel *yawLabel;

@end
