//
//  ScanView.h
//  SaleManager
//
//  Created by Hieu Phan on 4/16/13.
//  Copyright (c) 2013 Hieu Phan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanView : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITextField *txb_Scan_Barcode;
- (IBAction)txb_Scan_Payment_BeginChangle:(id)sender;
- (IBAction)txb_Scan_Barcode_Edit:(id)sender;
- (IBAction)btn_Scan_Add_Click:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btn_Scan_Add;
- (IBAction)btn_Scan_Delete_Click:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *lb_Scan_ProductName;
@property (retain, nonatomic) IBOutlet UILabel *lb_Scan_ProductPrice;
@property (retain, nonatomic) IBOutlet UILabel *lb_Scan_ProductInfomation;
@property (retain, nonatomic) IBOutlet UIButton *btn_Scan_Search;
@property (retain, nonatomic) IBOutlet UITextField *txb_Scan_ProductCount;
- (IBAction)btn_Scan_ExportInvoices_Click:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *lb_Scan_PriceTotal;
@property (retain, nonatomic) IBOutlet UITextField *txb_Scan_Payment;
@property (retain, nonatomic) IBOutlet UITextField *txb_Scan_Change;
- (IBAction)btn_Scan_Search_Click:(id)sender;
@property (retain, nonatomic) IBOutlet UITableView *tbv_Scan_ProductList;

- (void) actionData;
@end
