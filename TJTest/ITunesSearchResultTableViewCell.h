//
//  ITunesSearchResultTableViewCell.h
//  TJTest
//
//  Created by Nurbolat Yerdikul on 5/23/15.
//  Copyright (c) 2015 Nurbolat Yerdikul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"
@interface ITunesSearchResultTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet CustomLabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet CustomLabel *longDescriptionLabel;


@end
