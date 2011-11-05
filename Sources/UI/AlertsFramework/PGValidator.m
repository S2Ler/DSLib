
#pragma mark - include
#import "PGValidator.h"
#import "PGAlertMessage.h"

#pragma mark - Private
@interface PGValidator() {
  
}

@end


@implementation PGValidator

+ (BOOL)validateString:(NSString *)theString
                 regex:(NSString *)theRegex {
  NSPredicate *predicate
  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", theRegex];
  return [predicate evaluateWithObject:theString];
}

#pragma mark - email
+ (PGAlertMessage *)validateEmail:(NSString *)theEmail 
{
  if ([theEmail length] == 0) {
    return [PGAlertMessage messageWithTitle:@"<EMAIL ERROR>"
                                    message:@"<EMAIL IS EMPTY"];

    return nil;
  }

  NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
  BOOL validated = [self validateString:theEmail
                                  regex:emailRegex];
  
  if (!validated) {
    return [PGAlertMessage messageWithTitle:@"<EMAIL ERROR>"
                                    message:@"<EMAIL IS IN WRONG FORMAT"];
    return nil;
  } else {
    return nil;
  }
}



@end
