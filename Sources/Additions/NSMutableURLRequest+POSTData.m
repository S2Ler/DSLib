
#import "NSMutableURLRequest+POSTData.h"


@implementation NSMutableURLRequest (POSTData)
- (void)setPostDataWithInfo:(DSPostDataInfo *)info
{
  NSString *boundary = @"----WebKitFormBoundaryYA9vSekClgZaHxyb";

  NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];

  [self addValue:contentType forHTTPHeaderField:@"Content-Type"];

  NSString *boundaryString = [NSString stringWithFormat:@"\r\n--%@\r\n", boundary];

  NSString *boundaryStringFinal = [NSString stringWithFormat:@"\r\n--%@--\r\n", boundary];

  NSMutableData *postData = [NSMutableData data];

  [postData appendData:[boundaryString dataUsingEncoding:NSUTF8StringEncoding]];

  NSString *formDataHeader = nil;

  if ([info POSTDataFileName]) {
    if ([info POSTDataKey]) {
      formDataHeader
        = [NSString stringWithFormat:
                      @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: application/octet-stream\r\n\r\n",
                      [info POSTDataKey], [info POSTDataFileName]];
    }
    else {
      formDataHeader
        = [NSString stringWithFormat:
                      @"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\nContent-Type: application/octet-stream\r\n\r\n",
                      [info POSTDataFileName]];
    }
  }
  else if ([info POSTDataKey]) {
    formDataHeader = [NSString stringWithFormat:
                                 @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",
                                 [info POSTDataKey]];
  }
  else {
    formDataHeader
      = [NSString stringWithFormat:
                    @"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\nContent-Type: application/octet-stream\r\n\r\n",
                    @"POST.dat"];
  }

  [postData appendData:[formDataHeader dataUsingEncoding:NSUTF8StringEncoding]];

  NSData *mainPostData = nil;

  if ([info POSTData]) {
    mainPostData = [info POSTData];
  }
  else if ([info POSTDataPath]) {
    mainPostData = [NSData dataWithContentsOfFile:info.POSTDataPath options:NSDataReadingMappedIfSafe error:nil];
  }

  [postData appendData:mainPostData];
  [postData appendData:[boundaryStringFinal dataUsingEncoding:NSUTF8StringEncoding]];
  [self setHTTPBody:postData];

  NSString *dataLength = [NSString stringWithFormat:@"%llu", (unsigned long long)[postData length]];

  [self addValue:dataLength forHTTPHeaderField:@"Content-Length"];
}

@end

@implementation DSPostDataInfo
@end
