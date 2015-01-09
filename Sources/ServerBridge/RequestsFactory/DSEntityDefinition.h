
@import Foundation;
#import <CoreData/CoreData.h>

#define SYNTHESIZE_STRING_GETTER(name) - (NSString *)name {return [self stringValueWithName:@#name];}

#define SYNTHESIZE_DATE_GETTER(name) - (NSDate *)name {return [self dateValueWithName:@#name];}

#define SYNTHESIZE_NUMBER_GETTER(name) - (NSNumber *)name {return [self integerNumberValueWithName:@#name];}

#define SYNTHESIZE_ARRAY_GETTER(name) - (NSArray *)name {return [self definitionsArrayValueWithName:@#name];}

#define SYNTHESIZE_VALUES_KEYS(...) - (NSArray *)valuesKeys{return [NSArray arrayWithObjects:__VA_ARGS__];} + (NSArray *)valuesKeys{return [NSArray arrayWithObjects:__VA_ARGS__];}


/** Use as superclass for concrete definitions.
* declare @property (nonatomic, readonly) <TYPE> *<param_name>;
* In @implementation:
* for TYPE[NSDate] use SYNTHESIZE_DATE_GETTER
* for TYPE[NSString] use SYNTHESIZE_STRING_GETTER
* for TYPE[NSNumber] use SYNTHESIZE_NUMBER_GETTER
* param_name should be equal to the JSON params from the server.
* For setters just declare them dynamic and the magic will happen.
* Naming Convention for subclasses:
  "[classPrefix][NSManagedObject subclasses name without prefix [classPrefix]]Definition"
*/
@interface DSEntityDefinition: NSObject
- (id)initWithDictionary:(NSDictionary *)theDictionary NS_DESIGNATED_INITIALIZER;
+ (id)definitionWithDictionary:(NSDictionary *)theDictionary;

+ (id)definitionWithEntity:(NSManagedObject *)theEntity;

/** Implement in subclasses */
@property (nonatomic, strong) NSNumber *recID;

- (void)loadValuesFromDictionary:(NSDictionary *)theValues;

- (NSString *)stringValueWithName:(NSString *)theValueName;
- (void)setStringValueWithName:(NSString *)theValueName
                         value:(NSString *)theValue;

- (NSDate *)dateValueWithName:(NSString *)theName;
- (void)setDateValueWithName:(NSString *)theName
                       value:(NSDate *)theValue;

- (NSNumber *)integerNumberValueWithName:(NSString *)theName;
- (void)setNumberValueWithName:(NSString *)theName
                 integerNumber:(NSNumber *)theValue;

- (NSArray *)definitionsArrayValueWithName:(NSString *)theName;
- (void)setDefinitionsArraysWithName:(NSString *)theName
                         definitions:(NSArray *)theDefinitions;
- (NSArray *)rawDefinitionsArrayValueWithName:(NSString *)theName;


/** \pararm theDefinitions is an array of NSDictionary representation of
  * DSEntityDefinition.
 */
+ (void)enumerateDefinitionsFromArray:(NSArray *)theDefinitions
                            withBlock:(void (^)(id,
                                                NSUInteger idx,
                                                BOOL *stop))theBlock;

@end

@interface DSEntityDefinition (Abstract)
- (NSArray *)valuesKeys;
+ (NSArray *)valuesKeys;
@end
