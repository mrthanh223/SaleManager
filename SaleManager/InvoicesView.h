//
//  InvoicesView.h
//  SaleManager
//
//  Created by Hieu Phan on 4/18/13.
//  Copyright (c) 2013 Hieu Phan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvoicesView : UIViewController<UITableViewDataSource, UITableViewDelegate>
- (IBAction)invoice_back_btn:(id)sender;
@property (retain, nonatomic) IBOutlet UITableView *tb_hd;
@property (retain, nonatomic) IBOutlet UILabel *lb_Invo_Date;
@property (retain, nonatomic) IBOutlet UILabel *lb_Invo_Total;
@property (retain, nonatomic) IBOutlet UILabel *lb_Invo_Payment;
@property (retain, nonatomic) IBOutlet UILabel *lb_Invo_Change;
@property (retain, nonatomic) IBOutlet UILabel *lb_Invo_EmpCode;
@property (retain, nonatomic) IBOutlet UILabel *lb_Invo_EmpName;

@end
