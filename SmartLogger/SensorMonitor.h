//
//  SensorMonitor.h
//  SmartLogger
//
//  Created by ishimaru on 2012/10/31.
//  Copyright (c) 2012 ishimaru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@protocol SensorMonitorDelegate <NSObject>

-(void)sensorValueChanged:(CMDeviceMotion *)motion timestamp:(NSTimeInterval)timestamp;

@end

@interface SensorMonitor : NSObject{
    
    __weak id <SensorMonitorDelegate> _delegate;
    float systemVersion;
    
    NSDate *beginningOfEpoch;
    NSTimeInterval timestampOffsetFrom1970;
    BOOL timestampOffsetInitialized;
    
}

@property(nonatomic, weak) id <SensorMonitorDelegate> delegate;
@property(nonatomic, retain) CMMotionManager *manager;

-(void)prepareCMDeviceMotion;
-(void)startCMDeviceMotion:(int)frequency;
-(void)stopSensor;

@end
