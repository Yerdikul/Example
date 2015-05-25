//
//  ITunesSearchResult.m
//  TJTest
//
//  Created by Nurbolat Yerdikul on 5/23/15.
//  Copyright (c) 2015 Nurbolat Yerdikul. All rights reserved.
//

#import "ITunesSearchResult.h"

@implementation ITunesSearchResult

-(instancetype)initWithInfo:(NSDictionary *)info;
{
    self = [super init];
    if (self) {
        _longDescription = info[@"longDescription"];
        _artworkURL = [NSURL URLWithString:info[@"artworkUrl100"]];
        _artistName = info[@"artistName"];
        _trackViewUrl = [NSURL URLWithString:info[@"trackViewUrl"]];
    }
    return self;
}

@end
