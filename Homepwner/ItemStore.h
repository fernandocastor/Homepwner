//
//  ItemStore.h
//  Homepwner
//
//  Created by Fernando Castor on 27/01/15.
//  Copyright (c) 2015 UFPE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem;
@interface ItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;

+ (instancetype)sharedStore;
- (BNRItem *)createItem;
- (void)removeItem:(BNRItem *)item;
- (void)moveItemAtIndex:(NSInteger)fromIndex ToIndex:(NSInteger)toIndex;

@end