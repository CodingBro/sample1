//
//  ViewController.m
//  BaiduMapSdkSrc
//
//  Created by baidu on 13-3-21.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import "RootViewController.h"
#import "MapViewBaseDemoViewController.h"
#import "MapViewDemoViewController.h"
#import "MapViewControlDemoViewController.h"
#import "PoiSearchDemoViewController.h"
#import "BusLineSearchViewController.h"
#import "RouteSearchDemoViewController.h"
#import "LocationDemoViewController.h"
#import "OfflineDemoViewController.h"
#import "AnnotationDemoViewController.h"
#import "GeocodeDemoViewController.h"
#import "CustomOverlayDemoViewController.h"
#import "MapViewUISettingDemoViewController.h"
#import "ShortUrlShareDemoViewController.h"
#import "CloudSearchDemoViewController.h"
#import "NavigationDemoViewController.h"

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _demoNameArray = [[NSArray alloc]initWithObjects:
                      @"基本地图功能-MapViewBaseDemo",
					  @"图层展示功能-MapViewDemo",
                      @"地图操作功能-MapViewControlDemo",
                      @"UI控制功能-MapViewUISettingDemo",
					  @"定位功能-LocationDemo",
					  @"覆盖物功能-AnnotationDemo",
                      @"自定义绘制-CustomOverlayDemo",
					  @"POI搜索功能-PoiSearchDemo",
                      @"地理编码功能-GeocodeDemo",
					  @"路径规划功能-RouteSearchDemo",
                      @"公交线路查询-BusLineSearch",
					  @"离线地图功能-OfflineDemo",
                      @"短串分享功能-ShortUrlShareDemo",
                      @"云检索功能-CloudSearchDemo",
                      @"调启百度导航功能-NavigationDemo",
					  nil];

    NSMutableArray *array = [[NSMutableArray alloc] init];
    MapViewBaseDemoViewController *mapViewBaseDemoViewController = [[[MapViewBaseDemoViewController alloc] init] autorelease];
	mapViewBaseDemoViewController.title = @"基本地图功能";	
	MapViewDemoViewController *mapviewDemoController = [[[MapViewDemoViewController alloc] init] autorelease];
	mapviewDemoController.title = @"图层展示功能";
    MapViewControlDemoViewController *mapviewControlDemoController = [[[MapViewControlDemoViewController alloc] init] autorelease];
	mapviewControlDemoController.title = @"地图操作功能";
    
    MapViewUISettingDemoViewController *mapViewUISettingDemoViewController = [[[MapViewUISettingDemoViewController alloc] init] autorelease];
	mapViewUISettingDemoViewController.title = @"UI控制功能";
	
	LocationDemoViewController *locationDemoController = [[[LocationDemoViewController alloc] init] autorelease];
	locationDemoController.title = @"定位功能";
	
	AnnotationDemoViewController *annotationDemoController = [[[AnnotationDemoViewController alloc] init] autorelease];
	annotationDemoController.title = @"覆盖物功能";
    
    CustomOverlayDemoViewController *customOverlayDemo = [[[CustomOverlayDemoViewController alloc] init] autorelease];
    customOverlayDemo.title = @"自定义绘制";
	
	PoiSearchDemoViewController *poiSearchDemoController = [[[PoiSearchDemoViewController alloc] init] autorelease];
	poiSearchDemoController.title = @"POI搜索功能";
    
    GeocodeDemoViewController *geocodeDemoController = [[[GeocodeDemoViewController alloc] init] autorelease];
	geocodeDemoController.title = @"地理编码功能";
	
	RouteSearchDemoViewController *routeSearchDemoController = [[[RouteSearchDemoViewController alloc] init] autorelease];
	routeSearchDemoController.title = @"路径规划功能";
	
    BusLineSearchViewController *buslineDemoViewController = [[[BusLineSearchViewController alloc] init] autorelease];
	buslineDemoViewController.title = @"公交线路查询";
        	
	OfflineDemoViewController *offlineDemoViewController = [[[OfflineDemoViewController alloc] init] autorelease];
	offlineDemoViewController.title = @"离线地图功能";
    
    ShortUrlShareDemoViewController *shortUrlShareDemoViewController = [[[ShortUrlShareDemoViewController alloc] init] autorelease];
	shortUrlShareDemoViewController.title = @"短串分享功能";
    
    CloudSearchDemoViewController *cloudSearchDemoViewController = [[[CloudSearchDemoViewController alloc] init] autorelease];
	cloudSearchDemoViewController.title = @"云检索功能";
    
    NavigationDemoViewController *navigationDemoViewController = [[[NavigationDemoViewController alloc] init] autorelease];
	navigationDemoViewController.title = @"调启百度导航功能";

	[array addObject:mapViewBaseDemoViewController];
    [array addObject:mapviewDemoController];
    [array addObject:mapviewControlDemoController];
    [array addObject:mapViewUISettingDemoViewController];
	[array addObject:locationDemoController];
	[array addObject:annotationDemoController];
    [array addObject:customOverlayDemo];
	[array addObject:poiSearchDemoController];
    [array addObject:geocodeDemoController];
	[array addObject:routeSearchDemoController];
    [array addObject:buslineDemoViewController];
	[array addObject:offlineDemoViewController];
    [array addObject:shortUrlShareDemoViewController];
    [array addObject:cloudSearchDemoViewController];
    [array addObject:navigationDemoViewController];
    
	_viewControllerArray = array;
	
	self.title = NSLocalizedString(@"BaiduMapApiDemo", @"BaiduMapApiDemo title");
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _demoNameArray.count;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"BaiduMapApiDemoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [[_demoNameArray objectAtIndex:indexPath.section] copy];
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController* viewController = [_viewControllerArray objectAtIndex:indexPath.section];
    UIBarButtonItem *customLeftBarButtonItem = [[UIBarButtonItem alloc] init];
    customLeftBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = customLeftBarButtonItem;
    [customLeftBarButtonItem release];
    [self.navigationController pushViewController:viewController animated:YES];

}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc {
	[_demoNameArray release];
    [_viewControllerArray release];
    [super dealloc];
}

@end
