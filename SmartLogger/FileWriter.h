//
//  FileWriter.h
//  SmartLogger
//
//  Created by ishimaru on 2012/11/01.
//  Copyright (c) 2012 ishimaru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SensorMonitor.h"

extern NSString* const kAccelerometerFileAppendix;
extern NSString* const kGyroscopeFileAppendix;
extern NSString* const kAttitudeFileAppendix;
extern NSString* const kTimestampFileAppendix;

@interface FileWriter : NSObject{
    
    bool isRecording;
    
    NSFileManager *fileManager;
    FILE *accelerometerFile;
    FILE *gyroFile;
    FILE *attitudeFile;
    
    NSString *currentFilePrefix;
    NSString *currentRecordingDirectory;
    NSString *currentRecordingDirectoryForPicture;
    NSString *accelerometerFileName;
    NSString *gyroFileName;
    NSString *attitudeFileName;
    
}

-(void)startRecording;
-(void)stopRecording;
-(void)recordSensorValue:(CMDeviceMotion *)motionTN timestamp:(NSTimeInterval)timestampTN;
-(void)recordTimestamp:(NSTimeInterval)timestampTN withRoll:(float)roll pitch:(float)pitch yaw:(float)yaw;

@end
