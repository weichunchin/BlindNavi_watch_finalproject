//
//  NaviViewController.h
//  lightblue_bean_control
//
//  Created by 秦暐峻 on 2015/12/1.
//  Copyright © 2015年 sulphate. All rights reserved.
//

#ifndef NaviViewController_h
#define NaviViewController_h

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <WatchConnectivity/WatchConnectivity.h>

@interface NaviViewController : UIViewController <WCSessionDelegate,UITextFieldDelegate> {
    AVAudioPlayer *player;
    IBOutlet UILabel *myLabel;
    IBOutlet UILabel *preLabel;
    IBOutlet UILabel *nexLabel;
}

@property (nonatomic, strong) UILabel *myLabel;
@property (nonatomic, strong) UILabel *preLabel;
@property (nonatomic, strong) UILabel *nexLabel;
@end


#endif /* NaviViewController_h */
