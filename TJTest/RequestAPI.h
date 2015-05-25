//
//  RequestAPI.h
//  TJTest
//
//  Created by Nurbolat Yerdikul on 5/23/15.
//  Copyright (c) 2015 Nurbolat Yerdikul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestAPI : NSObject

typedef void (^SearchRusultBlock) (NSArray *result);
typedef void (^Error) (NSError *error);

+ (RequestAPI *)sharedInstance;

- (void) searchWithExampleParametersAndSuccess:(SearchRusultBlock)success
                                  failureError:(Error)failureError;

@end
