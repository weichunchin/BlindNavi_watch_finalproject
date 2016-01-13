//
//  NaviViewController.m
//  lightblue_bean_control
//
//  Created by 秦暐峻 on 2015/12/1.
//  Copyright © 2015年 sulphate. All rights reserved.
//


#import "NaviViewController.h"
#import "APLDefaults.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <WatchConnectivity/WatchConnectivity.h>

@import CoreLocation;
@interface NaviViewController () <WCSessionDelegate,CLLocationManagerDelegate>
{
    NSNumber *section_key;
}
@property NSMutableDictionary *beacons;
@property CLLocationManager *locationManager;
@property NSMutableDictionary *rangedRegions;
@property float accuracy_nearest;
@property NSString* major_nearest;
@property NSString* minor_nearest;
@property NSString *speech_location;
@property NSString *previous_location;
@property NSString *next_location;
@property NSString *default_major;
@property AVSpeechSynthesizer *synth;
@property NSInteger* nearest_beacon_proximity;
@property NSArray *speaking_content;
@end

@implementation NaviViewController
@synthesize myLabel;


- (BOOL)becomeFirstResponder {
    return YES;
}

- (BOOL)resignFirstResponder {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    _speaking_content=@[@"",@"起點：健康中心，請面對馬路右轉，於。指南路。人行道上直行，20公尺後準備左轉",
                        @"請左轉，確認號誌燈在九點鐘方向後過馬路，過馬路後朝2點鐘方向尋找下個號誌燈",
                        @"請確認號誌燈在九點鐘方向後過馬路，過馬路上人行道後左轉進入校園，小心人行道與斑馬線之落差",
                        @"請繼續於。政大校門。人行道上直行，可沿右側追跡",
                        @"右手邊為政大警衛室，請繼續直行5公尺後過馬路，過馬路後準備右轉",
                        @"請右轉，右轉後將於。八德道。人行道上直行，可沿左側追跡",
                        @"請繼續直行70公尺，可沿左側追跡",@"請繼續直行60公尺，可沿左側追跡",@"左前方為7-11，請繼續直行50公尺",
                        @"請繼續直行40公尺，可沿左側追跡",
                        @"請繼續直行30公尺，可沿左側追跡",@"請繼續直行20公尺，可沿左側追跡",@"請繼續直行10公尺尋找行道樹後準備過馬路",
                        @"請確認行道樹在三點鐘方向後過馬路，過馬路後左轉",
                        @"請繼續於。麥側路。人行道上直行，可沿右側追跡",
                        @"右手邊為車輛出入口請注意，請繼續直行30公尺",
                        @"請繼續直行20公尺，可沿右側追跡",@"請繼續直行10公尺後右轉，可沿右側追跡",
                        @"請右轉，右轉後將於。四維道。人行道上直行，目的地在右前方10公尺處",
                        @"抵達目的地，新聞館",@""];
    
    
    self.preLabel.textColor=[UIColor whiteColor];
    self.nexLabel.textColor=[UIColor whiteColor];
    self.preLabel.text=_speaking_content[0];
    self.nexLabel.text=_speaking_content[2];
    self.myLabel.text=_speaking_content[1];
    
    self.beacons = [[NSMutableDictionary alloc] init];
    
    // This location manager will be used to demonstrate how to range beacons.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    //    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Populate the regions we will range once.
    self.rangedRegions = [[NSMutableDictionary alloc] init];
    
    for (NSUUID *uuid in [APLDefaults sharedDefaults].supportedProximityUUIDs)
    {
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
        self.rangedRegions[region] = [NSArray array];
    }
    
    _default_major=@"100";
    _synth = [[AVSpeechSynthesizer alloc] init];
    
  /*  if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    */
    NSString *counterString =self.myLabel.text;
    NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[counterString] forKeys:@[@"counterValue"]];
    
    NSLog(@"send location!!!");
    [[WCSession defaultSession] sendMessage:applicationData
                               replyHandler:^(NSDictionary *reply) {
                                   //handle reply from iPhone app here
                               }
                               errorHandler:^(NSError *error) {
                                   //catch any errors here
                               }
     ];
    
    
    
    
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Start ranging when the view appears.
    for (CLBeaconRegion *region in self.rangedRegions)
    {
        [self.locationManager startRangingBeaconsInRegion:region];
    }
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Stop ranging when the view goes away.
    for (CLBeaconRegion *region in self.rangedRegions)
    {
        [self.locationManager stopRangingBeaconsInRegion:region];
    }
}


- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    /*
     CoreLocation will call this delegate method at 1 Hz with updated range information.
     Beacons will be categorized and displayed by proximity.  A beacon can belong to multiple
     regions.  It will be displayed multiple times if that is the case.  If that is not desired,
     use a set instead of an array.
     */
    self.rangedRegions[region] = beacons;
    [self.beacons removeAllObjects];
    
    NSMutableArray *allBeacons = [NSMutableArray array];
    
    for (NSArray *regionResult in [self.rangedRegions allValues])
    {
        [allBeacons addObjectsFromArray:regionResult];
    }
    
    for (NSNumber *range in @[@(CLProximityUnknown), @(CLProximityImmediate), @(CLProximityNear), @(CLProximityFar)])
    {
        NSArray *proximityBeacons = [allBeacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", [range intValue]]];
        
        
        if([proximityBeacons count])
        {
            self.beacons[range] = proximityBeacons;
            //NSLog(@"beacon:%@", proximityBeacons);
            //NSObject *as = proximityBeacons[0];
            //NSLog(@"range:%@", as);
        }
    }
    
    
    //CLBeacon *beacon_i;
    CLBeacon *beacon_n;
    CLBeacon *beacon_f;
    
    
    for (int k=0 ;k<self.beacons.count;k++)
    {
        beacon_f=self.beacons[@3][k];
        
        if (beacon_f!=nil)
        {
            //Boolean aaa=beacon_f.rssi<70;
            if (beacon_f.rssi > (-75)) {
                if ([beacon_f.major isEqualToNumber: @3]) {
                    NSLog(@"%ld", (long)beacon_f.rssi);
                    //NSLog(@"%hhu",aaa);
                    
                    _major_nearest=@"33";
                    NSLog(@"%@",_default_major);
                    
                    if (![_default_major isEqualToString:@"3"]&![_default_major isEqualToString:@"4"]) {
                        NSLog(@"%@",_default_major);
                        
                        if (![_default_major isEqualToString:_major_nearest]) {
                            if ([_synth isSpeaking]) {
                                [_synth stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
                                _synth = [[AVSpeechSynthesizer alloc] init];
                            }
                            _default_major=_major_nearest;
                            
                            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                            
                            double interval = 1;  // 間隔多久執行一次 (秒)
                            [NSTimer scheduledTimerWithTimeInterval:interval
                                                             target:self
                                                           selector:@selector(timerEvent:)
                                                           userInfo:nil
                                                            repeats:false];
                            
                            //[self changePlace_Immidiate];
                        }
                    }
                }
            }
            break;
        }
        if (beacon_f!=nil)
            break;
    }
    
    for (int j=0 ;j<self.beacons.count;j++)
    {
        beacon_n=self.beacons[@2][j];
        
        if (beacon_n!=nil)
        {
            //if (beacon_n.rssi < 65) {
            
            _major_nearest=[beacon_n.major stringValue];
            
            if (![_default_major isEqualToString:_major_nearest]) {
                if ([_synth isSpeaking]) {
                    [_synth stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
                    _synth = [[AVSpeechSynthesizer alloc] init];
                }
                _default_major=_major_nearest;
                
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                
                double interval = 1;  // 間隔多久執行一次 (秒)
                [NSTimer scheduledTimerWithTimeInterval:interval
                                                 target:self
                                               selector:@selector(timerEvent:)
                                               userInfo:nil
                                                repeats:false];
                
                //[self changePlace_Immidiate];
                
                
            }
            // }
            break;
        }
        if (beacon_n!=nil)
            break;
    }
    
    [self.view reloadInputViews];
}


- (void)timerEvent:(NSTimer *)timer
{
    [self changePlace_Immidiate];
    [timer invalidate]; //停止 Timer
}


-(void)changePlace_Immidiate{
    
    NSLog(@"enter i!,%@",_major_nearest);
    
    //    if ([_major_nearest isEqualToString:@"0"]) {
    //        _speech_location=@"起點：健康中心，請面對馬路右轉，於指南路人型道上直行，15公尺後準備左轉";
    //    }
    
    if ([_major_nearest isEqualToString:@"1"]) {
        _previous_location=_speaking_content[1];
        _next_location=_speaking_content[3];
        
        _speech_location=_speaking_content[2];
    }
    
    if ([_major_nearest isEqualToString:@"2"]) {
        _previous_location=_speaking_content[2];
        _next_location=_speaking_content[4];
        
        _speech_location=_speaking_content[3];
    }
    if ([_major_nearest isEqualToString:@"33"]) {
        _previous_location=_speaking_content[3];
        _next_location=_speaking_content[5];
        
        _speech_location=_speaking_content[4];
    }
    
    if ([_major_nearest isEqualToString:@"3"]) {
        _previous_location=_speaking_content[4];
        _next_location=_speaking_content[6];
        
        _speech_location=_speaking_content[5];
    }
    
    if ([_major_nearest isEqualToString:@"4"]) {
        _previous_location=_speaking_content[5];
        _next_location=_speaking_content[7];
        
        _speech_location=_speaking_content[6];
    }
    if ([_major_nearest isEqualToString:@"5"]) {
        _previous_location=_speaking_content[6];
        _next_location=_speaking_content[8];
        
        _speech_location=_speaking_content[7];
    }
    
    if ([_major_nearest isEqualToString:@"6"]) {
        _previous_location=_speaking_content[7];
        _next_location=_speaking_content[9];
        
        _speech_location=_speaking_content[8];
    }
    
    if ([_major_nearest isEqualToString:@"7"]) {
        _previous_location=_speaking_content[8];
        _next_location=_speaking_content[10];
        
        _speech_location=_speaking_content[9];
    }
    if ([_major_nearest isEqualToString:@"8"]) {
        _previous_location=_speaking_content[9];
        _next_location=_speaking_content[11];
        
        _speech_location=_speaking_content[10];
    }
    
    if ([_major_nearest isEqualToString:@"9"]) {
        _previous_location=_speaking_content[10];
        _next_location=_speaking_content[12];
        
        _speech_location=_speaking_content[11];
    }
    
    if ([_major_nearest isEqualToString:@"10"]) {
        _previous_location=_speaking_content[11];
        _next_location=_speaking_content[13];
        
        _speech_location=_speaking_content[12];
    }
    if ([_major_nearest isEqualToString:@"11"]) {
        _previous_location=_speaking_content[12];
        _next_location=_speaking_content[14];
        
        _speech_location=_speaking_content[13];
    }
    
    if ([_major_nearest isEqualToString:@"12"]) {
        _previous_location=_speaking_content[13];
        _next_location=_speaking_content[15];
        
        _speech_location=_speaking_content[14];
    }
    
    if ([_major_nearest isEqualToString:@"13"]) {
        _previous_location=_speaking_content[14];
        _next_location=_speaking_content[16];
        
        _speech_location=_speaking_content[15];
    }
    if ([_major_nearest isEqualToString:@"14"]) {
        _previous_location=_speaking_content[15];
        _next_location=_speaking_content[17];
        
        _speech_location=_speaking_content[16];    }
    
    if ([_major_nearest isEqualToString:@"15"]) {
        _previous_location=_speaking_content[16];
        _next_location=_speaking_content[18];
        
        _speech_location=_speaking_content[17];
    }
    
    if ([_major_nearest isEqualToString:@"16"]) {
        _previous_location=_speaking_content[17];
        _next_location=_speaking_content[19];
        
        _speech_location=_speaking_content[18];
    }
    
    if ([_major_nearest isEqualToString:@"17"]) {
        _previous_location=_speaking_content[18];
        _next_location=_speaking_content[20];
        
        _speech_location=_speaking_content[19];
    }
    
    if ([_major_nearest isEqualToString:@"18"]) {
        _previous_location=_speaking_content[19];
        _next_location=_speaking_content[21];
        
        _speech_location=_speaking_content[20];
    }
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:_speech_location];
    utterance.rate=0.2;
    
    
    [_synth speakUtterance:utterance];
    
    self.myLabel.text=_speech_location;
    self.preLabel.text=_previous_location;
    self.nexLabel.text=_next_location;
    
    NSString *counterString =self.myLabel.text;
    NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[counterString] forKeys:@[@"counterValue"]];
    
    NSLog(@"send location!!!");
    [[WCSession defaultSession] sendMessage:applicationData
                               replyHandler:^(NSDictionary *reply) {
                                   //handle reply from iPhone app here
                               }
                               errorHandler:^(NSError *error) {
                                   //catch any errors here
                               }
     ];
    
}

@end


