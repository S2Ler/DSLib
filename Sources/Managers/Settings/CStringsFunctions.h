
@import Foundation;

#ifndef CStringsFunctions_h
#define CStringsFunctions_h

/** You must free() return value */
char *removeChars(const char *theChars, const char *theStr);
NSString *formatJSON(NSString *JSONString);
#endif
