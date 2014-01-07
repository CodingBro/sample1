//
//  LocationDemoViewController.h
//  BaiduMapSdkSrc
//
//  Created by baidu on 13-4-15.
//  Copyright (c) 2013年 baidu. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BMapKit.h"

@interface LocationDemoViewController :  UIViewController <BMKMapViewDelegate>{
    IBOutlet BMKMapView* _mapView;
    IBOutlet UIButton* startBtn;
    IBOutlet UIButton* stopBtn;
    IBOutlet UIButton* followingBtn;
    IBOutlet UIButton* followHeadBtn;
}
-(IBAction)startLocation:(id)sender;
-(IBAction)stopLocation:(id)sender;
-(IBAction)startFollowing:(id)sender;
-(IBAction)startFollowHeading:(id)sender;
@end

