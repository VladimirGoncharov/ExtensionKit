#import <UIKit/UIKit.h>

#define BLOCK_SAFE_RUN(block, ...) block ? block(__VA_ARGS__) : nil

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] floatValue] == v)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] floatValue] > v)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] floatValue] >= v)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] floatValue] < v)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] floatValue] <= v)

#define RGBA(r, g, b, a)                            [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RGB(r, g, b)                                RGBA(r, g, b, 1.0f)

#define IS_IPAD                                     ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
#define IS_IPHONE                           ([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad)
#define IS_IPHONE_5                         (fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON)
#define IS_RETINA                           ([UIScreen mainScreen].scale == 2.0)

typedef NS_ENUM(NSUInteger, UIViewBorderLine)
{
    UIViewBorderLineTop,
    UIViewBorderLineBottom,
    UIViewBorderLineLeft,
    UIViewBorderLineRight
};

@interface UIView (UTILS)

//короткий getter для frame
- (CGFloat)width;
- (CGFloat)height;
- (CGSize)size;
- (CGFloat)originX;
- (CGFloat)originY;
- (CGPoint)origin;

//короткий setter для frame
- (void)setHeight:(CGFloat)height;
- (void)setWidth:(CGFloat)width;
- (void)setSize:(CGSize)size;
- (void)setOriginX:(CGFloat)originX;
- (void)setOriginY:(CGFloat)originY;
- (void)setOrigin:(CGPoint)origin;

- (void)removeAllSubviews;

- (void)addBorderLine:(UIViewBorderLine)borderLine
                color:(UIColor *)color
          borderWidth:(CGFloat)borderWidth;
- (UIView *)borderLine:(UIViewBorderLine)borderLine;
- (void)removeBorderLine:(UIViewBorderLine)borderLine;

- (BOOL)findAndResignFirstResponder;

@end

@interface NSString (PARAMETRS)

//проходит по строке и полседовательно заменяет %@ переданными в параметрах строками
- (NSString *)stringByReplaceWithParametrs:(NSArray *)parametrs;

@end

@interface NSMutableString (PARAMETRS)

//проходит по строке и полседовательно заменяет %@ переданными в параметрах строками
- (void)replaceWithParametrs:(NSArray *)parametrs;

@end

@interface NSString (UNICHAR)

+ (NSString *)stringWithUnichar:(unichar)character;

@end

@interface NSDictionary (WRK)

- (id)objectForKeyOrDefault:(id)aKey
                   aDefault:(id)aDefault;
- (id)objectForKeyOrEmptyString:(id)aKey;
- (id)objectForKeyOrNil:(id)aKey;

@end

@interface NSArray (RANDOM)

- (id)randomObject;
- (NSArray *)randomReorder;
- (NSArray *)addRandomObjectsFromArray:(NSArray *)array
                                 count:(NSUInteger)count;
- (NSArray *)removeRandomObjectsWithCount:(NSUInteger)count;

@end

@interface NSMutableArray (RANDOM)

- (void)randomReorder;
- (void)addRandomObjectsFromArray:(NSArray *)array
                            count:(NSUInteger)count;
- (void)removeRandomObjectsWithCount:(NSUInteger)count;

@end

@interface NSLocale (Misc)

+ (BOOL)timeIs24HourFormat;

@end
