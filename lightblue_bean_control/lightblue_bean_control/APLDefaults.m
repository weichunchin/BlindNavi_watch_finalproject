//
//  APLDefaults.m
//  lightblue_bean_control
//
//  Created by 秦暐峻 on 2015/12/1.
//  Copyright © 2015年 sulphate. All rights reserved.
//


#import "APLDefaults.h"


NSString *BeaconIdentifier = @"com.example.apple-samplecode.AirLocate";


@implementation APLDefaults

- (id)init
{
    self = [super init];
    if(self)
    {
        // uuidgen should be used to generate UUIDs.
        _supportedProximityUUIDs = @[
                                     [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"],
                                     //[[NSUUID alloc] initWithUUIDString:@"3D7641A8-4FFE-4ACB-A6BE-11118C7E60B2"],
                                     //[[NSUUID alloc] initWithUUIDString:@"2E493A9A-FA55-4BE7-8C03-910025940D1F"],
                                     [[NSUUID alloc] initWithUUIDString:@"2A782241-52F4-4194-BF93-F7DE85F0D38C"]
                                     ];
        
        _defaultPower = @-59  ;
    }
    
    return self;
}


+ (APLDefaults *)sharedDefaults
{
    static id sharedDefaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDefaults = [[self alloc] init];
    });
    
    return sharedDefaults;
}


- (NSUUID *)defaultProximityUUID
{
    return _supportedProximityUUIDs[0];
}


@end
