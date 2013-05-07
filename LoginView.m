//
//  LoginView.m
//  SaleManager
//
//  Created by Hieu Phan on 4/16/13.
//  Copyright (c) 2013 Hieu Phan. All rights reserved.
//

#import "LoginView.h"
#import "ScanView.h"
#import "MyManager.h"
@interface LoginView ()
{
    NSMutableData*      m_webData;
    NSURLConnection*    m_connection;
    NSString *          m_urlString;
    NSURL *             m_url;
    NSData*             m_data;
    NSError *           m_error;
    NSMutableArray*     m_nhanvien;
}
@end

@implementation LoginView
{
    MyManager *sharedManager;
    NSString* m_loginStt;
}
@synthesize txbPassWord,txbUserName,lbSttLogin;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    m_nhanvien = [[NSMutableArray alloc] init];
    sharedManager= [MyManager sharedManager];
    
    [[self view] endEditing:YES];
    self.view.userInteractionEnabled = TRUE;
    m_urlString =  sharedManager.URL;
    m_urlString=[m_urlString stringByAppendingString: @"login/sa/123"];
    
    
    
    m_url = [NSURL URLWithString:m_urlString];
    
    m_data = [NSData dataWithContentsOfURL:m_url];
    
    
    NSError *error;
    
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:m_data options:kNilOptions error:&error];
    
    m_loginStt= [json objectForKey:@"LoginResult"];
    if([m_loginStt isEqualToString:@"Successful"])
    {
        lbSttLogin.text=@"Database  is ready";
    }
    else{
        txbPassWord.enabled=false;
        txbUserName.enabled=false;
        lbSttLogin.text=@"Can't connect to Database";
    }
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txbPassWord resignFirstResponder];
    [txbUserName resignFirstResponder];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_LG_Login:(id)sender {
    if([txbUserName.text isEqualToString:@""] ||[txbPassWord.text isEqualToString:@""])
     {
     lbSttLogin.text=@"User name or password not null";
     return;
     }
    
    
    
   
    m_urlString =  sharedManager.URL;
    m_urlString=[m_urlString stringByAppendingString: @"Get_nhanvien/"];
    m_urlString=[m_urlString stringByAppendingString: txbUserName.text];
    m_url = [NSURL URLWithString:m_urlString];
    m_data = [NSData dataWithContentsOfURL:m_url];
    NSError *error;
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:m_data options:kNilOptions error:&error];
    
    NSString* nv_machucvu  ;
    NSString* nv_manv      ;
    NSString* nv_password  ;
    NSString* nv_ten       ;
    NSString* nv_trangthai ;
    m_nhanvien = [json objectForKey:@"Get_nhanvienResult"];
    for(NSDictionary* nhanvien in m_nhanvien)
    {
        nv_machucvu   = (NSString*)[nhanvien objectForKey:@"MaChucVu"];
        nv_manv       = (NSString*)[nhanvien objectForKey:@"MaNV"];
        nv_password   = (NSString*)[nhanvien objectForKey:@"Password"];
        nv_ten        = (NSString*)[nhanvien objectForKey:@"TenNV"];
        nv_trangthai  = (NSString*)[nhanvien objectForKey:@"TrangThai"];
        
       
    }
     if(m_nhanvien.count==0)
     {
         lbSttLogin.text=@"User name not exit";
     }
    else
        if([nv_password isEqualToString: txbPassWord.text])
        {
            lbSttLogin.text=@"Sucsessfull";
            sharedManager.EmpCode=nv_manv;
            sharedManager.EmpName=nv_ten;
            ScanView *obj = [[ScanView alloc] initWithNibName:@"ScanView" bundle:nil];
             UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
             navigationController.navigationBarHidden = YES;
             navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
             [self.navigationController presentViewController:navigationController animated:YES completion:nil];
             [UIView commitAnimations];
            
        }
    else
    {
        lbSttLogin.text=@"Password not correct";
    }
}
- (void)dealloc {
    [txbUserName release];
    [txbPassWord release];
    [lbSttLogin release];
    [super dealloc];
}
- (IBAction)txbEditEnd:(id)sender {
    lbSttLogin.text=@"";
}

- (IBAction)txbEditBegin:(id)sender {
    lbSttLogin.text=@"";
}
@end
