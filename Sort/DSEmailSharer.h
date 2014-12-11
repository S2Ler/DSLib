//
//  DSEmailSharer.h
//  PropertyApp
//
//  Created by Alexander Belyavskiy on 2/10/12.
//  Copyright (c) 2012 InGenius Labs. All rights reserved.
//

@import MessageUI;

@interface DSEmailSharer : NSObject
<
MFMailComposeViewControllerDelegate
>

@property (nonatomic, assign) UIModalPresentationStyle modalPresentationStyle;

- (id)initWithRootViewController:(UIViewController *)theController;

- (void)setSubject:(NSString*)theSubject;
- (void)addRecipient:(NSString *)theRecipient;
- (void)setMessageBody:(NSString *)theBody isHTML:(BOOL)theHTMLFlag;
- (void)addAttachmentData:(NSData*)theAttachment
                 mimeType:(NSString*)theMimeType
                 fileName:(NSString*)theFilename;

@property (nonatomic, copy) void (^completionHandler)();

- (void)share;

+ (BOOL)canSendEmail;
@end
