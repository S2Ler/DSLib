
#pragma mark - include
#import "PGSMSBridge.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"

#pragma mark - Private
@interface PGSMSBridge() {
  NSInteger _smsLeft;
  
  ASINetworkQueue *_requestsQueue;
}

@property (nonatomic, retain) ASINetworkQueue *requestsQueue;
@property (nonatomic, assign) NSInteger smsLeft;

- (ASIHTTPRequest *)requestForSendingSMS:(NSString *)theMessage
                             phoneNumbers:(NSString *)thePhoneNumbers;
@end

@implementation PGSMSBridge
@synthesize smsLeft = _smsLeft;
@synthesize requestsQueue = _requestsQueue;

- (void)dealloc {
  [_requestsQueue setDelegate:nil];
  PG_SAVE_RELEASE(_requestsQueue);
  
  [super dealloc];
}

- (id)init {
  self = [super init];
  
  if (self) {
    _requestsQueue = [[ASINetworkQueue alloc] init];
    [_requestsQueue setDelegate:self];
    [_requestsQueue setSuspended:NO];
    
    [_requestsQueue setRequestDidFinishSelector:@selector(requestFinished:)];
    [_requestsQueue setRequestDidFailSelector:@selector(requestFailed:)];
    [_requestsQueue setQueueDidFinishSelector:@selector(queueFinished:)];
  }
  
  return self;
}

- (void)sendSMS:(NSString *)theMessage
    phoneNumbers:(NSString *)thePhoneNumbers
{
  ASIHTTPRequest *requestForSendingSMS 
  = [self requestForSendingSMS:theMessage
                  phoneNumbers:thePhoneNumbers];
  [[self requestsQueue] addOperation:requestForSendingSMS];
}

#pragma mark - states
- (void)suspendSending
{
  [[self requestsQueue] setSuspended:YES];
}

- (void)resumeSending
{
  [[self requestsQueue] go];
}

- (void)abordSending
{
  [[self requestsQueue] setSuspended:YES];
  [[self requestsQueue] cancelAllOperations];
}

#pragma mark - requests
- (ASIHTTPRequest *)requestForSendingSMS:(NSString *)theMessage
                             phoneNumbers:(NSString *)thePhoneNumbers
{
  NSString *urlString 
  = [NSString stringWithFormat:
     @"%@?user=%@&password=%@&api_id=%@&to=%@%&text=%@",
     kPGSMSServerURLString,
     kPGSMSUserName,
     kPGSMSPassword,
     kPGSMS_API_ID,
     [thePhoneNumbers urlComplientString],
     [theMessage urlComplientString]];
  NSURL *url = [NSURL URLWithString:urlString];
  
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
  
  return request;
}

#pragma mark - requests:delegate
- (void)updateSMSCountLeft
{
  [self setSmsLeft:[[self requestsQueue] requestsCount]];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
  [self updateSMSCountLeft];
  
	DDLogInfo(@"PGSMSBridge: SMS has been sent");
  
  DDLogVerbose(@"PGSMSBridge: SMS server response: {%@}", 
               [request responseString]);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
  [self updateSMSCountLeft];
  
	DDLogInfo(@"PGSMSBridge: SMS send failed with error: %@", [request error]);
}

- (void)queueFinished:(ASINetworkQueue *)queue
{
	NSLog(@"PGSMSBridge: All SMS have been sent");
}
@end
