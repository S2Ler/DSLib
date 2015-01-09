@import Foundation;

/** Easy access various directories */
@interface NSFileManager (NSFileManager_Directories)

/**
 \param theType the type of the directory to return
 \return path for the directory with NSUserDomainMask of type theType */
+ (NSString *)userDirectoryOfType:(NSSearchPathDirectory)theType;
@end
