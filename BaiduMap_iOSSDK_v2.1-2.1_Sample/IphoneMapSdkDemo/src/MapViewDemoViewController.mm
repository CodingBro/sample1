//
//  MapViewDemoController.m
//  BaiduMapSdkSrc
//
//  Created by BaiduMapAPI on 13-3-24.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import "MapViewDemoViewController.h"
#import "BMapKit.h"

@implementation MapViewDemoViewController
@synthesize segment;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
//        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    segment.selectedSegmentIndex = 0;
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    [super dealloc];
    if (_mapView) {
        [_mapView release];
        _mapView = nil;
    }
}
//普通底图＋卫星图＋路况图＋路况卫星图切换
-(IBAction)changeMapType:(id)sender
{
    int index = segment.selectedSegmentIndex;
    switch (index) {
        case 0:
            _mapView.mapType = BMKMapTypeStandard;
            break;
        case 1:
            _mapView.mapType = BMKMapTypeSatellite;
            break;
        case 2:
            _mapView.mapType = BMKMapTypeTrafficOn;
            break;
        case 3:
            _mapView.mapType = BMKMapTypeTrafficAndSatellite;
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}




@end
