//
//  APLDefaults.h
//  lightblue_bean_control
//
//  Created by 秦暐峻 on 2015/12/1.
//  Copyright © 2015年 sulphate. All rights reserved.
//

#ifndef APLDefaults_h
#define APLDefaults_h

#import <Foundation/Foundation.h>

extern NSString *BeaconIdentifier;


@interface APLDefaults : NSObject

+ (APLDefaults *)sharedDefaults;

@property (nonatomic, copy, readonly) NSArray *supportedProximityUUIDs;

@property (nonatomic, copy, readonly) NSUUID *defaultProximityUUID;
@property (nonatomic, copy, readonly) NSNumber *defaultPower;
@end



#endif /* APLDefaults_h */
