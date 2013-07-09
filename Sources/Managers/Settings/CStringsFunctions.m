

#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include "CStringsFunctions.h"

char *removeChars(const char *theChars, const char *theStr)
{    
    char *out_s = calloc(strlen(theStr), sizeof(char));
    
    int theStr_i, theChars_i, out_s_i;    
    theStr_i =  theChars_i = out_s_i = 0;
    
    while (theStr[theStr_i] != '\0') {
        theChars_i = 0;
        bool isToBeDeletedChar = false;
        while (theChars[theChars_i] != '\0') {
            if (theChars[theChars_i++] == theStr[theStr_i]) {
                isToBeDeletedChar = true;
                break;
            }
        }
        
        if (isToBeDeletedChar == false) {
            out_s[out_s_i++] = theStr[theStr_i];
        }
        theStr_i++;
    }
    
    out_s[out_s_i] = '\0';
    
    return out_s;
}

NSString *formatJSON(NSString *JSONString)
{
    const char *JSON_s = [JSONString UTF8String];
    int JSON_i = 0;
    int formatted_i = 0;
    char *formattedJSON_s = calloc(strlen(JSON_s)*2, sizeof(char));
    
    while (JSON_s[JSON_i] != '\0') {
        formattedJSON_s[formatted_i++] = JSON_s[JSON_i];
        if (JSON_s[JSON_i] == '{' ||
            JSON_s[JSON_i] == ',' ) 
        {
            formattedJSON_s[formatted_i++] = '\n';
        }
        JSON_i++;
    }
    
    NSString *formattedJSON = [NSString stringWithUTF8String:formattedJSON_s];    
    free(formattedJSON_s);
    
    return formattedJSON;
}
