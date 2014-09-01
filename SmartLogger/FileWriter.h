//
//  FileWriter.h
//  SmartLogger
//
//  Created by ishimaru on 2012/11/01.
//  Copyright (c) 2012 ishimaru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SensorMonitor.h"

#define PRODUCT_NAME @"SmartLogger"


extern NSString* const kAccelerometerFileAppendix;
extern NSString* const kGyroscopeFileAppendix;
extern NSString* const kTimestampFileAppendix;

@interface FileWriter : NSObject{
    
    bool isRecording;
    
    NSFileManager *fileManager;
    
    FILE *accelerometerFile;
    FILE *gyroFile;
    
    NSString *accelerometerFileName;
    NSString *gyroFileName;
    NSString *currentFilePrefix;
    NSString *currentRecordingDirectory;
    
}

@property(nonatomic,retain)NSString *currentFilePrefix;
@property(nonatomic,retain)NSString *currentRecordingDirectory;
@property(nonatomic,retain)NSString *currentRecordingDirectoryForPicture;
@property(nonatomic,retain)NSString *accelerometerFileName;
@property(nonatomic,retain)NSString *gyroFileName;

-(void)startRecording;
-(void)stopRecording;
-(void)recordSensorValue:(CMDeviceMotion *)motionTN timestamp:(NSTimeInterval)timestampTN;
-(void)recordTimestamp:(NSTimeInterval)timestampTN withRoll:(float)roll pitch:(float)pitch yaw:(float)yaw;

-(NSString *)setupTextFile:(FILE **)file withBaseFileName:(NSString *)baseFileName appendix:(NSString *)appendix dataDescription:(NSString *) description subtitle:(NSString *) subtitle columnDescriptions:(NSArray *)columnDescriptions;
-(void)initAccelerometerFile:(NSString*)name;
-(void)initGyroFile:(NSString*)name;

@end
