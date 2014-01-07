//
//  AnnotationDemoViewController.m
//  BaiduMapApiDemo
//
//  Copyright 2011 Baidu Inc. All rights reserved.
//
#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]
#import "AnnotationDemoViewController.h"
@interface AnnotationDemoViewController ()
{
    BMKCircle* circle;
    BMKPolygon* polygon;
    BMKPolygon* polygon2;
    BMKPolyline* polyline;
    BMKGroundOverlay* ground;
    BMKGroundOverlay* ground2;
    BMKPointAnnotation* pointAnnotation;
    BMKAnnotationView* newAnnotation;
    
}
@end

@implementation AnnotationDemoViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
//        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    //设置地图缩放级别
    [_mapView setZoomLevel:11];
    //初始化segment
    segment.selectedSegmentIndex=0;    
    //添加内置覆盖物
    [self addOverlayView];

}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)dealloc {
    [super dealloc];
    if (_mapView) {
        [_mapView release];
        _mapView = nil;
    }
}
//segment进行切换
- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    UISegmentedControl *tempSeg = (UISegmentedControl *)sender;
    //内置覆盖物
    if(tempSeg.selectedSegmentIndex==0)
    {
        //添加内置覆盖物
        [self addOverlayView];
        //删除标注
        if (pointAnnotation != nil)
        {
            [_mapView removeAnnotation:pointAnnotation];
            pointAnnotation=nil;
            [newAnnotation release];
            newAnnotation=nil;
        }
        //删除图片图层覆盖物
        if (ground != nil)
        {
            [_mapView removeOverlay:ground];
            ground=nil;
        }
        if (ground2 != nil)
        {
            [_mapView removeOverlay:ground2];
            ground2=nil;
        }

    }
    //添加标注
    else if(tempSeg.selectedSegmentIndex==1)
    {
        //删除圆形覆盖物
        if (circle != nil)
        {
            [_mapView removeOverlay:circle];
            circle=nil;
        }
        //删除多边形覆盖物
        if (polygon != nil)
        {
            [_mapView removeOverlay:polygon];
            polygon=nil;
        }
        //删除多边形覆盖物
        if (polygon2 != nil)
        {
            [_mapView removeOverlay:polygon2];
            polygon2=nil;
        }

        //删除折线覆盖物
        if (polyline != nil)
        {
            [_mapView removeOverlay:polyline];
            polyline=nil;
        }
        // 添加一个PointAnnotation
        if (pointAnnotation == nil) {
            [self addPointAnnotation];
        }
        //删除图片图层覆盖物
        if (ground != nil)
        {
            [_mapView removeOverlay:ground];
            ground=nil;
        }
        //删除图片图层覆盖物
        if (ground2 != nil)
        {
            [_mapView removeOverlay:ground2];
            ground2=nil;
        }

    }
    //添加图片图层
    else if(tempSeg.selectedSegmentIndex==2)
    {
        //删除圆形覆盖物
        if (circle != nil)
        {
            [_mapView removeOverlay:circle];
            circle=nil;
        }
        //删除多边形覆盖物
        if (polygon != nil)
        {
            [_mapView removeOverlay:polygon];
            polygon=nil;
        }
        //删除多边形覆盖物
        if (polygon2 != nil)
        {
            [_mapView removeOverlay:polygon2];
            polygon2=nil;
        }

        //删除折线覆盖物
        if (polyline != nil)
        {
            [_mapView removeOverlay:polyline];
            polyline=nil;
        }
        //删除标注
        if (pointAnnotation != nil)
        {
            [_mapView removeAnnotation:pointAnnotation];
            pointAnnotation=nil;
            [newAnnotation release];
            newAnnotation=nil;
        }
        //添加图片图层覆盖物(第一种)
        if (ground == nil) {
            CLLocationCoordinate2D coors;
            coors.latitude = 39.800;
            coors.longitude = 116.404;
            ground = [BMKGroundOverlay groundOverlayWithPosition:coors zoomLevel:11 anchor:CGPointMake(0.0f,0.0f) icon:[UIImage imageWithContentsOfFile:[self getMyBundlePath:@"images/test.png"]]];
            [_mapView addOverlay:ground];
        }
        //添加图片图层覆盖物(第二种)
        if (ground2 == nil) {            
            CLLocationCoordinate2D coords[2] = {0};            
            coords[0].latitude = 39.910;
            coords[0].longitude = 116.370;
            coords[1].latitude = 39.950;
            coords[1].longitude = 116.430;
            
            BMKCoordinateBounds bound;
            bound.southWest = coords[0];
            bound.northEast = coords[1];                        
            ground2 = [BMKGroundOverlay groundOverlayWithBounds:bound icon:[UIImage imageWithContentsOfFile:[self getMyBundlePath:@"images/test.png"]]];
            [_mapView addOverlay:ground2];
            
        }

    }
    
    
}
- (NSString*)getMyBundlePath:(NSString *)filename
{
	
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
//        NSLog(@"%@",s);
		return s;
	}
	return nil ;
}

//添加内置覆盖物
- (void)addOverlayView
{
    // 添加圆形覆盖物
    if (circle == nil) {
        CLLocationCoordinate2D coor;
        coor.latitude = 39.915;
        coor.longitude = 116.404;
        circle = [BMKCircle circleWithCenterCoordinate:coor radius:5000];
        [_mapView addOverlay:circle];
    }
    // 添加多边形覆盖物
    if (polygon == nil) {
        CLLocationCoordinate2D coords[4] = {0};
        coords[0].latitude = 39.915;
        coords[0].longitude = 116.404;
        coords[1].latitude = 39.815;
        coords[1].longitude = 116.404;
        coords[2].latitude = 39.815;
        coords[2].longitude = 116.504;
        coords[3].latitude = 39.915;
        coords[3].longitude = 116.504;
        polygon = [BMKPolygon polygonWithCoordinates:coords count:4];
        [_mapView addOverlay:polygon];
    }
    // 添加多边形覆盖物
    if (polygon2 == nil) {
        CLLocationCoordinate2D coords[5] = {0};
        coords[0].latitude = 39.965;
        coords[0].longitude = 116.604;
        coords[1].latitude = 39.865;
        coords[1].longitude = 116.604;
        coords[2].latitude = 39.865;
        coords[2].longitude = 116.704;
        coords[3].latitude = 39.905;
        coords[3].longitude = 116.654;
        coords[4].latitude = 39.965;
        coords[4].longitude = 116.704;
        polygon2 = [BMKPolygon polygonWithCoordinates:coords count:5];
        [_mapView addOverlay:polygon2];
    }
    //添加折线覆盖物
    if (polyline == nil) {
        CLLocationCoordinate2D coors[2] = {0};
        coors[0].latitude = 39.895;
        coors[0].longitude = 116.354;
        coors[1].latitude = 39.815;
        coors[1].longitude = 116.304;
        polyline = [BMKPolyline polylineWithCoordinates:coors count:2];
        [_mapView addOverlay:polyline];
    }
}

//添加标注
- (void)addPointAnnotation
{
    pointAnnotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = 39.915;
    coor.longitude = 116.404;
    pointAnnotation.coordinate = coor;
    pointAnnotation.title = @"test";
    pointAnnotation.subtitle = @"此Annotation可拖拽!";
    [_mapView addAnnotation:pointAnnotation];
    [pointAnnotation release];
 
}
//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKCircle class]])
    {
        BMKCircleView* circleView = [[[BMKCircleView alloc] initWithOverlay:overlay] autorelease];
        circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        circleView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        circleView.lineWidth = 5.0;
		return circleView;
    }
    
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView* polylineView = [[[BMKPolylineView alloc] initWithOverlay:overlay] autorelease];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1];
        polylineView.lineWidth = 3.0;
		return polylineView;
    }
	
	if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygonView* polygonView = [[[BMKPolygonView alloc] initWithOverlay:overlay] autorelease];
        polygonView.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
        polygonView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        polygonView.lineWidth =2.0;
		return polygonView;
    }
    if ([overlay isKindOfClass:[BMKGroundOverlay class]])
    {
        BMKGroundOverlayView* groundView = [[[BMKGroundOverlayView alloc] initWithOverlay:overlay] autorelease];
		return groundView;
    }
	return nil;
}

#pragma mark -
#pragma mark implement BMKMapViewDelegate

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"renameMark";
    if (newAnnotation == nil) {
        newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置颜色
		((BMKPinAnnotationView*)newAnnotation).pinColor = BMKPinAnnotationColorPurple;
        // 从天上掉下效果
		((BMKPinAnnotationView*)newAnnotation).animatesDrop = YES;
        // 设置可拖拽
		((BMKPinAnnotationView*)newAnnotation).draggable = YES;
    }
    return newAnnotation;

}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
}


@end
