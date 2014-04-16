#import "ExtensionsKit.h"

#import <objc/runtime.h>

@implementation UIView (UTILS)

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGSize)size
{
    return self.frame.size;
}

- (CGFloat)originX
{
    return self.frame.origin.x;
}

- (CGFloat)originY
{
    return self.frame.origin.y;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    [self setFrame:frame];
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    [self setFrame:frame];
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    [self setFrame:frame];
}

- (void)setOriginX:(CGFloat)originX
{
    CGRect frame = self.frame;
    frame.origin.x = originX;
    [self setFrame:frame];
}

- (void)setOriginY:(CGFloat)originY
{
    CGRect frame = self.frame;
    frame.origin.y = originY;
    [self setFrame:frame];
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    [self setFrame:frame];
}

- (void)removeAllSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#define kBorderLineTop    "__topLine__"
#define kBorderLineBottom "__bottomLine__"
#define kBorderLineLeft   "__leftLine__"
#define kBorderLineRight  "__rightLine__"

- (void)addBorderLine:(UIViewBorderLine)borderLine
                color:(UIColor *)color
          borderWidth:(CGFloat)borderWidth
{
    if ([self borderLine:borderLine])
    {
        return;
    }
    
    CGRect frame = CGRectZero;
    char *key = nil;
    switch (borderLine)
    {
        case UIViewBorderLineTop:
        {
            key  = kBorderLineTop;
            frame   = (CGRect){{0, 0}, {self.width, borderWidth}};
        }; break;
            
        case UIViewBorderLineBottom:
        {
            key  = kBorderLineBottom;
            frame   = (CGRect){{0, self.height - borderWidth}, {self.width, borderWidth}};
        }; break;
            
        case UIViewBorderLineLeft:
        {
            key  = kBorderLineLeft;
            frame   = (CGRect){{0, 0}, {borderWidth, self.height}};
        }; break;
            
        case UIViewBorderLineRight:
        {
            key  = kBorderLineRight;
            frame   = (CGRect){{self.width - borderWidth, 0}, {borderWidth, self.height}};
        }; break;
            
        default:
        {
            return;
        }; break;
    }
    
    UIView *borderLineView          = [[UIView alloc] initWithFrame:frame];
    borderLineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    borderLineView.backgroundColor  = color;
    objc_setAssociatedObject(self, key, borderLineView, OBJC_ASSOCIATION_ASSIGN);
    [self addSubview:borderLineView];
}

- (UIView *)borderLine:(UIViewBorderLine)borderLine
{
    UIView *view        = nil;
    switch (borderLine)
    {
        case UIViewBorderLineTop:
        {
            view     = objc_getAssociatedObject(self, kBorderLineTop);
        }; break;
            
        case UIViewBorderLineBottom:
        {
            view     = objc_getAssociatedObject(self, kBorderLineBottom);
        }; break;
            
        case UIViewBorderLineLeft:
        {
            view     = objc_getAssociatedObject(self, kBorderLineLeft);
        }; break;
            
        case UIViewBorderLineRight:
        {
            view     = objc_getAssociatedObject(self, kBorderLineRight);
        }; break;
    }
    
    return view;
}

- (void)removeBorderLine:(UIViewBorderLine)borderLine
{
    [[self borderLine:borderLine] removeFromSuperview];
}

- (BOOL)findAndResignFirstResponder
{
    if (self.isFirstResponder)
    {
#if DEBUG
        NSLog(@"first responder was: %@", self);
#endif
        return [self resignFirstResponder];
    }
    
    for (UIView *subView in self.subviews)
    {
        if ([subView findAndResignFirstResponder])
            return YES;
    }
    
    return NO;
}

@end

@implementation NSString (PARAMETRS)

- (NSString *)stringByReplaceWithParametrs:(NSArray *)parametrs
{
    NSMutableString *result     = [[NSMutableString alloc] initWithString:self];
    [result replaceWithParametrs:parametrs];
    return [result copy];
}

@end

@implementation NSMutableString (PARAMETRS)

- (void)replaceWithParametrs:(NSArray *)parametrs
{
    for (NSString *parametr in parametrs)
    {
        NSRange range               = [self rangeOfString:@"%@"];
        if (range.location != NSNotFound)
        {
            [self replaceCharactersInRange:range
                                  withString:parametr];
        }
        else
        {
            break;
        }
    }
}

@end

@implementation NSString (UNICHAR)

+ (NSString *)stringWithUnichar:(unichar)character
{
    unichar chars[] = { character };
    return [NSString stringWithCharacters:chars
                                   length:sizeof(chars) / sizeof(unichar)];
}

@end

@implementation NSDictionary (WRK)

- (id)objectForKeyOrDefault:(id)aKey
                   aDefault:(id)aDefault
{
    id obj = [self objectForKey:aKey];
    
    return (! obj || obj == [NSNull null]) ? aDefault : obj;
}

- (id)objectForKeyOrEmptyString:(id)aKey
{
    return [self objectForKeyOrDefault:aKey
                              aDefault:@""];
}

- (id)objectForKeyOrNil:(id)aKey
{
    return [self objectForKeyOrDefault:aKey
                              aDefault:nil];
}

@end

@implementation NSArray (RANDOM)

- (id)randomObject
{
    NSUInteger count    = [self count];
    if (!count)
    {
        return nil;
    }
    NSUInteger n        = arc4random() % count;
    return [self objectAtIndex:n];
}

- (NSArray *)randomReorder
{
    NSMutableArray *randomOrderArray        = [self mutableCopy];
    [randomOrderArray randomReorder];
    return [randomOrderArray copy];
}

- (NSArray *)addRandomObjectsFromArray:(NSArray *)array
                                 count:(NSUInteger)count
{
    NSMutableArray *newArray                = [self mutableCopy];
    [newArray addRandomObjectsFromArray:array
                                  count:count];
    
    return [newArray copy];
}

- (NSArray *)removeRandomObjectsWithCount:(NSUInteger)count
{
    NSMutableArray *newArray                = [self mutableCopy];
    [newArray removeRandomObjectsWithCount:count];
    
    return [newArray copy];
}

@end

@implementation NSMutableArray (RANDOM)

- (void)randomReorder
{
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i)
    {
        // Select a random element between i and end of array to swap with.
        NSUInteger nElements = count - i;
        NSUInteger n = (arc4random() % nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

- (void)addRandomObjectsFromArray:(NSArray *)array
                            count:(NSUInteger)count
{
    if (!array || count == 0)
        return;
    
    for (NSUInteger i = 0; i < count; i++)
    {
        id object   = [array randomObject];
        [self addObject:object];
    }
}

- (void)removeRandomObjectsWithCount:(NSUInteger)count
{
    if (count == 0)
        return;
    
    count               = MAX(count, [self count]);    
    for (NSUInteger i = 0; i < count; i++)
    {
        [self removeObject:[self randomObject]];
    }
}

@end

@implementation NSLocale (Misc)

+ (BOOL)timeIs24HourFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    BOOL is24Hour = amRange.location == NSNotFound && pmRange.location == NSNotFound;
    return is24Hour;
}

@end;