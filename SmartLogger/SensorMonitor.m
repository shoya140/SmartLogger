//
//  SensorMonitor.m
//  SmartLogger
//
//  Created by ishimaru on 2012/10/31.
//  Copyright (c) 2012 ishimaru. All rights reserved.
//

#import "SensorMonitor.h"

@implementation SensorMonitor

-(id)init{
    self = [super init];
    if(self != nil){
    }
    return self;
}

- (void)prepareCMDeviceMotion{
    
    _systemVersion = [[[UIDevice currentDevice]systemVersion]floatValue];
    NSLog(@"iOS version: %f", _systemVersion);
    self.manager = [[CMMotionManager alloc]init];
    beginningOfEpoch = [[NSDate alloc]initWithTimeIntervalSince1970:0.0];
    timestampOffsetInitialized = false;
}

-(void)startCMDeviceMotion:(int)frequency{
    
    //Check sensor
    if(self.manager.deviceMotionAvailable){
        
        //frequency
        self.manager.deviceMotionUpdateInterval = 1.0f/frequency;
        
        //Handler
        CMDeviceMotionHandler handler = ^(CMDeviceMotion *motion, NSError *error){
            
            if (!timestampOffsetInitialized) {
                timestampOffsetFrom1970 = [self getTimestamp] - motion.timestamp;
                timestampOffsetInitialized = true;
            }
            
            NSTimeInterval timestamp = motion.timestamp + timestampOffsetFrom1970;
            
            [self.delegate sensorValueChanged:motion timestamp:timestamp];
            
        };
        
        //Start device motion
        if(5.0 < _systemVersion){
            [self.manager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical toQueue:[NSOperationQueue currentQueue] withHandler:handler];
        }else{
            [self.manager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:handler];
        }
    }
}


- (void)stopSensor{
    if(4.0 < _systemVersion){
        if(self.manager.deviceMotionActive){
            [self.manager stopDeviceMotionUpdates];
        }
    }
}


- (BOOL)appendFile:(NSString *)path withString:(NSString*)string;
{
    BOOL result = YES;
    NSFileHandle* fh = [NSFileHandle fileHandleForWritingAtPath:path];
    if ( !fh ) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
        fh = [NSFileHandle fileHandleForWritingAtPath:path];
    }
    if ( !fh ) return NO;
    @try {
        [fh seekToEndOfFile];
        [fh writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    }
    @catch (NSException * e) {
        result = NO;
    }
    [fh closeFile];
    return result;
}

-(NSTimeInterval)getTimestamp {
	NSTimeInterval timestamp = -[beginningOfEpoch timeIntervalSinceNow];
	return timestamp;
}


@end