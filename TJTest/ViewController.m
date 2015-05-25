//
//  ViewController.m
//  TJTest
//
//  Created by Nurbolat Yerdikul on 5/23/15.
//  Copyright (c) 2015 Nurbolat Yerdikul. All rights reserved.
//

#import "ViewController.h"
#import "ITunesSearchResultTableViewCell.h"
#import "RequestAPI.h"
#import "ITunesSearchResult.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@property (strong, nonatomic) NSArray *tableViewData;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableViewData = [[NSArray alloc] init];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateData];
}

#pragma mark - Data Updates
- (void)updateData
{
    [[RequestAPI sharedInstance] searchWithExampleParametersAndSuccess:^(NSArray *result) {
        [_refreshControl endRefreshing];
        [self updateTableViewData:result animation:[_tableViewData count] == 0];
        
    } failureError:^(NSError *error) {
        [_refreshControl endRefreshing];
        [self showErrorAlert];
    }];
}

- (void) updateTableViewData:(NSArray *)newData animation:(BOOL) animation
{
    _tableViewData = newData;

    if (animation) {
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                      withRowAnimation:UITableViewRowAnimationBottom];
        [_tableView endUpdates];
    }
    else
        [_tableView reloadData];
}
#pragma mark - Refresh Control

- (void)setupRefreshControl
{
    _refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:_refreshControl];
    [_refreshControl addTarget:self
                        action:@selector(updateData)
              forControlEvents:UIControlEventValueChanged];
}

#pragma mark - TableVeiw
#pragma mark DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    ITunesSearchResultTableViewCell *itunesSearchResultCell = [tableView dequeueReusableCellWithIdentifier:@"ITunesSearchCell"];
    [self configureCell:itunesSearchResultCell atIndexPath:indexPath];
    return itunesSearchResultCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static ITunesSearchResultTableViewCell *itunesSearchResultCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        itunesSearchResultCell = [tableView dequeueReusableCellWithIdentifier:@"ITunesSearchCell"];
    });
    
    [self configureCell:itunesSearchResultCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:itunesSearchResultCell];
}
- (void)configureCell:(ITunesSearchResultTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ITunesSearchResult *searchResult = [_tableViewData objectAtIndex:indexPath.row];
    
    cell.longDescriptionLabel.text = searchResult.longDescription;
    [cell.artworkImageView sd_setImageWithURL:searchResult.artworkURL];
    cell.artistNameLabel.text = searchResult.artistName;
}
- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(sizingCell.bounds));
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [_tableViewData count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_tableViewData count] > 0)
    {
        if (!_activityIndicator.hidden) {
            [_activityIndicator stopAnimating];
        }
        if (!_refreshControl) {
            [self setupRefreshControl];
        }
    }
    return 1;
}

#pragma mark Delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ITunesSearchResult *searchResult = [_tableViewData objectAtIndex:indexPath.row];
    [[UIApplication sharedApplication] openURL:searchResult.trackViewUrl];
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self isLandscapeOrientation] ? 120.0f : 155.0f;
}

- (BOOL)isLandscapeOrientation {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
}


#pragma mark - Alert View
- (void)showErrorAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Хьюстон, у нас проблемы!" message:@"Что-то пошло не так.\nПовторить еще раз?" delegate:self cancelButtonTitle:@"Отмена" otherButtonTitles:@"Да" ,nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 1) {
        [self updateData];
    }
}


#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
