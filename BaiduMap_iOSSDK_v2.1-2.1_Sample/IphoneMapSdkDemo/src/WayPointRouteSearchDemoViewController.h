//
//  WayPointRouteSearchDemoViewController.h
//  IphoneMapSdkDemo
//
//  Created by baidu on 13-7-14.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface WayPointRouteSearchDemoViewController : UIViewController <BMKMapViewDelegate, BMKSearchDelegate> {
    IBOutlet UITextField* _startAddrText;
    IBOutlet UITextField* _wayPointAddrText;
    IBOutlet UITextField* _endAddrText;
    IBOutlet BMKMapView* _mapView;
    BMKSearch* _search;

}

-(IBAction)onDriveSearch;
- (IBAction)textFiledReturnEditing:(id)sender;

@end
