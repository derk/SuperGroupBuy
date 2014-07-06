//
//  WebVC.m
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-2.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "WebVC.h"
#import "UIWindow+YzdHUD.h"

#define W 15
#define H 20
@interface WebVC ()
{
    UIWebView *_webView;
}
@end

@implementation WebVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
//    self.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height+44);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.tabBarController.tabBar setHidden:YES];
//    [self.tabBarController.tabBar setTranslucent:NO];
//    self.tabBarController.tabBar.alpha = 0;
    
    

    NSString *urlString = [NSString stringWithFormat:@"%@",self.h5Url];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.backgroundColor = [UIColor whiteColor];
    [_webView loadRequest:request];
    //设置webView 代理，检测加载的过程
    _webView.delegate = self;
    _webView.scrollView.delegate = self;
    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_webView];
    
    
    
    //UIToolBar
    //backButton 后退
    UIButton  *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置当button不能响应交互时显示的图片，状态 UIControlStateDisabled
    [backBtn setImage:[UIImage imageNamed:@"left_disabled.png"] forState:UIControlStateDisabled];
    //设置当button正常响应交互时显示的图片，状态 UIControlStateNormal
    [backBtn setImage:[UIImage imageNamed:@"left_enabled.png"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, W, H);
    //点击后退按钮让webView执行goback方法
    [backBtn addTarget:_webView action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    backItem.enabled = NO;
    //forwardButton 前进
    
    UIButton  *forwardBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置当button不能响应交互时显示的图片，状态 UIControlStateDisabled
    [forwardBtn setImage:[UIImage imageNamed:@"right_disabled.png"] forState:UIControlStateDisabled];
    //设置当button正常响应交互时显示的图片，状态 UIControlStateNormal
    [forwardBtn setImage:[UIImage imageNamed:@"right_enabled.png"] forState:UIControlStateNormal];
    forwardBtn.frame = CGRectMake(0, 0, W, H);
    
    //点击前进按钮让webView执行goForward方法
    [forwardBtn addTarget:_webView action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *forwardItem = [[UIBarButtonItem alloc] initWithCustomView:forwardBtn];
    forwardItem.enabled = NO;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-108, 320, 44)];
    toolBar.tag = 100;
    [self.view addSubview:toolBar];
    [toolBar release];
    
    UIBarButtonItem *spacaItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    //toolBar
    toolBar.items = [NSArray arrayWithObjects:backItem,spacaItem,forwardItem, nil];
    [backItem release];
    [spacaItem release];
    [forwardItem release];
    
    
}
// 设置能否加载网页 YES 可以，NO 不可以
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
//当开始加载网页时触发
- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    NSLog(@"开始加载");
    [self.view.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
}
//当网页加载完毕后触发
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.view.window showHUDWithText:@"加载成功" Type:ShowPhotoYes Enabled:YES];
//    NSLog(@"加载成功");
    // 判断webView 是否能够后退，如果能够后退，将后退按钮交互打开，否则，将后退按钮交互关闭
    if ([webView canGoBack]) {
        [[[(UIToolbar *)[self.view viewWithTag:100] items] objectAtIndex:0] setEnabled:YES];
    }else
    {
        [[[(UIToolbar *)[self.view viewWithTag:100] items] objectAtIndex:0] setEnabled:NO];
    }
    
    //处理webView是否可以前进
    if ([webView canGoForward]) {
        [[[(UIToolbar *)[self.view viewWithTag:100] items] objectAtIndex:2] setEnabled:YES];
    }else
    {
        [[[(UIToolbar *)[self.view viewWithTag:100] items] objectAtIndex:2] setEnabled:NO];
    }
    
    _webView.scrollView.contentOffset = CGPointMake(0, 48);
    
}
//当网页加载失败后触发
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",[error userInfo]);
    [self.view.window showHUDWithText:@"加载失败" Type:ShowPhotoNo Enabled:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [_webView release];
    [super dealloc];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
