//
//  FileWriter.m
//  SmartLogger
//
//  Created by ishimaru on 2012/11/01.
//  Copyright (c) 2012 ishimaru. All rights reserved.
//

#import "FileWriter.h"

NSString* const kAccelerometerFileAppendix = @"Accel";
NSString* const kGyroscopeFileAppendix = @"Gyro";

NSDictionary *exifDictionary;

@implementation FileWriter

@synthesize currentFilePrefix, currentRecordingDirectory;
@synthesize accelerometerFileName;
@synthesize gyroFileName;

-(id)init{
    self = [super init];
    if(self != nil){
        fileManager = [[NSFileManager alloc]init];
        isRecording = false;
    }
    return self;
}

-(void)dealloc{
    [self stopRecording];
}

-(void)startRecording{
    
    if(!isRecording){

        NSDate *now = [NSDate date];
        self.currentFilePrefix = [[now description] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths lastObject];
        self.currentRecordingDirectory = [documentDirectory stringByAppendingPathComponent:self.currentFilePrefix];
        [fileManager createDirectoryAtPath:self.currentRecordingDirectory withIntermediateDirectories:NO attributes:nil error:NULL];
        
        //reset currentFilePrefix
        currentFilePrefix = @"";
        
        //init files
        [self initAccelerometerFile:self.currentFilePrefix];
        [self initGyroFile:self.currentFilePrefix];
        
        isRecording = true;
    }
}

-(void)stopRecording{
    
    if(isRecording){
        //close all open files
        fclose(accelerometerFile);
        fclose(gyroFile);
        isRecording = false;
    }
}

-(NSString *)setupTextFile:(FILE **)file withBaseFileName:(NSString *)baseFileName appendix:(NSString *)appendix dataDescription:(NSString *)description subtitle:(NSString *)subtitle columnDescriptions:(NSArray *)columnDescriptions{
    
    NSString *fileName = [[baseFileName stringByAppendingString:appendix] stringByAppendingPathExtension:@"csv"];
    NSString *completeFilePath = [currentRecordingDirectory stringByAppendingPathComponent:fileName];
    *file = fopen([completeFilePath UTF8String], "a");
    for (int i = 0; i < [columnDescriptions count]; i++) {
        if([columnDescriptions count] == (i+1)){
            fprintf(*file, "%s\n",[[columnDescriptions objectAtIndex:i] UTF8String]);
        }else{
            fprintf(*file, "%s,",[[columnDescriptions objectAtIndex:i] UTF8String]);
        }
    }
    
    return completeFilePath;
}

- (void)initAccelerometerFile:(NSString*)name {
    self.accelerometerFileName = [self setupTextFile:&accelerometerFile
                                    withBaseFileName:name 
                                            appendix:kAccelerometerFileAppendix
                                     dataDescription:@"Accelerometer data"
                                            subtitle:[NSString stringWithFormat:@"%% Sampling frequency: 50 Hz\n"]
                                  columnDescriptions:[NSArray arrayWithObjects:
                                                      @"Seconds.milliseconds since 1970",
                                                      @"Acceleration value in x-direction",
                                                      @"Acceleration value in y-direction",
                                                      @"Acceleration value in z-direction",
                                                      nil]
                                  ];
}


- (void)initGyroFile:(NSString*)name {
    
    self.gyroFileName = [self setupTextFile:&gyroFile
                           withBaseFileName:name
                                   appendix:kGyroscopeFileAppendix
                            dataDescription:@"Gyrometer data"
                                   subtitle:nil
                         columnDescriptions:[NSArray arrayWithObjects:
                                             @"Seconds.milliseconds since 1970",
                                             @"Gyro X",
                                             @"Gyro Y",
                                             @"Gyro Z",
                                             @"Roll of the device",
                                             @"Pitch of the device",
                                             @"Yaw of the device",
                                             nil]
                         ];
}

-(void)recordSensorValue:(CMDeviceMotion *)motionTN timestamp:(NSTimeInterval)timestampTN{
    
    if(isRecording){
        
        fprintf(accelerometerFile,
            "%10.5f,%f,%f,%f\n",
            timestampTN,
            motionTN.userAcceleration.x,
            motionTN.userAcceleration.y,
            motionTN.userAcceleration.z
        );
        
        fprintf(gyroFile,
                "%10.5f,%f,%f,%f,%f,%f,%f\n",
                timestampTN,
                motionTN.rotationRate.x,
                motionTN.rotationRate.y,
                motionTN.rotationRate.z,
                motionTN.attitude.roll,
                motionTN.attitude.pitch,
                motionTN.attitude.yaw
                );
    }
}

@end
