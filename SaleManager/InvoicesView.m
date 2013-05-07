//
//  InvoicesView.m
//  SaleManager
//
//  Created by Hieu Phan on 4/18/13.
//  Copyright (c) 2013 Hieu Phan. All rights reserved.
//

#define ROW_HEIGHT      40
#define CELL_WIDTH      320.0

#define LABEL_HEIGHT    20

#define PRODUCT_NAME_OFFSET      10.0
#define PRODUCT_NAME_WIDTH       200.0
#define PRODUCT_NAME_TAG         1

#define PRODUCT_PRICE_OFFSET     180.0
#define PRODUCT_PRICE_WIDTH      100.0
#define PRODUCT_PRICE_TAG        2

#define PRODUCT_COUNT_OFFSET     385.0
#define PRODUCT_COUNT_WIDTH      50.0
#define PRODUCT_COUNT_TAG        3

#define PRODUCT_SUM_OFFSET       550.0
#define PRODUCT_SUM_WIDTH        200.0
#define PRODUCT_SUM_TAG          4




#import "InvoicesView.h"
#import "MyManager.h"
#import "ScanView.h"



@interface InvoicesView ()
{
    NSMutableData*          m_webData_hd;
    NSURLConnection*        m_connection;
    NSString *              m_urlString;
    NSURL *                 m_url;
    NSData*                 m_data;
    NSError *               m_error;
    NSMutableDictionary*    m_json;
    NSMutableArray*         m_tongtien;
    /*
    NSMutableArray*         m_arrayProductName;
    NSMutableArray*         m_arrayProductPrice;
    NSMutableArray*         m_arrayProductInfomation;
    NSMutableArray*         m_arrayProductCount;
*/
    MyManager *             m_sharedManager;
    
    NSMutableArray*                m_hd_name;
    NSMutableArray*                m_hd_price;
    NSMutableArray*                m_hd_count;
    NSMutableArray*                m_hd_total;
}

@end

@implementation InvoicesView
@synthesize lb_Invo_Date,lb_Invo_Change,lb_Invo_Payment,lb_Invo_Total,lb_Invo_EmpCode,lb_Invo_EmpName;
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
    
    m_sharedManager= [MyManager sharedManager];
    
    [[self tb_hd] setDataSource:self];
    [[self tb_hd] setDelegate:self];
    lb_Invo_EmpCode.text=m_sharedManager.EmpCode;
    lb_Invo_EmpName.text=m_sharedManager.EmpName;
    // Do any additional setup after loading the view from its nib.

    m_hd_name       = [[NSMutableArray alloc] init];
    m_hd_price      = [[NSMutableArray alloc] init];
    m_hd_count      = [[NSMutableArray alloc] init];
    m_hd_total      = [[NSMutableArray alloc] init];
    
    
   [self loadTable_View];

    NSDateFormatter *_formatter;
    NSString        *_dateString;
    
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"MM-dd-yyyy"];
    
    _dateString = [_formatter stringFromDate:[NSDate date]];
    lb_Invo_Date.text=_dateString;
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [m_webData_hd appendData:data];
}

-(void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [m_webData_hd setLength:0];
}

-(void)connection:(NSURLConnection *) connection didFailWithError:(NSError *)error
{
    NSLog(@"Can not connection with Database");
}

-(void)connectionDidFinishLoading:(NSURLConnection *) connection
{
    NSDictionary* allDictionary =[NSJSONSerialization JSONObjectWithData:m_webData_hd options:0 error:nil];
    NSMutableArray* entrys = [allDictionary objectForKey:@"Get_HDResult"];
    
    for (NSDictionary* entry in entrys)
    {
         NSString* hd_name      = [entry objectForKey:@"TenSp"];
         NSString* hd_price     = [NSString stringWithFormat:@"%@",[entry objectForKey:@"Gia"]];
         NSString* hd_count     = [NSString stringWithFormat:@"%@",[entry objectForKey:@"SoLuong"]];
         NSString* hd_total     = [NSString stringWithFormat:@"%@",[entry objectForKey:@"TongTien"]];
        
        [m_hd_name addObject:hd_name];
        [m_hd_price addObject:hd_price];
        [m_hd_count addObject:hd_count];
        [m_hd_total addObject:hd_total];
       
    }
    [self.tb_hd reloadData];

}


-(void) loadTable_View{
    m_urlString =  m_sharedManager.URL;;
    m_urlString=[m_urlString stringByAppendingString: @"GetMAHD"];
  //  NSLog(m_urlString);
    m_url = [NSURL URLWithString:m_urlString];
    m_data = [NSData dataWithContentsOfURL:m_url];
    m_json = [NSJSONSerialization JSONObjectWithData:m_data options:kNilOptions error:&m_error];
    
    NSString* _maHD         = [m_json objectForKey:@"GetMAHDResult"];

    //NSLog(_maHD);
    m_urlString             = m_sharedManager.URL;;
    m_urlString             =[m_urlString stringByAppendingString: @"Get_HD/"];
    m_urlString             =[m_urlString stringByAppendingString:_maHD];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:m_urlString]];
    //NSLog(m_urlString);
    m_connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if(m_connection)
    {
        m_webData_hd = [[NSMutableData alloc] init];
    }
    
    m_urlString             = m_sharedManager.URL;
    m_urlString             =[m_urlString stringByAppendingString: @"Get_tongtien/"];
    m_urlString             =[m_urlString stringByAppendingString:_maHD];
    m_url                   = [NSURL URLWithString:m_urlString];
    m_data                  = [NSData dataWithContentsOfURL:m_url];
    m_json                  = [NSJSONSerialization JSONObjectWithData:m_data options:kNilOptions error:&m_error];

   
    m_tongtien              = [m_json objectForKey:@"Get_tongtienResult"];
    
    for(NSDictionary* tongtien in m_tongtien)
    {
        lb_Invo_Total.text  = [NSString stringWithFormat:@"%@",[tongtien objectForKey:@"TongGiaTri"]];
        lb_Invo_Payment.text= [NSString stringWithFormat:@"%@",[tongtien objectForKey:@"TienKhach"]];
        lb_Invo_Change.text = [NSString stringWithFormat:@"%@",[tongtien objectForKey:@"TienTraLai"]];
        
    }

    
  
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_hd_name count];
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString* st1       =@"Name                           ";
    NSString* st2       =@"Price                          ";
    NSString* st3       =@"Count                          ";
    NSString* st4       =@"Total";
    NSString* st        = [st1 stringByAppendingString:st2];
    st = [st stringByAppendingString:st3];
    st = [st stringByAppendingString:st4];
    return st;
    
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentified = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentified];
    if(cell == nil)
		cell = [self reuseTableViewCellWithIdentifier:cellIdentified];

    
    UILabel *_lbProductName = (UILabel *)[cell viewWithTag:PRODUCT_NAME_TAG];
	_lbProductName.text = (NSString*)[m_hd_name objectAtIndex:indexPath.row];
	
	UILabel *_lbProductPrice = (UILabel *)[cell viewWithTag:PRODUCT_PRICE_TAG];
	_lbProductPrice.text = (NSString*)[m_hd_price objectAtIndex:indexPath.row];
    
    UILabel *_lbProductCount = (UILabel *)[cell viewWithTag:PRODUCT_COUNT_TAG];
	_lbProductCount.text = (NSString*)[m_hd_count objectAtIndex:indexPath.row];
    
    UILabel *_lbProductSum = (UILabel *)[cell viewWithTag:PRODUCT_SUM_TAG];
	_lbProductSum.text = (NSString*)[m_hd_total objectAtIndex:indexPath.row];
    
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




- (void)dealloc {
    [_tb_hd release];
    [lb_Invo_Date release];
    [lb_Invo_Total release];
    [lb_Invo_Payment release];
    [lb_Invo_Change release];
    [lb_Invo_EmpCode release];
    [lb_Invo_EmpName release];
    [super dealloc];
}
- (IBAction)invoice_back_btn:(id)sender {
    ScanView *obj = [[ScanView alloc] initWithNibName:@"ScanView" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
    navigationController.navigationBarHidden = YES;
    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
    [UIView commitAnimations];
    
  //  [_formatter release];

}
@end
