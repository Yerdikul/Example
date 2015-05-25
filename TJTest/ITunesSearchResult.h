//
//  ITunesSearchResult.h
//  TJTest
//
//  Created by Nurbolat Yerdikul on 5/23/15.
//  Copyright (c) 2015 Nurbolat Yerdikul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITunesSearchResult : NSObject
@property (strong, nonatomic) NSString *longDescription, *artistName;
@property (strong, nonatomic) NSURL *artworkURL, *trackViewUrl;

-(instancetype)initWithInfo:(NSDictionary *)info;

@end
