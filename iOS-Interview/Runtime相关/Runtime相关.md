##  Runtime相关

1、objc 对象的 isa 的指针指向什么？isa 指针有哪两种类型？<br/>
1）实例对象的 isa 指向类对象；<br/>
2）类对象的 isa 指向元类对象；<br/>
3）元类对象的 isa 指向元类的基类。<br/>
isa 指针有两种类型：<br/>
1）纯指针，指向内存地址。
2）现在的isa指针不直接指向内存地址，而是一个除了内存地址，还存有一些其他信息的指针（被包装成了y共用体isa_t），需要经过与指定掩码的位运算才能得到真正指向class内存地址的指针。<br/>

2、class_ro_t 和 class_rw_t 有什么区别？<br/>
class_ro_t：存储了当前类在编译期就已经确定的属性、方法以及遵循的协议。<br/>
class_rw_t：rw代表可读可写。ObjC 类中的属性、方法还有遵循的协议等信息都保存在 class_rw_t 中。<br/>

    struct class_rw_t {
        uint32_t flags;
        uint32_t version;

        const class_ro_t *ro;  // 指向只读的结构体，指向类初始信息

        /* 
         * 这三个都是二维数组，可读可写，包含了类初始信息、分类的内容
         * methods中存储 method_list_t --- method_t
         * 这三个二维数组中的数据有一部分是从class_ro_t中合并过来的
         */
        method_array_t methods;
        property_array_t properties;
        protocol_array_t protocols;

        Class firstSubclass;
        Class nextSiblingClass;
    };

    struct class_ro_t {
        uint32_t flags;
        uint32_t instanceStart;
        uint32_t instanceSize;
        uint32_t reserved;

        const uint8_t * ivarLayout;

        const char * name;
        method_list_t * baseMethodList;
        protocol_list_t * baseProtocols;
        const ivar_list_t * ivars;

        const uint8_t * weakIvarLayout;
        property_list_t *baseProperties;
    };
可以看出，class_rw_t 结构体内有一个指向 class_ro_t 结构体的指针。每个类都对应有一个 class_ro_t 结构体和一个 class_rw_t 结构体。在编译期间，class_ro_t 结构体就已经确定，objc_class 中的 bits 的 data 部分存放着该结构体的地址。在 Runtime 运行之后，具体来说是在运行 Runtime 的 realizeClass 方法时，会生成 class_rw_t 结构体，该结构体包含了 class_ro_t，并且更新 data 部分，换成 class_rw_t 结构体的地址。<br/>
class_rw_t 和 class_ro_t 都存放着当前类的属性、方法、协议等。class_ro_t 存放的是编译期间就确定的；而 class_rw_t 是在 Runtime 时才确定，它会先将 class_ro_t 的内容拷贝过去，然后再将当前类的分类的属性、方法等拷贝到其中。可以说 class_rw_t 是 class_ro_t 的超集，当然实际访问类的方法、属性等也都是访问的 class_rw_t 中的内容。<br/>

3、如何理解OC是一门动态运行时语言？<br/>
将数据类型的确定由编译时推迟到了运行时，允许很多操作推迟到程序运行时再进行。

4、Runtime如何实现weak属性？<br/>
weak 表明该属性定义了一种「非拥有关系」。为这种属性设置新值时，设置方法既不持有新值（新指向的对象），也不释放旧值（原来指向的对象）。<br/>
Runtime 对注册的类，会进行内存布局，从一个粗粒度的概念上来讲，这时候会有一个 hash 表，这是一个全局表，表中是用 weak 指向的对象内存地址作为 key，用所有指向该对象的 weak 指针表作为 value。当此对象的引用计数为 0 的时候会 dealloc，假如该对象内存地址是 a，那么就会以 a 为 key，在这个 weak 表中搜索，找到所有以 a 为键的 weak 对象，从而设置为 nil。<br/>
Runtime 实现 weak 属性具体流程大致分为 3 步：<br/>
1）初始化时，Runtime 会调用 objc_initWeak 函数，初始化一个新的 weak 指针指向对象的地址。<br/>
2）添加引用时，objc_initWeak 函数会调用 objc_storeWeak() 函数，objc_storeWeak() 的作用是更新指针指向（指针可能原来指向着其他对象，这时候需要将该 weak 指针与旧对象解除绑定，会调用到 weak_unregister_no_lock），如果指针指向的新对象非空，则创建对应的弱引用表，将 weak 指针与新对象进行绑定，会调用到 weak_register_no_lock。在这个过程中，为了防止多线程中竞争冲突，会有一些锁的操作。<br/>
3）释放时，调用 clearDeallocating 函数，clearDeallocating 函数首先根据对象地址获取所有 weak 指针地址的数组，然后遍历这个数组把其中的数据设为 nil，最后把这个 entry 从 weak 表中删除，最后清理对象的记录。<br/>

5、介绍一下SideTable？<br/>
SideTable结构体是负责管理类的引用计数表和 weak 表的。<br/>

6、介绍一下OC中的消息机制？<br/>
OC中的方法调用其实都是转成了objc_msgSend函数的调用，给receiver（方法调用者）发送了一条消息（selector方法名）。<br/>
objc_msgSend底层有3大阶段：消息发送（当前类、父类中查找）、动态方法解析、消息转发。<br/>
1）消息发送</br>
![avatar](https://github.com/xzq666/iOS-High/blob/master/iOS-High-Study/iOS-High-Study/Runtime/消息发送.jpg)</br>
2）动态方法解析</br>
![avatar](https://github.com/xzq666/iOS-High/blob/master/iOS-High-Study/iOS-High-Study/Runtime/动态方法解析.jpg)</br>
3）消息转发</br>
将消息转发给别人。</br>
![avatar](https://github.com/xzq666/iOS-High/blob/master/iOS-High-Study/iOS-High-Study/Runtime/消息转发.jpg)</br>

7、Runtime 如何通过 selector 找到对应的IMP地址？<br/>
1）每一个类对象中都一个对象方法列表（对象方法缓存）。<br/>
2）类方法列表是存放在类对象中isa指针指向的元类对象中（类方法缓存）。<br/>
3）方法列表中每个方法结构体中记录着方法的名称、方法实现以及参数类型，其实selector本质就是方法名称，通过这个方法名称就可以在方法列表中找到对应的方法实现。<br/>
当我们发送一个消息给一个对象时，这条消息会在类对象的方法列表里查找。当我们发送一个消息给一个类时，这条消息会在元类对象的方法列表里查找。<br/>

8、说一下 Runtime 的方法缓存？存储的形式、数据结构以及查找的过程？<br/>
cache_t 增量扩展的哈希表结构。哈希表内部存储的 bucket_t 存储的是 SEL 和 IMP 的键值对。<br/>
cache_t 结构体与 bucket_t 结构体主要成员：<br/>

    struct cache_t {
        explicit_atomic<struct bucket_t *> _buckets;  // 散列表
        explicit_atomic<mask_t> _mask;  // 散列表长度 - 1
        uint16_t _occupied;  // 已经缓存的方法数量，散列表的长度大于已缓存的方法数量
    }
    
    struct bucket_t {
        explicit_atomic<SEL> _sel;  // SEL作为key
        explicit_atomic<uintptr_t> _imp;  // 函数的内存地址
    }
 cache_hash(k, m) 是静态内联方法，将传入的 key 和 mask 进行 & 操作返回 uint32_t 索引值。do-while 循环查找过程，当发生冲突 cache_next 方法将索引值减1。<br/>
 
 9、使用 Runtime 的 Associate 方法关联的对象，需要在主对象 dealloc 的时候释放么？<br/>
 不需要。被关联的对象在生命周期内要比对象本身释放的晚很多，它们会在被 NSObject - dealloc 调用的 object_dispose() 方法中释放。<br/>
 1）调用对象的 release 使引用计数变为0。<br/>
 对象正在被销毁，生命周期即将结束，不能再有新的 __weak 弱引用，否则将指向 nil。调用[self dealloc]。<br/>
 2）父类调用 dealloc。<br/>
 3）NSObject 调用 dealloc，调用OC Runtime 中的 object_dispose() 方法。<br/>
 4）调用 object_dispose()。<br/>
 为 C++ 的实例变量调用 destructors，为 ARC 状态下的实例变量调用 release，解除所有使用 Runtime Associate 方法关联的对象，解除所有 __weak 引用，调用 free()。<br/>
 
 10、能否向编译后得到的类中增加实例变量？能否向运行时创建的类中添加实例变量？为什么？<br/>
 不能向编译后得到的类中增加实例变量，可以向运行时创建的类中添加实例变量。<br/>
 1）编译后的类已经注册在 Runtime 中，类结构体中的 objc_ivar_list 实例变量的链表和 instance_size 实例变量的内存大小已经确定，同时 Runtime 会调用 class_setIvarLayout 或 class_setWeakIvarLayout 来处理 strong 或 weak 引用。所以不能向存在的类中添加实例变量。<br/>
 2）运行时创建的类是可以添加实例变量，调用 class_addIvar 函数。但是必须在调用 objc_allocateClassPair 之后，objc_registerClassPair 之前。<br/>
 
 11、Category 在编译过后，是在什么时机与原有的类合并到一起的？<br/>
 1）编译后，Runtime会进行初始化，调用_objc_init。<br/>
 2）调用 map_images。<br/>
 3）调用 map_images_nolock。<br/>
 4）调用 read_images，这个方法会读取所有的类的相关信息。<br/>
 5）调用 reMethodizeClass 重新方法化，方法内部会调用 attachCategories，传入 Class 和 Category，将 Category 的方法列表、协议列表等与原有类合并，最后加入到 class_rw_t 结构体中。<br/>
 
 12、_objc_msgForward 函数是做什么的，直接调用它将会发生什么？<br/>
 _objc_msgForward 是 IMP 类型，用于消息转发的。当向一个对象发送一条消息，但它并没有实现的时候，会尝试做消息转发。<br/>
 _objc_msgForward在进行消息转发的过程中会涉及以下这几个方法：<br/>
 1）resolveClassMethod <br/>
 2）forwardingTargetForSelector <br/>
 3）methodSignatureForSelector <br/>
 4）forwardInvocation <br/>
 5）doesNotRecognizeSelector <br/>
