//
//  XZQLRUMutableDictionary.h
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/11/19.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZQLRUMutableDictionary<__covariant KeyType, __covariant ObjectType> : NSObject


///< 初始化最大的存储数量
- (instancetype)initWithMaxCountLRU:(NSUInteger)maxCountLRU;

#pragma mark ------- NSDictionary 方法
@property (readonly) NSUInteger count;

- (NSEnumerator*)keyEnumerator;

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(KeyType key, ObjectType obj, BOOL *stop))block;

#pragma mark ------- NSMutableDictionary 方法


/// 根据key移除某个数据
/// @param aKey 键
- (void)removeObjectForKey:(KeyType)aKey;

/// 设置数据
/// @param anObject 值
/// @param aKey 键
- (void)setObject:(ObjectType)anObject forKey:(KeyType <NSCopying>)aKey;

/// 移除所有数据
- (void)removeAllObjects;
/// 根据多个键移除数据
/// @param keyArray 键数组
- (void)removeObjectsForKeys:(NSArray<KeyType> *)keyArray;

#pragma mark ------- LRUMutableDictionary 方法
// 执行LRU算法，当访问的元素可能是被淘汰的时候，可以通过在block中返回需要访问的对象，会根据LRU机制自动添加到 dic 中
- (ObjectType)objectForKey:(KeyType)aKey returnEliminateObjectUsingBlock:(ObjectType (^)(BOOL maybeEliminate))block;

@end

NS_ASSUME_NONNULL_END
