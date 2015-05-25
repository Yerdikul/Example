//
//  RequestAPI.m
//  TJTest
//
//  Created by Nurbolat Yerdikul on 5/23/15.
//  Copyright (c) 2015 Nurbolat Yerdikul. All rights reserved.
//

#import "RequestAPI.h"
#import <AFNetworking.h>
#import <AFNetworkActivityIndicatorManager.h>

#import "ITunesSearchResult.h"

@implementation RequestAPI

//https://itunes.apple.com/search?term=jack&limit=200&country=RU

static NSString *const kAPIURL = @"https://itunes.apple.com/";
static NSString *const kAPIMethodType = @"search";

+ (RequestAPI *)sharedInstance;
{
    static RequestAPI *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[RequestAPI alloc] init];
    });
    
    return _sharedInstance;
}

static NSString *const kExampleParamForTerm = @"jack";
static NSString *const kExampleParamForCountry = @"RU";

- (void) searchWithExampleParametersAndSuccess:(SearchRusultBlock)success
                                  failureError:(Error)failureError;
{
    NSMutableDictionary *getParameters = [[NSMutableDictionary alloc] init];
    [getParameters setValue:kExampleParamForCountry forKey:@"country"];
    [getParameters setValue:kExampleParamForTerm forKey:@"term"];
    [getParameters setValue:[NSNumber numberWithInt:200] forKey:@"limit"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    [manager.requestSerializer setTimeoutInterval:10];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@%@", kAPIURL, kAPIMethodType]
      parameters:getParameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             if ([responseObject isKindOfClass:[NSDictionary class]]) {

                 NSMutableArray *formatedArray = [[NSMutableArray alloc] init];
                 for (NSDictionary *dict in responseObject[@"results"]) {
                     ITunesSearchResult *searchResult = [[ITunesSearchResult alloc] initWithInfo:dict];
                     [formatedArray addObject:searchResult];
                 }
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     success(formatedArray);
                 });
             }
             
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failureError(error);
        });
    }];
    
}

@end
