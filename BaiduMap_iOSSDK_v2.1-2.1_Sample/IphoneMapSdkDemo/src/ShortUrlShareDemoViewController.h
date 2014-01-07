//
//  ShortUrlShareDemoViewController.h
//  BaiduMapApiDemo
//
//  Copyright 2011 Baidu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "BMapKit.h"


@interface ShortUrlShareDemoViewController : UIViewController<BMKMapViewDelegate, BMKSearchDelegate,MFMessageComposeViewControllerDelegate> {
	IBOutlet BMKMapView* _mapView;
    IBOutlet UIButton* _poiShortUrlButton;
    IBOutlet UIButton* _reverseGeoShortUrlButton;
	BMKSearch* _search;
    bool isPoiShortUrlShare;

}
-(IBAction)poiShortUrlShare;
-(IBAction)reverseGeoShortUrlShare;

@end
