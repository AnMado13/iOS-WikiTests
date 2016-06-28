
#import "WMFMainPageSectionController.h"
#import "MWKSiteInfoFetcher.h"
#import "WMFArticlePreviewFetcher.h"

#import "MWKDataStore.h"
#import "MWKUserDataStore.h"
#import "MWKSiteInfo.h"
#import "MWKSearchResult.h"

#import "WMFArticleListTableViewCell.h"
#import "WMFMainPagePlaceholderTableViewCell.h"
#import "UIView+WMFDefaultNib.h"
#import "UITableViewCell+WMFLayout.h"
#import "WMFArticleBrowserViewController.h"
#import "NSDateFormatter+WMFExtensions.h"


NS_ASSUME_NONNULL_BEGIN

static NSString* const WMFMainPageSectionIdentifier = @"WMFMainPageSectionIdentifier";

@interface WMFMainPageSectionController ()

@property (nonatomic, strong, readwrite) NSURL* domainURL;

@property (nonatomic, strong) MWKSiteInfoFetcher* siteInfoFetcher;

@property (nonatomic, strong) WMFArticlePreviewFetcher* titleSearchFetcher;

@property (nonatomic, strong, nullable) MWKSiteInfo* siteInfo;

@property (nonatomic, strong, nullable) MWKSearchResult* mainPageSearchResult;

@end

@implementation WMFMainPageSectionController

- (instancetype)initWithDomainURL:(NSURL*)url dataStore:(MWKDataStore*)dataStore {
    NSParameterAssert(url);
    self = [super initWithDataStore:dataStore];
    if (self) {
        self.domainURL = url;
    }
    return self;
}

#pragma mark - Accessors

- (MWKSiteInfoFetcher*)siteInfoFetcher {
    if (_siteInfoFetcher == nil) {
        _siteInfoFetcher = [[MWKSiteInfoFetcher alloc] init];
    }
    return _siteInfoFetcher;
}

- (WMFArticlePreviewFetcher*)titleSearchFetcher {
    if (_titleSearchFetcher == nil) {
        _titleSearchFetcher = [[WMFArticlePreviewFetcher alloc] init];
    }
    return _titleSearchFetcher;
}

#pragma mark - HomeSectionController

- (id)sectionIdentifier {
    return WMFMainPageSectionIdentifier;
}

- (UIImage*)headerIcon {
    return [UIImage imageNamed:@"news-mini"];
}

- (UIColor*)headerIconTintColor {
    return [UIColor wmf_exploreSectionHeaderIconTintColor];
}

- (UIColor*)headerIconBackgroundColor {
    return [UIColor wmf_exploreSectionHeaderIconBackgroundColor];
}

- (NSAttributedString*)headerTitle {
    return [[NSAttributedString alloc] initWithString:MWLocalizedString(@"explore-main-page-heading", nil) attributes:@{NSForegroundColorAttributeName: [UIColor wmf_exploreSectionHeaderTitleColor]}];
}

- (NSAttributedString*)headerSubTitle {
    return [[NSAttributedString alloc] initWithString:[[NSDateFormatter wmf_dayNameMonthNameDayOfMonthNumberDateFormatter] stringFromDate:[NSDate date]] attributes:@{NSForegroundColorAttributeName: [UIColor wmf_exploreSectionHeaderSubTitleColor]}];
}

- (NSString*)cellIdentifier {
    return [WMFArticleListTableViewCell identifier];
}

- (UINib*)cellNib {
    return [WMFArticleListTableViewCell wmf_classNib];
}

- (NSUInteger)numberOfPlaceholderCells {
    return 1;
}

- (nullable NSString*)placeholderCellIdentifier {
    return [WMFMainPagePlaceholderTableViewCell identifier];
}

- (nullable UINib*)placeholderCellNib {
    return [WMFMainPagePlaceholderTableViewCell wmf_classNib];
}

- (void)configureCell:(WMFArticleListTableViewCell*)cell withItem:(MWKSearchResult*)item atIndexPath:(NSIndexPath*)indexPath {
    cell.titleText                        = item.displayTitle;
    cell.titleLabel.accessibilityLanguage = self.domainURL.wmf_language;
    cell.descriptionText                  = item.wikidataDescription;
    [cell setImageURL:item.thumbnailURL];
    [cell wmf_layoutIfNeededIfOperatingSystemVersionLessThan9_0_0];
}

- (NSString*)analyticsContentType {
    return @"Main Page";
}

- (CGFloat)estimatedRowHeight {
    return [WMFArticleListTableViewCell estimatedRowHeight];
}

- (AnyPromise*)fetchData {
    @weakify(self);
    return [self.siteInfoFetcher fetchSiteInfoForDomainURL:self.domainURL].then(^(MWKSiteInfo* data) {
        @strongify(self);
        if (!self || !data.mainPageURL) {
            return (id)[AnyPromise promiseWithValue:[NSError cancelledError]];
        }
        self.siteInfo = data;
        return (id)[self.titleSearchFetcher fetchArticlePreviewResultsForArticleURLs:@[self.siteInfo.mainPageURL] domainURL:self.domainURL];
    }).then(^(NSArray<MWKSearchResult*>* searchResults) {
        @strongify(self);
        if (!self) {
            return (id)[AnyPromise promiseWithValue:[NSError cancelledError]];
        }
        self.mainPageSearchResult = [searchResults firstObject];
        return (id) @[[searchResults firstObject]];
    }).catch(^(NSError* error){
        @strongify(self);
        self.siteInfo = nil;
        self.mainPageSearchResult = nil;
        return error;
    });
}

- (UIViewController*)detailViewControllerForItemAtIndexPath:(NSIndexPath*)indexPath {
    NSURL* url = [self urlForItemAtIndexPath:indexPath];
    return [[WMFArticleViewController alloc] initWithArticleURL:url dataStore:self.dataStore];
}

#pragma mark - WMFTitleProviding

- (nullable NSURL*)urlForItemAtIndexPath:(NSIndexPath*)indexPath {
    return [self.siteInfo mainPageURL];
}

@end

NS_ASSUME_NONNULL_END
