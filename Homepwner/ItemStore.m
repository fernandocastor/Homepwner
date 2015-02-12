//
//  ItemStore.m
//  Homepwner
//
//  Created by Fernando Castor on 27/01/15.
//  Copyright (c) 2015 UFPE. All rights reserved.
//

#import "ItemStore.h"
#import "BNRItem.h"
#import "Homepwner-Swift.h"

@interface ItemStore()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation ItemStore

+ (instancetype)sharedStore {
    static ItemStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore  = [[self alloc] initPrivate];
    }
    return sharedStore;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use + [ItemStore sharedStore]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    if(self) {
        self.privateItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)allItems {
    //The return line does not guarantee immutability of the results. To achieve that,
    //we should employ "return [self.privateItems copy];" instead.
    return self.privateItems;
}

- (BNRItem *)createItem {
    BNRItem *item = [BNRItem randomItem];
    [self.privateItems addObject:item];
    return item;
}

- (void)removeItem:(BNRItem *)item {
    [[ImageStore sharedStore] deleteImageForKey:item.itemKey];
    
    // Performs removal based on object addresses (identical objects),
    // instead of looking for an object whose contents are the same.
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSInteger)fromIndex ToIndex:(NSInteger)toIndex {
    if (fromIndex == toIndex) return;
    
    BNRItem *temp = self.privateItems[fromIndex];
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:temp atIndex:toIndex];
}


@end