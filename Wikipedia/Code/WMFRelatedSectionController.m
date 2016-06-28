#import "WMFRelatedSectionController.h"

// Networking & Model
#import "WMFRelatedSearchFetcher.h"
#import "WMFRelatedSearchResults.h"
#import "MWKSearchResult.h"
#import "MWKSavedPageList.h"

// Controllers
#import "WMFRelatedTitleListDataSource.h"

// Frameworks
#import "Wikipedia-Swift.h"
#import "WMFRelatedSectionBlackList.h"
#import <BlocksKit/BlocksKit+UIKit.h>

// View
#import "WMFArticlePreviewTableViewCell.h"
#import "WMFArticlePlaceholderTableViewCell.h"
#import "UIView+WMFDefaultNib.h"
#import "UITableViewCell+WMFLayout.h"
#import "WMFSaveButtonController.h"

#import "WMFRelatedTitleViewController.h"
#import "WMFArticleBrowserViewController.h"

// Style
#import "UIFont+WMFStyle.h"

NS_ASSUME_NONNULL_BEGIN

static NSString* const WMFRelatedSectionIdentifierPrefix = @"WMFRelatedSectionIdentifier";
static NSUInteger const WMFRelatedSectionMaxResults      = 3;

@interface WMFRelatedSectionController ()

@property (nonatomic, strong, readwrite) NSURL* url;
@property (nonatomic, strong, readwrite) WMFRelatedSectionBlackList* blackList;

@property (nonatomic, strong, readwrite) WMFRelatedSearchFetcher* relatedSearchFetcher;

@property (nonatomic, strong) WMFRelatedTitleListDataSource* relatedTitleDataSource;

@property (nonatomic, strong, nullable) WMFRelatedSearchResults* searchResults;

@end

@implementation WMFRelatedSectionController

@synthesize relatedTitleDataSource = _relatedTitleDataSource;

- (instancetype)initWithArticleURL:(NSURL*)url
                         blackList:(WMFRelatedSectionBlackList*)blackList
                         dataStore:(MWKDataStore*)dataStore {
    return [self initWithArticleURL:url
                          blackList:blackList
                          dataStore:dataStore
               relatedSearchFetcher:[[WMFRelatedSearchFetcher alloc] init]];
}

- (instancetype)initWithArticleURL:(NSURL*)url
                         blackList:(WMFRelatedSectionBlackList*)blackList
                         dataStore:(MWKDataStore*)dataStore
              relatedSearchFetcher:(WMFRelatedSearchFetcher*)relatedSearchFetcher {
    NSParameterAssert(url);
    NSParameterAssert(blackList);
    NSParameterAssert(relatedSearchFetcher);
    self = [super initWithDataStore:dataStore];
    if (self) {
        self.relatedSearchFetcher = relatedSearchFetcher;
        self.url                  = url;
        self.blackList            = blackList;
    }
    return self;
}

- (id)sectionIdentifier {
    return [WMFRelatedSectionIdentifierPrefix stringByAppendingString:self.url.wmf_title];
}

- (UIImage*)headerIcon {
    return [UIImage imageNamed:@"recent-mini"];
}

- (UIColor*)headerIconTintColor {
    return [UIColor wmf_exploreSectionHeaderIconTintColor];
}

- (UIColor*)headerIconBackgroundColor {
    return [UIColor wmf_exploreSectionHeaderIconBackgroundColor];
}

- (NSAttributedString*)headerTitle {
    return [[NSAttributedString alloc] initWithString:MWLocalizedString(@"explore-continue-related-heading", nil) attributes:@{NSForegroundColorAttributeName: [UIColor wmf_exploreSectionHeaderTitleColor]}];
}

- (NSAttributedString*)headerSubTitle {
    return [[NSAttributedString alloc] initWithString:self.url.wmf_title attributes:@{NSForegroundColorAttributeName: [UIColor wmf_blueTintColor]}];
}

- (NSString*)cellIdentifier {
    return [WMFArticlePreviewTableViewCell identifier];
}

- (UINib*)cellNib {
    return [WMFArticlePreviewTableViewCell wmf_classNib];
}

- (nullable NSString*)placeholderCellIdentifier {
    return [WMFArticlePlaceholderTableViewCell identifier];
}

- (nullable UINib*)placeholderCellNib {
    return [WMFArticlePlaceholderTableViewCell wmf_classNib];
}

- (void)configureCell:(WMFArticlePreviewTableViewCell*)cell withItem:(MWKSearchResult*)item atIndexPath:(NSIndexPath*)indexPath {
    cell.titleText       = item.displayTitle;
    cell.descriptionText = item.wikidataDescription;
    cell.snippetText     = item.extract;
    [cell setImageURL:item.thumbnailURL];
    [cell setSaveableURL:[self urlForItemAtIndexPath:indexPath] savedPageList:self.savedPageList];
    [cell wmf_layoutIfNeededIfOperatingSystemVersionLessThan9_0_0];
    cell.saveButtonController.analyticsContext     = self;
    cell.saveButtonController.analyticsContentType = self;
}

- (CGFloat)estimatedRowHeight {
    return [WMFArticlePreviewTableViewCell estimatedRowHeight];
}

- (NSString*)analyticsContentType {
    return @"Recommended";
}

- (AnyPromise*)fetchData {
    @weakify(self);
    return [self.relatedTitleDataSource fetch]
           .then(^(WMFRelatedSearchResults* results){
        @strongify(self);
        self.searchResults = results;
        return [self.searchResults.results wmf_safeSubarrayWithRange:NSMakeRange(0, WMFRelatedSectionMaxResults)];
    })
           .catch(^(NSError* error){
        @strongify(self);
        self.searchResults = nil;
        return error;
    });
}

- (UIViewController*)detailViewControllerForItemAtIndexPath:(NSIndexPath*)indexPath {
    NSURL* url = [self urlForItemAtIndexPath:indexPath];
    return [[WMFArticleViewController alloc] initWithArticleURL:url dataStore:self.dataStore];
}

#pragma mark - WMFHeaderMenuProviding

- (UIActionSheet*)menuActionSheet {
    UIActionSheet* sheet = [[UIActionSheet alloc] bk_initWithTitle:nil];
    [sheet bk_setDestructiveButtonWithTitle:MWLocalizedString(@"home-hide-suggestion-prompt", nil) handler:^{
        [self.blackList addBlackListArticleURL:self.url];
        [self.blackList save];
    }];

    [sheet bk_setCancelButtonWithTitle:MWLocalizedString(@"home-hide-suggestion-cancel", nil) handler:NULL];
    return sheet;
}

#pragma mark - WMFMoreFooterProviding

- (NSString*)footerText {
    return
        [MWLocalizedString(@"home-more-like-footer", nil) stringByReplacingOccurrencesOfString:@"$1"
                                                                                    withString:self.url.wmf_title];
}

- (WMFRelatedTitleListDataSource*)relatedTitleDataSource {
    if (!_relatedTitleDataSource) {
        /*
           HAX: Need to use the "more" data source to fetch data and keep it around since morelike: searches for the same
           title don't have the same results in order. might need to look into continuation soon
         */
        _relatedTitleDataSource = [[WMFRelatedTitleListDataSource alloc]
                                   initWithURL:self.url
                                     dataStore:self.dataStore
                                   resultLimit:WMFMaxRelatedSearchResultLimit
                                       fetcher:self.relatedSearchFetcher];
    }
    return _relatedTitleDataSource;
}

- (UIViewController*)moreViewController {
    if (!self.relatedSearchFetcher.isFetching && !self.relatedTitleDataSource.relatedSearchResults) {
        [self.relatedTitleDataSource fetch];
    }
    WMFRelatedTitleViewController* vc = [[WMFRelatedTitleViewController alloc] init];
    vc.dataSource = self.relatedTitleDataSource;
    vc.dataStore  = self.dataStore;
    return vc;
}

#pragma mark - WMFTitleProviding

- (NSURL*)urlForIndexPath:(NSIndexPath*)indexPath {
    MWKSearchResult* result = self.items[indexPath.row];
    return [self.url wmf_URLWithTitle:result.displayTitle];
}

@end

NS_ASSUME_NONNULL_END
