
@import Foundation;

@interface DSPostDataInfo : NSObject
/** if not nil this request will use HTTP POST method to send the data */
@property (nonatomic, strong) NSData *POSTData;

/** If not nil this request will use HTTP POST method to send data from
 this path. If POSTData property also has been set this property takes
 priority */
@property (nonatomic, strong) NSString *POSTDataPath;

/** If not nil and POSTDataFileName == nil, POSTData will be sent
 as parameter data, otherwise as file. */
@property (nonatomic, strong) NSString *POSTDataKey;

/** The file name for the POST form-data request */
@property (nonatomic, strong) NSString *POSTDataFileName;
@end

@interface NSMutableURLRequest (POSTData)
- (void)setPostDataWithInfo:(DSPostDataInfo *)postDataInfo;
@end
