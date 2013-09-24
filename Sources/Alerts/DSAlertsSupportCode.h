
#import <Foundation/Foundation.h>

@class DSMessage;

typedef void (^ds_action_block_t)(id sender);
typedef void (^ds_cell_action_block_t)(UITableViewCell *cell, id sender);
typedef void (^ds_completion_handler)(BOOL success, DSMessage *message);
typedef void (^ds_results_completion)(BOOL success, DSMessage *message, id result);

#define NO_RESULTS nil

typedef NSString DSMessageCode;
typedef NSString DSMessageDomain;

BOOL DSMessageDomainsEqual(DSMessageDomain *domain1, DSMessageDomain *domain2);

BOOL DSMessageCodesEqual(DSMessageCode *code1, DSMessageCode *code2);
