//
//  LoginView.h
//  SaleManager
//
//  Created by Hieu Phan on 4/16/13.
//  Copyright (c) 2013 Hieu Phan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIViewController
- (IBAction)btn_LG_Login:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *txbUserName;
@property (retain, nonatomic) IBOutlet UITextField *txbPassWord;
@property (retain, nonatomic) IBOutlet UILabel *lbSttLogin;
- (IBAction)txbEditEnd:(id)sender;
- (IBAction)txbEditBegin:(id)sender;

@end
