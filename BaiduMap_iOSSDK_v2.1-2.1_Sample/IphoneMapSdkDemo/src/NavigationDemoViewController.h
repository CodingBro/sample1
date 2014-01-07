//
//  RouteSearchDemoViewController.h
//  BaiduMapApiDemo
//
//  Copyright 2011 Baidu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface NavigationDemoViewController : UIViewController<BMKMapViewDelegate> {
	IBOutlet BMKMapView* _mapView;//.xib里要有BMKMapView类用于初始化数据驱动
	IBOutlet UITextField* _nativeEndLongitude;
	IBOutlet UITextField* _nativeEndLatitude;
    IBOutlet UITextField* _nativeEndName;
	IBOutlet UITextField* _webStartLongitude;
    IBOutlet UITextField* _webStartLatitude;
	IBOutlet UITextField* _webStartName;
    IBOutlet UITextField* _webEndLongitude;
    IBOutlet UITextField* _webEndLatitude;
	IBOutlet UITextField* _webEndName;
}

- (IBAction)nativeNavi;
- (IBAction)webNavi;
- (IBAction)textFiledReturnEditing:(id)sender;
- (IBAction)textViewDidBeginEditing:(id)sender;
@end
