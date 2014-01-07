//
//  BusLineSearchViewController.m
//  BaiduMapApiDemoSrc
//
//  Created by baidu on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BusLineSearchViewController.h"


#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface RouteAnnotation : BMKPointAnnotation
{
	int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘
	int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation BusLineSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
//        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    _mapView.delegate = self;
	_search = [[BMKSearch alloc]init];
    currentIndex = -1;
    
    _busPoiArray = [[NSMutableArray alloc]init];
    
	_search.delegate = self;
    
	_cityText.text = @"北京";
	_busLineText.text  = @"717";
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _search.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _search.delegate = nil; // 不用时，置nil
}



- (NSString*)getMyBundlePath1:(NSString *)filename
{
	
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
		return s;
	}
	return nil ;
}


- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
	BMKAnnotationView* view = nil;
	switch (routeAnnotation.type) {
		case 0:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 1:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 2:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 3:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 4:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"] autorelease];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
			
		}
			break;
		default:
			break;
	}
	
	return view;
}

#pragma mark -
#pragma mark imeplement BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[RouteAnnotation class]]) {
		return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
	}
	return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{	
	if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[[BMKPolylineView alloc] initWithOverlay:overlay] autorelease];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
	return nil;
}

#pragma mark -
#pragma mark implement BMKSearchDelegate

- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
	if (error == BMKErrorOk) {
		BMKPoiResult* result = [poiResultList objectAtIndex:0];
        BMKPoiInfo* poi = nil;
        BOOL findBusline = NO;
		for (int i = 0; i < result.poiInfoList.count; i++) {
			poi = [result.poiInfoList objectAtIndex:i];
            if (poi.epoitype == 2) {
                findBusline = YES;
                [_busPoiArray addObject:poi];
            }
		}
        //开始bueline详情搜索
        if(findBusline)
        {
            currentIndex = 0;
            NSString* strKey = ((BMKPoiInfo*) [_busPoiArray objectAtIndex:currentIndex]).uid;
            BOOL flag = [_search busLineSearch:_cityText.text withKey:strKey];
            if (flag) {
                NSLog(@"search success.");
            }
            else{
                NSLog(@"search failed!");
            }
        }
	}
}
-(void)onGetBusDetailResult:(BMKBusLineResult *)busLineResult errorCode:(int)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
    if (error == BMKErrorOk) {
               
        //起点
        RouteAnnotation* item = [[RouteAnnotation alloc]init];
       
        item.coordinate = busLineResult.mBusRoute.startPt;
        BMKStep* tempstep = [busLineResult.mBusRoute.steps objectAtIndex:0];

        item.title = tempstep.content;
        
        item.type = 0;
        [_mapView addAnnotation:item];
        [item release];
        
        //终点
        item = [[RouteAnnotation alloc]init];
        item.coordinate = busLineResult.mBusRoute.endPt;
        item.type = 1;
        tempstep = [busLineResult.mBusRoute.steps objectAtIndex:busLineResult.mBusRoute.steps.count-1];
        item.title = tempstep.content;
        [_mapView addAnnotation:item];
        [item release];
        
        //站点信息
        int size = 0;   
        size = busLineResult.mBusRoute.steps.count;
        for (int j = 0; j < size; j++) {
            BMKStep* step = [busLineResult.mBusRoute.steps objectAtIndex:j];
            item = [[RouteAnnotation alloc]init];
            item.coordinate = step.pt;
            item.title = step.content;
            item.degree = step.degree * 30;
            item.type = 2;
            [_mapView addAnnotation:item];
            [item release];
        }          
          
        
        //路段信息
        int index = 0;
        //累加index为下面声明数组temppoints时用
        for (int j = 0; j < busLineResult.mBusRoute.pointsCount; j++) {
            int len = [busLineResult.mBusRoute getPointsNum:j];
            index += len;
        }
        //直角坐标划线
        BMKMapPoint * temppoints = new BMKMapPoint[index];
        index = 0;
		for (int i = 0; i < 1; i++) {
			for (int j = 0; j < busLineResult.mBusRoute.pointsCount; j++) {
				int len = [busLineResult.mBusRoute getPointsNum:j];
                for(int k=0;k<len;k++) {
                    BMKMapPoint pointarray;
                    pointarray.x = [busLineResult.mBusRoute getPoints:j][k].x;
                    pointarray.y = [busLineResult.mBusRoute getPoints:j][k].y;
                    temppoints[k] = pointarray;
                }
				index += len;
			}
        }
        
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:index];
		[_mapView addOverlay:polyLine];
		delete []temppoints;

        [_mapView setCenterCoordinate:busLineResult.mBusRoute.startPt animated:YES];
            
    }
}


-(IBAction)onClickBusLineSearch {
    [_busPoiArray removeAllObjects];
	BOOL flag = [_search poiSearchInCity:_cityText.text withKey:_busLineText.text pageIndex:0];
	if (flag) {
		NSLog(@"search success.");
	}
    else{
        NSLog(@"search failed!");
    }
}
-(IBAction)onClickNextSearch {
    if (_busPoiArray.count > 0) {
        if (++currentIndex >= _busPoiArray.count) {
            currentIndex -= _busPoiArray.count;
        }
        NSString* strKey = ((BMKPoiInfo*) [_busPoiArray objectAtIndex:currentIndex]).uid;
        BOOL flag = [_search busLineSearch:_cityText.text withKey:strKey];
        if (flag) {
            NSLog(@"search success.");
        }
        else{
            NSLog(@"search failed!");
        }
    }
    else {
        BOOL flag = [_search poiSearchInCity:_cityText.text withKey:_busLineText.text pageIndex:0];
        if (flag) {
            NSLog(@"search success.");
        }
        else{
            NSLog(@"search failed!");
        }
    }
}

-(IBAction)textFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [super dealloc];
    if (_search != nil) {
        [_search release];
        _search = nil;
    }
    if (_mapView) {
        [_mapView release];
        _mapView = nil;
    }
    if (_busPoiArray) {
        [_busPoiArray release];
        _busPoiArray = nil;
    }
}

@end
