//
//  CloudSearchDemoViewController.h
//  BaiduMapApiDemo
//
//  Copyright 2011 Baidu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"


@interface CloudSearchDemoViewController : UIViewController<BMKMapViewDelegate, BMKCloudSearchDelegate> {
	IBOutlet BMKMapView* _mapView;
    BMKCloudSearch* _search;
}

-(IBAction)onClickLocalSearch;
-(IBAction)onClickNearbySearch;
-(IBAction)onClickBoundSearch;
-(IBAction)onClickDetailSearch;

@end
