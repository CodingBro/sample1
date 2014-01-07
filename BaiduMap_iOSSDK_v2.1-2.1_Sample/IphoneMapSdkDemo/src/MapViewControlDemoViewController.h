//
//  MapViewControlDemoViewController.h
//  BaiduMapSdkSrc
//
//  Created by BaiduMapAPI on 13-7-24.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
@interface MapViewControlDemoViewController :  UIViewController <BMKMapViewDelegate>{
    IBOutlet BMKMapView* _mapView;
    IBOutlet UIButton* _suofang;
    IBOutlet UIButton* _xunzhuan;
    IBOutlet UIButton* _fushi;
    IBOutlet UITextField* _suofangdegree;
    IBOutlet UITextField* _xunzhuandegree;
    IBOutlet UITextField* _fushidegree;
    IBOutlet UILabel* _showMsgLabel;
    
    IBOutlet UIButton* _closeButton;
    IBOutlet UIImageView* _imgView;
    IBOutlet UIView* _hiddenView;
    
    
    
}
- (IBAction)suofangButtonClicked:(id)sender;
- (IBAction)xunzhuanButtonClicked:(id)sender;
- (IBAction)fushiButtonClicked:(id)sender;
- (IBAction)textFiledReturnEditing:(id)sender;
- (IBAction)closeButtonClicked:(id)sender;
@end
