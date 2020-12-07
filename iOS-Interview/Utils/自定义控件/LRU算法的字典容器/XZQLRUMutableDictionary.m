//
//  XZQLRUMutableDictionary.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/11/19.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQLRUMutableDictionary.h"

@interface XZQLRUMutableDictionary ()

/**
 * 数据存储
 */
@property (nonatomic, strong) NSMutableDictionary * dict;
/**
 * 记录对应的 key 顺序
 */
@property (nonatomic, strong) NSMutableArray * arrayForLRU;
/**
 * 设置最大内存数
 */
@property (nonatomic, assign) NSUInteger maxCountLRU;

@end

@implementation XZQLRUMutableDictionary

- (instancetype)initWithMaxCountLRU:(NSUInteger)maxCountLRU {
    
    if (self = [super init]) {
        _dict = [NSMutableDictionary dictionaryWithCapacity:maxCountLRU];
        _arrayForLRU = [NSMutableArray arrayWithCapacity:maxCountLRU];
        _maxCountLRU = maxCountLRU;
    }
    return self;
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"-----\n数据：%@\n键顺序：%@",self.dict,self.arrayForLRU];
}

#pragma mark - NSDictionary

- (NSUInteger)count {
    
    return [_dict count];
}

- (NSEnumerator *)keyEnumerator {
    
    return [_dict keyEnumerator];
}

- (id)objectForKey:(id)key {
    
    return [self objectForKey:key returnEliminateObjectUsingBlock:^id _Nonnull(BOOL maybeEliminate) {
        return nil;
    }];
}

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id _Nonnull, id _Nonnull, BOOL * _Nonnull))block {
    
    [_dict enumerateKeysAndObjectsUsingBlock:block];
}

#pragma mark - NSMutableDictionary
- (void)removeObjectForKey:(id)aKey {
    
    [_dict removeObjectForKey:aKey];
    [self _removeObjectLRU:aKey];
}

- (void)removeAllObjects {
    [_dict removeAllObjects];
    [self _removeAllObjectLRU];
}

- (void)removeObjectsForKeys:(NSArray *)keyArray {
    if (keyArray.count > 0) {
        
        [_dict removeObjectsForKeys:keyArray];
        [self _removeObjectsLRU:keyArray];
    }
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    BOOL isExist = ([_dict objectForKey:aKey] != nil);
    [_dict setObject:anObject forKey:aKey];
    
    if (isExist) { // 存在，调整位置顺序
        
        [self _adjustPositionLRU:aKey];
    }else { // 不存在，直接插入
        [self _addObjectLRU:aKey];
    }
}

#pragma mark - LRUMutableDictionary

- (id)objectForKey:(id)aKey returnEliminateObjectUsingBlock:(id  _Nonnull (^)(BOOL))block {
    id obj = [_dict objectForKey:aKey];
    if (obj) {
        [self _adjustPositionLRU:aKey];
    }
    if (block) {
        BOOL maybeElimiate = obj ? NO:YES;
        id newObj = block(maybeElimiate);
        if (newObj) {
            [self setObject:newObj forKey:aKey];
            return [_dict objectForKey:aKey];
        }
    }
    return nil;
}

#pragma mark - LRU

/// 判断是否需要开启RLU淘汰
/// @param count 当前存储数量
- (BOOL)_isNeedOpenLRU:(NSUInteger)count {
    NSInteger i = (_maxCountLRU - count);
//    return (i < LRU_RISK_COUNT);
    return YES;
}
/// 添加
- (void)_addObjectLRU:(id)obj {
    
    // 添加记录新值
    if (_arrayForLRU.count == 0) {
        
        [_arrayForLRU addObject:obj];
    }else {
        [_arrayForLRU insertObject:obj atIndex:0];
    }
    // 超过了算法限制
    if ((_maxCountLRU > 0) && (_arrayForLRU.count > _maxCountLRU)) {
        [_dict removeObjectForKey:[_arrayForLRU lastObject]];
        [_arrayForLRU removeLastObject];
    }
}
/// 移动位置
- (void)_adjustPositionLRU:(id)obj {
    
    NSUInteger idx = [_arrayForLRU indexOfObject:obj];
    if (idx != NSNotFound) {
        [_arrayForLRU removeObjectAtIndex:idx];
        [_arrayForLRU insertObject:obj atIndex:0];
    }
}

- (void)_removeObjectLRU:(id)obj {
    
    [_arrayForLRU removeObject:obj];
}
- (void)_removeObjectsLRU:(NSArray *)objArr {
    
    [_arrayForLRU removeObjectsInArray:objArr];
}
- (void)_removeAllObjectLRU {
    
    [_arrayForLRU removeAllObjects];
}

@end
