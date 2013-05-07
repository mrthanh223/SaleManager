#import <foundation/Foundation.h>

@interface MyManager : NSObject {
    NSString *URL;
    NSString *EmpName;
    NSString *EmpCode;
}

@property (nonatomic, retain) NSString *URL;
@property (nonatomic, retain) NSString *EmpName;
@property (nonatomic, retain) NSString *EmpCode;
+ (id)sharedManager;

@end