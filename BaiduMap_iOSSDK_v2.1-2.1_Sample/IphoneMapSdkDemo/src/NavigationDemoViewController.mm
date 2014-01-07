//
//  NavigationDemoViewController.mm
//  BaiduMapApiDemo
//
//  Copyright 2011 Baidu Inc. All rights reserved.
//

#import "NavigationDemoViewController.h"
#import "BMKNavigation.h"

@implementation NavigationDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    //初始化右边的更新按钮
    UIBarButtonItem *customRightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"说明" style:UIBarButtonItemStyleBordered target:self action:@selector(showGuide)];
    self.navigationItem.rightBarButtonItem = customRightBarButtonItem;
    [customRightBarButtonItem release];

}

-(void)viewWillAppear:(BOOL)animated {
//    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
    if (_mapView) {
        [_mapView release];
        _mapView = nil;
    }
}
//显示说明
-(void)showGuide
{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"调启导航－说明" message:@"本示例为调启两种导航（客户端导航和Web导航）的基本使用方法。\n1）确定起终点时有两种方法：经纬度和名称，两者都提供时优先用经纬度，无经纬度时用名称。\n2）百度地图客户端导航默认以当前位置作为起点进行导航，所以只需定义终点即可。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
    [myAlertView show];
    [myAlertView release];
}

- (IBAction)nativeNavi
{
    //初始化调启导航时的参数管理类
    NaviPara* para = [[NaviPara alloc]init];
    //指定导航类型
    para.naviType = NAVI_TYPE_NATIVE;
    
    //初始化终点节点
    BMKPlanNode* end = [[[BMKPlanNode alloc]init] autorelease];
    //指定终点经纬度
    CLLocationCoordinate2D coor2;
	coor2.latitude = _nativeEndLatitude.text.floatValue;
	coor2.longitude = _nativeEndLongitude.text.floatValue;
	end.pt = coor2;
    //指定终点名称
    end.name = _nativeEndName.text;
    //指定终点
    para.endPoint = end;
    
    //指定返回自定义scheme
    para.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    
    //调启百度地图客户端导航
    [BMKNavigation openBaiduMapNavigation:para];
    [para release];
}

- (IBAction)webNavi
{
    //初始化调启导航时的参数管理类
    NaviPara* para = [[NaviPara alloc]init];
    //指定导航类型
    para.naviType = NAVI_TYPE_WEB;
    
    //初始化起点节点
    BMKPlanNode* start = [[[BMKPlanNode alloc]init] autorelease];
    //指定起点经纬度
    CLLocationCoordinate2D coor1;
    coor1.latitude = _webStartLatitude.text.floatValue;
	coor1.longitude = _webStartLongitude.text.floatValue;
    start.pt = coor1;
    //指定起点名称
    start.name = _webStartName.text;
    //指定起点
    para.startPoint = start;
    
    
    //初始化终点节点
    BMKPlanNode* end = [[[BMKPlanNode alloc]init] autorelease];
    CLLocationCoordinate2D coor2;
	coor2.latitude = _webEndLatitude.text.floatValue;
	coor2.longitude = _webEndLongitude.text.floatValue;;
	end.pt = coor2;
    para.endPoint = end;
    //指定终点名称
    end.name = _webEndName.text;
    //指定调启导航的app名称
    para.appName = [NSString stringWithFormat:@"%@", @"testAppName"];
    //调启web导航
    [BMKNavigation openBaiduMapNavigation:para];
    [para release];
}
-(IBAction)textFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
    [UIView animateWithDuration:0.3f animations:^{
        if(self.view.frame.origin.y!=0)
        self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+160,self.view.frame.size.width,self.view.frame.size.height);
    }];

}
- (IBAction)textViewDidBeginEditing:(id)sender{
    [sender becomeFirstResponder];
    [UIView animateWithDuration:0.3f animations:^{
    if(self.view.frame.origin.y==0)
    {
        self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-160,self.view.frame.size.width,self.view.frame.size.height);

    }
}];
}
@end
