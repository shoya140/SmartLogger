//
//  ViewController.m
//  SmartLogger
//
//  Created by ishimaru on 2013/12/11.
//  Copyright (c) 2013 ishimaru. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    SensorMonitor *sensorMonitor;
    FileWriter *fileWriter;
    bool isRuning;
    bool isCalibrated;
    float frequency;
    float baseYaw;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    isRuning = false;
    isCalibrated = false;
    frequency = 50.0;
    baseYaw = 0.0;
    sensorMonitor = [[SensorMonitor alloc] init];
    sensorMonitor.delegate = self;
    fileWriter = [[FileWriter alloc] init];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [sensorMonitor prepareCMDeviceMotion];
    [sensorMonitor startCMDeviceMotion:frequency];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [sensorMonitor stopSensor];
    [fileWriter stopRecording];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)recordButtonWasPushed:(UIButton *)sender {
    if (!isRuning) {
        isCalibrated = false;
        [fileWriter startRecording];
        [sender setTitle:@"Stop Recording" forState:UIControlStateNormal];
    }else{
        [fileWriter stopRecording];
        [sender setTitle:@"Start Recording" forState:UIControlStateNormal];
    }
    isRuning = !isRuning;
}

- (void)sensorValueChanged:(CMDeviceMotion *)motion timestamp:(NSTimeInterval)timestamp
{
    if (isRuning) {
        if (!isCalibrated) {
            baseYaw = motion.attitude.yaw;
            isCalibrated = true;
        }
        
        self.rollLabel.text = [NSString stringWithFormat:@"tilt +right and -left: %.2f",motion.attitude.roll*180/3.14];
        self.pitchLabel.text = [NSString stringWithFormat:@"tilt +up and -down: %.2f",motion.attitude.pitch*180/3.14];
        self.yawLabel.text = [NSString stringWithFormat:@"rotate +right and -left: %.2f",-(motion.attitude.yaw-baseYaw)*180/3.14];
        [fileWriter recordSensorValue:motion timestamp:timestamp];
    }
}

@end
