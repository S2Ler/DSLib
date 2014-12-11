//
//  DSEmailSharer.m
//  PropertyApp
//
//  Created by Alexander Belyavskiy on 2/10/12.
//  Copyright (c) 2012 InGenius Labs. All rights reserved.
//

#import "DSEmailSharer.h"

#pragma mark - private
@interface DSEmailSharer()
@property (nonatomic, weak) UIViewController *rootViewController;
@property (nonatomic, strong) MFMailComposeViewController *mailComposer;
@property (nonatomic, strong) NSMutableArray *recipients;
@end

@implementation DSEmailSharer
@synthesize rootViewController = _rootViewController;
@synthesize mailComposer = _mailComposer;
@synthesize recipients = _recipients;

- (id)initWithRootViewController:(UIViewController *)theController
{
  self = [super init];
  
  if (self) {
    _rootViewController = theController;    
    _mailComposer = [[MFMailComposeViewController alloc] init];
    [_mailComposer setMailComposeDelegate:self];
    _recipients = [NSMutableArray array];
  }
  
  return self;
}

- (void)share
{
  [[self mailComposer] setToRecipients:[self recipients]];
  self.mailComposer.modalPresentationStyle = self.modalPresentationStyle;
  [[self rootViewController] presentViewController:[self mailComposer] animated:YES completion:nil];
 }

- (void)mailComposeController:(MFMailComposeViewController *)controller 
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
  [[self rootViewController] dismissViewControllerAnimated:YES completion:nil];
  
  if ([self completionHandler]) {
    [self completionHandler]();
  }
}

- (void)setSubject:(NSString*)theSubject
{
  [[self mailComposer] setSubject:theSubject];
}

- (void)addRecipient:(NSString *)theRecipient
{
  if (theRecipient == nil) {
    NSLog(@"Tring to add nil object");
    return;
  }
  
  [[self recipients] addObject:theRecipient];
}

- (void)setMessageBody:(NSString *)theBody
                isHTML:(BOOL)theHTMLFlag
{
  [[self mailComposer] setMessageBody:theBody isHTML:theHTMLFlag];
}

- (void)addAttachmentData:(NSData*)theAttachment
                 mimeType:(NSString*)theMimeType
                 fileName:(NSString*)theFilename
{
  [[self mailComposer] addAttachmentData:theAttachment mimeType:theMimeType fileName:theFilename];
}

+ (BOOL)canSendEmail
{
  return [MFMailComposeViewController canSendMail];
}
@end
