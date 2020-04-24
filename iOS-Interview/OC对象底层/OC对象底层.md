##  OC对象底层

1、一个NSObject对象占用多少内存空间？<br/>
受限于内存分配的机制，系统分配了16个字节给NSObject对象，但NSObject对象内部只使用了8个字节的空间（64bit环境下，可以通过class_getInstanceSize方法获取）（32bit环境下只使用4个字节）。对象在分配内存空间时，会进行内存对齐，所以在iOS中，分配内存空间都是16字节的倍数。<br/>

2、OC中的对象有哪几种？
1）instance对象：通过类alloc出来的对象，每次调用alloc都会产生新的instance对象。instance对象在内存中存储的信息包括isa指针、其他成员对象。<br/>
2）class对象（类对象）：每个类在内存中有且只有一个class对象。class对象在内存中存储的信息主要包括isa指针、superclass指针、类的属性信息(@property)、类的对象方法信息(instance method)、类的协议信息(protocol)、类的成员变量信息(ivar)。可以通过class方法或object_getClass(instance对象)获取。<br/>
3）meta-class对象（元类对象）：每个类在内存中有且只有一个meta-class对象。meta-class对象和class对象的内存结构是一样的，但是用途不一样。meta-class对象在内存中存储的信息主要包括isa指针、superclass指针、类的类方法信息。可以通过object_getClass(class对象)获取。<br/>

3、对象的isa指针指向哪里？<br/>
1）instance对象的isa指向class对象。当调用对象方法时，通过instance对象的isa找到class对象，最后找到对象方法的实现进行调用。<br/>
2）class对象的isa指向meta-class对象。当调用类方法时，通过class对象的isa找到meta-class对象，最后找到类方法的实现进行调用。<br/>
3）meta-class对象的isa指向基类的meta-class对象。 <br/>
补充：<br/>
instance的isa指向class、class的isa指向meta-class、meta-class的isa指向meta-class。 <br/>
class的superclass指向父类的class（如果没有父类，superclass指针为nil）、meta-class的superclass指向父类的meta-class（基类的meta-class的superclass指向基类的class）。 <br/>

4、OC的类信息放在哪里？<br/>
1）对象方法、属性、成员变量、协议信息存放在class对象中。 <br/>
2）类方法存放在meta-class对象中。 <br/>
3）成员变量的具体值存放在instance对象中。 <br/>

5、介绍一下OC中的属性关键字？<br/>
1）读写权限相关：readwrite(默认)、readonly(只读)。<br/>
2）原子性：atomic(默认)、nonatomic。atomic读写线程安全，但效率低，并且这种线程安全并不是绝对的安全，比如如果修饰的是数组，那么对数组的读写是安全的，但如果是操作数组进行添加移除其中对象的操作，就无法保证安全了。<br/>
3）引用计数：<br/>
retain/strong：修饰对象类型，会改变被修饰对象的引用计数。<br/>
assign：修饰基本数据类型。若修饰对象类型，因为不改变其引用计数，会产生悬垂指针，修饰的对象在被释放后，assign指针仍然指向原对象内存地址，如果再次使用assign指针继续访问原对象的话，就可能会导致内存泄漏或程序异常。<br/>
weak：不改变被修饰对象的引用计数，所指对象在被释放后，weak指针会自动置为nil。<br/>
copy：与strong关键字类似。不同的是，设置新值时，不保留新值，而是将其“拷贝”。修饰的对象是不可变对象。
OC中的拷贝分为深拷贝和浅拷贝。深拷贝是内容拷贝，会产生新对象；浅拷贝是指针拷贝，会增加原对象的引用计数。可变对象的copy和mutableCopy都是深拷贝；不可变对象的copy是浅拷贝，mutableCopy是深拷贝；copy方法返回的都是不可变对象。<br/>

6、@property(nonatomic, copy) NSMutableArray *array;这样写有什么影响？<br/>
因为copy方法返回的都是不可变对象，所以array实际上是不可变的，如果对其进行可变操作如添加移除对象，就会造成程序crash。<br/>

