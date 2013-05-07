//
//  ScanView.m
//  SaleManager
//
//  Created by Hieu Phan on 4/16/13.
//  Copyright (c) 2013 Hieu Phan. All rights reserved.
//
#define ROW_HEIGHT      40
#define CELL_WIDTH      320.0

#define LABEL_HEIGHT    20

#define PRODUCT_NAME_OFFSET      10.0
#define PRODUCT_NAME_WIDTH       180.0
#define PRODUCT_NAME_TAG         1

#define PRODUCT_PRICE_OFFSET     185.0
#define PRODUCT_PRICE_WIDTH      180.0
#define PRODUCT_PRICE_TAG        2

#define PRODUCT_COUNT_OFFSET     385.0
#define PRODUCT_COUNT_WIDTH      80.0
#define PRODUCT_COUNT_TAG        3

#define PRODUCT_SUM_OFFSET       550.0
#define PRODUCT_SUM_WIDTH        250.0
#define PRODUCT_SUM_TAG          4

#import "ScanView.h"
#import "MyManager.h"
#import "InvoicesView.h"

@interface ScanView ()
{
    NSMutableData*          m_webData;
    NSURLConnection*        m_connection;
    NSString *              m_urlString;
    NSURL *                 m_url;
    NSData*                 m_data;
    NSError *               m_error;
    NSMutableDictionary*    m_json;
    NSMutableArray*         m_tongtien;
    
    NSMutableArray*         m_arrayProductName;
    NSMutableArray*         m_arrayProductBarcode;
    NSMutableArray*         m_arrayProductPrice;
    NSMutableArray*         m_arrayProductInfomation;
    NSMutableArray*         m_arrayProductCount;
    
    MyManager *             m_sharedManager;
}

@end

@implementation ScanView

@synthesize txb_Scan_Barcode,txb_Scan_Change,txb_Scan_Payment,txb_Scan_ProductCount,
            tbv_Scan_ProductList,lb_Scan_PriceTotal,lb_Scan_ProductInfomation,
            lb_Scan_ProductName,lb_Scan_ProductPrice,btn_Scan_Search,btn_Scan_Add;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self view] endEditing:YES];
    self.view.userInteractionEnabled = TRUE;

    [[self tbv_Scan_ProductList] setDataSource:self];
    [[self tbv_Scan_ProductList] setDelegate:self];
    
    m_arrayProductName = [[NSMutableArray alloc]init];
    m_arrayProductBarcode = [[NSMutableArray alloc] init];
    m_arrayProductPrice = [[NSMutableArray alloc] init];
    m_arrayProductInfomation = [[NSMutableArray alloc] init];
    m_arrayProductCount = [[NSMutableArray alloc] init];
    m_tongtien = [[NSMutableArray alloc] init];
    
    m_sharedManager= [MyManager sharedManager];
    btn_Scan_Search.enabled=false;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txb_Scan_Change resignFirstResponder];
    [txb_Scan_Payment resignFirstResponder];
    [txb_Scan_Barcode resignFirstResponder];
    [txb_Scan_ProductCount resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [txb_Scan_Barcode release];
    [lb_Scan_ProductName release];
    [lb_Scan_ProductPrice release];
    [lb_Scan_ProductInfomation release];
    [txb_Scan_ProductCount release];
    [lb_Scan_PriceTotal release];
    [txb_Scan_Payment release];
    [txb_Scan_Change release];
    [tbv_Scan_ProductList release];
    [btn_Scan_Search release];
    [btn_Scan_Add release];
    [super dealloc];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [m_webData appendData:data];
}

-(void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [m_webData setLength:0];
}

-(void)connection:(NSURLConnection *) connection didFailWithError:(NSError *)error
{
    NSLog(@"Can not connection with Database");
}

-(void)connectionDidFinishLoading:(NSURLConnection *) connection
{
    NSDictionary* allDictionary =[NSJSONSerialization JSONObjectWithData:m_webData options:0 error:nil];
    NSMutableArray* entrys = [allDictionary objectForKey:@"searchResult"];
    
    for (NSDictionary* entry in entrys)
    {
        lb_Scan_ProductName.text=[entry objectForKey:@"TenSp"];
        lb_Scan_ProductInfomation.text=[entry objectForKey:@"CTSP"];
        lb_Scan_ProductPrice.text = [NSString stringWithFormat:@"%@",[entry objectForKey:@"Gia"]];
    }
    if([lb_Scan_ProductName.text isEqualToString:@""])
    {
        btn_Scan_Add.enabled=false;
        
    }
    else
    {
        txb_Scan_ProductCount.enabled=true;
        btn_Scan_Add.enabled=true;
    }
}

- (IBAction)txb_Scan_Payment_BeginChangle:(id)sender {
    txb_Scan_Change.text=[[NSNumber numberWithDouble:[txb_Scan_Payment.text doubleValue]-[lb_Scan_PriceTotal.text doubleValue]] stringValue];
}

- (IBAction)txb_Scan_Barcode_Edit:(id)sender {
    if([txb_Scan_Barcode.text isEqualToString:@""])
    {
        btn_Scan_Search.enabled=false;
    }
    else
        btn_Scan_Search.enabled=true;
    lb_Scan_ProductName.text=@"";
    lb_Scan_ProductInfomation.text=@"";
    lb_Scan_ProductPrice.text = @"";
}

- (void)actionData{
    m_url = [NSURL URLWithString:m_urlString];
    m_data = [NSData dataWithContentsOfURL:m_url];
    m_json = [NSJSONSerialization JSONObjectWithData:m_data options:kNilOptions error:&m_error];
}

- (IBAction)btn_Scan_Add_Click:(id)sender {
    if([txb_Scan_Barcode.text isEqualToString:@""])
    {
        return;
    }
    for(int i=0;i<m_arrayProductBarcode.count;i++)
    {
        if([[m_arrayProductBarcode objectAtIndex:i ]isEqualToString:txb_Scan_Barcode.text])
        {
            NSString* _sumSample=[[NSNumber numberWithInt:[[m_arrayProductCount objectAtIndex:i] intValue]+[txb_Scan_ProductCount.text intValue]] stringValue];
            [m_arrayProductCount replaceObjectAtIndex:i withObject:_sumSample];
            float _total=0;
            for(int i=0;i<m_arrayProductBarcode.count;i++)
            {
                _total+=[[m_arrayProductPrice objectAtIndex:i] floatValue]*[[m_arrayProductCount objectAtIndex:i]floatValue];
            }
            lb_Scan_PriceTotal.text=[[NSNumber numberWithDouble:_total] stringValue];
            [tbv_Scan_ProductList reloadData];
            lb_Scan_ProductName.text=@"";
            lb_Scan_ProductInfomation.text=@"";
            lb_Scan_ProductPrice.text = @"";
            txb_Scan_Barcode.text=@"";
            btn_Scan_Search.enabled=false;
            btn_Scan_Add.enabled=false;
            txb_Scan_ProductCount.text=@"1";
            txb_Scan_ProductCount.enabled=false;
            return;
        }
    }
    [m_arrayProductBarcode addObject:txb_Scan_Barcode.text];
    [m_arrayProductName addObject:lb_Scan_ProductName.text];
    [m_arrayProductPrice addObject:lb_Scan_ProductPrice.text];
    [m_arrayProductInfomation addObject:lb_Scan_ProductInfomation.text];
    if([txb_Scan_ProductCount.text isEqualToString:@""])
        txb_Scan_ProductCount.text=@"1";
    [m_arrayProductCount addObject:txb_Scan_ProductCount.text];
    [self.tbv_Scan_ProductList reloadData];
    float _total=0;
    for(int i=0;i<m_arrayProductBarcode.count;i++)
    {
        _total+=[[m_arrayProductPrice objectAtIndex:i] floatValue]*[[m_arrayProductCount objectAtIndex:i]floatValue];
    }
    lb_Scan_PriceTotal.text=[[NSNumber numberWithDouble:_total] stringValue];
    
    lb_Scan_ProductName.text=@"";
    lb_Scan_ProductInfomation.text=@"";
    lb_Scan_ProductPrice.text = @"";
    txb_Scan_Barcode.text=@"";
    btn_Scan_Search.enabled=false;
    btn_Scan_Add.enabled=false;
    txb_Scan_ProductCount.text=@"1";
    txb_Scan_ProductCount.enabled=false;

}

- (IBAction)btn_Scan_Delete_Click:(id)sender {
    [[self tbv_Scan_ProductList]setEditing:!self.tbv_Scan_ProductList.editing animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        
        [m_arrayProductBarcode removeObjectAtIndex:indexPath.row];
        [m_arrayProductName removeObjectAtIndex:indexPath.row];
        [m_arrayProductPrice removeObjectAtIndex:indexPath.row];
        [m_arrayProductInfomation removeObjectAtIndex:indexPath.row];
        [m_arrayProductCount removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        float _total=0;
        for(int i=0;i<m_arrayProductBarcode.count;i++)
        {
            _total+=[[m_arrayProductPrice objectAtIndex:i] floatValue]*[[m_arrayProductCount objectAtIndex:i]floatValue];
        }
        lb_Scan_PriceTotal.text=[[NSNumber numberWithDouble:_total] stringValue];
        
    }
}

- (IBAction)btn_Scan_ExportInvoices_Click:(id)sender {
    m_urlString =  m_sharedManager.URL;
    m_urlString=[m_urlString stringByAppendingString: @"AddHD"];
    [self actionData];
    
    m_urlString =  m_sharedManager.URL;
    m_urlString=[m_urlString stringByAppendingString: @"Add_nhanvien/"];
    m_urlString=[m_urlString stringByAppendingString:m_sharedManager.EmpCode];
    m_url = [NSURL URLWithString:m_urlString];
    m_data = [NSData dataWithContentsOfURL:m_url];
    m_json = [NSJSONSerialization JSONObjectWithData:m_data options:kNilOptions error:&m_error];
    
    m_urlString =  m_sharedManager.URL;
    m_urlString=[m_urlString stringByAppendingString: @"GetMAHD"];
    [self actionData];
    
    NSString* _maHD= [m_json objectForKey:@"GetMAHDResult"];
    for(int i=0;i<m_arrayProductBarcode.count;i++)
    {
        m_urlString =  m_sharedManager.URL;
        m_urlString=[m_urlString stringByAppendingString: @"Add_CTHD/"];
        m_urlString=[m_urlString stringByAppendingString: (NSString*)[m_arrayProductBarcode objectAtIndex:i]];
        m_urlString=[m_urlString stringByAppendingString: @"/"];
        m_urlString=[m_urlString stringByAppendingString: _maHD];
        m_urlString=[m_urlString stringByAppendingString: @"/"];
        m_urlString=[m_urlString stringByAppendingString: (NSString*)[m_arrayProductCount objectAtIndex:i]];
        m_url = [NSURL URLWithString:m_urlString];
        m_data = [NSData dataWithContentsOfURL:m_url];
        m_json = [NSJSONSerialization JSONObjectWithData:m_data options:kNilOptions error:&m_error];
    }
    
    NSDateFormatter *_formatter;
    NSString        *_dateString;
    
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"MM-dd-yyyy"];
    
    _dateString = [_formatter stringFromDate:[NSDate date]];
    
        
    
    m_urlString =  m_sharedManager.URL;
    m_urlString=[m_urlString stringByAppendingString: @"Get_tongtien/HD10009"];
    [self actionData];
    
        m_tongtien = [m_json objectForKey:@"Get_tongtienResult"];
    //NSString* tem;
    for(NSDictionary* tongtien in m_tongtien)
    {
        lb_Scan_PriceTotal.text= [NSString stringWithFormat:@"%@",[tongtien objectForKey:@"Get_tongtienResult"]];
        
    }
    
    m_urlString =  m_sharedManager.URL;
    m_urlString=[m_urlString stringByAppendingString: @"Add_tien/"];
    m_urlString=[m_urlString stringByAppendingString: txb_Scan_Payment.text];
    m_urlString=[m_urlString stringByAppendingString: @"/"];
    m_urlString=[m_urlString stringByAppendingString: txb_Scan_Change.text];
    m_urlString=[m_urlString stringByAppendingString: @"/"];
    m_urlString=[m_urlString stringByAppendingString: _dateString];
    [self actionData];
    
    InvoicesView *obj = [[InvoicesView alloc] initWithNibName:@"InvoicesView" bundle:nil];
     UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
     navigationController.navigationBarHidden = YES;
     navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
     [self.navigationController presentViewController:navigationController animated:YES completion:nil];
     [UIView commitAnimations];
    
    [_formatter release];

}

- (IBAction)btn_Scan_Search_Click:(id)sender {
    [self.txb_Scan_Barcode resignFirstResponder];
    m_urlString =  m_sharedManager.URL;
    m_urlString=[m_urlString stringByAppendingString: @"search/"];
    m_urlString =[m_urlString stringByAppendingString:txb_Scan_Barcode.text];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:m_urlString]];
    
    m_connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if(m_connection)
    {
        m_webData = [[NSMutableData alloc] init];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString* st1 =@"Name                           ";
    NSString* st2 =@"Price                          ";
    NSString* st3 =@"Count                          ";
    NSString* st4 =@"Total";
    NSString* st = [st1 stringByAppendingString:st2];
    st = [st stringByAppendingString:st3];
    st = [st stringByAppendingString:st4];
    return st;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_arrayProductName count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentified = @"Cell";
    UITableViewCell* cell = [self.tbv_Scan_ProductList dequeueReusableCellWithIdentifier:cellIdentified];
    if(cell == nil)
		cell = [self reuseTableViewCellWithIdentifier:cellIdentified];
    
    UILabel *_lbProductName = (UILabel *)[cell viewWithTag:PRODUCT_NAME_TAG];
	_lbProductName.text = (NSString*)[m_arrayProductName objectAtIndex:indexPath.row];
	
	UILabel *_lbProductPrice = (UILabel *)[cell viewWithTag:PRODUCT_PRICE_TAG];
	_lbProductPrice.text = (NSString*)[m_arrayProductPrice objectAtIndex:indexPath.row];
    
    UILabel *_lbProductCount = (UILabel *)[cell viewWithTag:PRODUCT_COUNT_TAG];
	_lbProductCount.text = (NSString*)[m_arrayProductCount objectAtIndex:indexPath.row];
    
    UILabel *_lbProductSum = (UILabel *)[cell viewWithTag:PRODUCT_SUM_TAG];
	_lbProductSum.text = [NSString stringWithFormat:@"%1.2f", ([_lbProductCount.text floatValue]*[_lbProductPrice.text floatValue])];
    
    return cell;
}

-(UITableViewCell *)reuseTableViewCellWithIdentifier:(NSString *)identifier {
    
	//Rectangle which will be used to create labels and table view cell.
	CGRect cellRectangle;
	
	//Returns a rectangle with the coordinates and dimensions.
	cellRectangle = CGRectMake(0.0, 0.0, CELL_WIDTH, ROW_HEIGHT);
	
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:cellRectangle];
	//Now we have to create the two labels.
	UILabel *_columb;
	
	//Create a rectangle container for the number text.
	cellRectangle = CGRectMake(PRODUCT_NAME_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, PRODUCT_NAME_WIDTH, LABEL_HEIGHT);
	
	//Initialize the label with the rectangle.
	_columb = [[UILabel alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	_columb.tag = PRODUCT_NAME_TAG;
	
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:_columb];
	[_columb release];
	
	//Create a rectangle container for the custom text.
	cellRectangle = CGRectMake(PRODUCT_PRICE_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, PRODUCT_PRICE_WIDTH, LABEL_HEIGHT);
	
	//Initialize the label with the rectangle.
	_columb = [[UILabel alloc] initWithFrame:cellRectangle];
	
	//Mark the label with a tag
	_columb.tag = PRODUCT_PRICE_TAG;
    
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:_columb];
    
    //Create a rectangle container for the custom text.
	cellRectangle = CGRectMake(PRODUCT_COUNT_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, PRODUCT_COUNT_WIDTH, LABEL_HEIGHT);
	
	//Initialize the label with the rectangle.
	_columb = [[UILabel alloc] initWithFrame:cellRectangle];
	
	//Mark the label with a tag
	_columb.tag = PRODUCT_COUNT_TAG;
    
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:_columb];
	[_columb release];
    
    //Create a rectangle container for the number text.
	cellRectangle = CGRectMake(PRODUCT_SUM_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, PRODUCT_SUM_WIDTH, LABEL_HEIGHT);
	
	//Initialize the label with the rectangle.
	_columb = [[UILabel alloc] initWithFrame:cellRectangle];
	
	//Mark the label with a tag
	_columb.tag = PRODUCT_SUM_TAG;
	
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:_columb];
	[_columb release];
    
	return cell;
}
@end
