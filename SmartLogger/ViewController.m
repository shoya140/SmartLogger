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
    float baseRoll;
    float basePitch;
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
    baseRoll = 0.00;
    basePitch = 0.00;
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
            baseRoll = motion.attitude.roll;
            basePitch = motion.attitude.pitch;
            baseYaw = motion.attitude.yaw;
            isCalibrated = true;
        }
        
        float roll = (motion.attitude.roll-baseRoll)*180/3.14;
        float pitch = (motion.attitude.pitch-basePitch)*180/3.14;
        float yaw = -(motion.attitude.yaw-baseYaw)*180/3.14;
        self.rollLabel.text = [NSString stringWithFormat:@"%.2f",roll];
        self.pitchLabel.text = [NSString stringWithFormat:@"%.2f",pitch];
        self.yawLabel.text = [NSString stringWithFormat:@"%.2f",yaw];
        [fileWriter recordTimestamp:timestamp withRoll:roll pitch:pitch yaw:yaw];
    }
}

@end
