
#import "MyManager.h"

@implementation MyManager

@synthesize URL,EmpCode,EmpName;


#pragma mark Singleton Methods

+ (id)sharedManager {
    static MyManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        URL = [[NSString alloc] initWithString:@"http://192.168.0.6/GetEmployees.svc/"];
        EmpName=@"";
        EmpCode=@"";
    }
    return self;
}

@end