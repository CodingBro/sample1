//
//  ShortUrlShareDemoViewController.m
//  BaiduMapApiDemo
//
//  Copyright 2011 Baidu Inc. All rights reserved.
//

#import "ShortUrlShareDemoViewController.h"
#import "BMKAnnotationView.h"
#import "BMKPinAnnotationView.h"
#import "BMKAnnotation.h"
@interface ShortUrlShareDemoViewController ()
{
    //名称
    NSString* geoName;
    //地址
    NSString* addr;
    //坐标
    CLLocationCoordinate2D pt;
    //短串
    NSString* shortUrl;
    //分享字符串
    NSString* showmeg;


}
@end
@implementation ShortUrlShareDemoViewController


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
//        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    //初始化右边的更新按钮
    UIBarButtonItem *customRightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"说明" style:UIBarButtonItemStyleBordered target:self action:@selector(showGuide)];
    self.navigationItem.rightBarButtonItem = customRightBarButtonItem;
    [customRightBarButtonItem release];
    //初始化搜索服务
	_search = [[BMKSearch alloc]init];
    // 设置地图级别
    [_mapView setZoomLevel:13];
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


- (void)viewDidUnload {
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

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
    if(showmeg!=nil)
    {
        [showmeg release];
        showmeg = nil;
    }
    if (addr) {
        [addr release];
        addr = nil;
    }

}
//显示说明
-(void)showGuide
{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"短串分享－说明" message:@"短串分享是将POI点、反Geo点，生成短链接串，此链接可通过短信等形式分享给好友，好友在终端设备点击此链接可快速打开Web地图、百度地图客户端进行信息展示" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
    [myAlertView show];
    [myAlertView release];
}

//1.点击［poi搜索结果分享］先发起poi搜索
-(IBAction)poiShortUrlShare
{    
    BOOL flag = [_search poiSearchInCity:@"北京" withKey:@"故宫博物院" pageIndex:0];
	if (flag) {
		NSLog(@"poi search success.");
        
	}
    else{
        NSLog(@"poi search failed!");
    }
}
//2.搜索成功后在回调中根据uid发起poi短串搜索
- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
    // 清除屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
    
    if (error == BMKErrorOk) {
		BMKPoiResult* result = [poiResultList objectAtIndex:0];
        if(result.poiInfoList.count>0)
        {
            //获取第一个poi点的数据
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:0];
            //将数据保存到图标上
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [_mapView addAnnotation:item];
            _mapView.centerCoordinate = poi.pt;
            [item release];
            //保存数据用于分享
            //名字
            geoName = poi.name;
            //地址
            if (addr) {
                [addr release];
                addr = nil;
            }
            addr = [[NSString alloc] initWithString:poi.address];
            //发起短串搜索获取poi分享url
            BOOL flag = [_search poiDetailShareUrl:poi.uid];
            if (flag) {
                NSLog(@"poiDetailShareUrl search success.");
                
            }
            else{
                NSLog(@"poiDetailShareUrl search failed!");
            }
        }
	} 
}
//1.点击［反向地理编码结果分享］先发起反geo搜索
-(IBAction)reverseGeoShortUrlShare
{    
    //坐标
    NSString* _coordinateXText = @"116.403981";
    NSString* _coordinateYText = @"39.915101";
	pt = (CLLocationCoordinate2D){[_coordinateYText floatValue], [_coordinateXText floatValue]};
    BOOL flag = [_search reverseGeocode:pt];
	if (flag) {
		NSLog(@"ReverseGeocode search success.");
        
	}
    else{
        NSLog(@"ReverseGeocode search failed!");
    }

}
//2.搜索成功后在回调中根据参数发起geo短串搜索
- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
    
	if (error == 0) {
		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
		item.coordinate = result.geoPt;
		item.title = result.strAddr;
		[_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.geoPt;
        [item release];
        //保存数据用于分享用
        //名字－－泡泡上显示的名字，可以自定义
        geoName = @"自定义泡泡名字";
        //地址
        addr = result.strAddr;
        //发起短串搜索获取反geo分享url
        BOOL flag = [_search reverseGeoShareUrl:pt poiName:geoName poiAddress:addr];
        if (flag) {
            NSLog(@"poiDetailShareUrl search success.");
            
        }
        else{
            NSLog(@"poiDetailShareUrl search failed!");
        }
    }
}

//3.返回短串分享url
- (void)onGetShareUrl:(NSString*) url withType:(BMK_SHARE_URL_TYPE) urlType errorCode:(int)error
{
    shortUrl = url;
    if (error == BMKErrorOk)
    {
        if(showmeg!=nil)
        {
            [showmeg release];
            showmeg = nil;
        }
        showmeg = [[NSString stringWithFormat:@"这里是:%@\r\n%@\r\n%@",geoName,addr,shortUrl]retain];
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"短串分享" message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"分享",@"取消",nil];
        myAlertView.tag = 1000;
        [myAlertView show];
        [myAlertView release];
    }

    
}
#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==1000 )
    {
        switch (buttonIndex)
        {
            case 0://确定
            {
                Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
                if (messageClass != nil) {
                    if ([messageClass canSendText]) {
                        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
                        picker.messageComposeDelegate = self;
                        picker.body = [NSString stringWithFormat:@"%@",showmeg];
                        [self presentModalViewController:picker animated:YES];
                        [picker release];
                    } else {
                        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"当前设备暂时没有办法发送短信" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                        [myAlertView show];
                        [myAlertView release];
                    }
                }
                
            }
            case 1://取消
            {
            }
                break;
            default:
            {
                
            }
                break;
        }
    }

}

#pragma mark MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
				 didFinishWithResult:(MessageComposeResult)result
{
	// Notifies users about errors associated with the interface
	switch (result) {
		case MessageComposeResultCancelled:
			//用户自己取消，不用提醒
			break;
		case MessageComposeResultSent:
			//后续可能不能够成功发送，所以暂时不提醒
			break;
		case MessageComposeResultFailed:
            NSLog(@"短信发送失败");
			break;
		default:
            NSLog(@"短信没有发送");
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}
//根据anntation生成对应的标注View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"testMark";
	
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID] autorelease];
		((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
		// 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
	
    // 设置位置
	annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
	annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
}

@end
