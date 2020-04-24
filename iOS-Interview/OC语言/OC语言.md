##  OC语言

1、nil、NIL、NSNull有什么区别？<br/>
NIL -> Null-pointer to objective-c class：特对于表示OC的Class类型对象为NULL，表示其对象指针不指向任何对象。如果要把一个Class类型的对象设置为空的时候就用Nil。<br/>
nil -> Null-pointer to objective- c object：特对于表示OC的object对象为NULL，表示其对象指针不指向任何对象。如果要把一个对象设置为空的时候就用nil。<br/>
因为在NSArray和NSDictionary中nil中有特殊的含义，表示列表，所以不能在其中放入nil值。如要确实需要存储一个表示“什么都没有”的值，可以使用NSNull类。<br/>
nil、NIL 可以说是等价的，都代表内存中一块空地址。NSNull代表一个指向nil的对象。OC中可以向nil、Nil发送消息，但不能向NSNull发送消息。<br/>

2、如何实现一个线程安全的NSMutableArray？<br/>
NSMutableArray是线程不安全的，当有多个线程同时对数组进行操作的时候可能导致崩溃或数据错误。<br/>
1）使用线程锁对数组读写时进行加锁。（读写锁）<br/>
2）使用“串行同步队列”，将读取操作及写入操作都安排在同一个队列里，即可保证数据同步。<br/>
3）通过并发队列，结合GCD的栅栏块(dispatch_barrier_sync)实现数据同步线程安全，并且比串行同步队列方式更高效。<br/>

3、id和instancetype有什么区别？<br/>
instancetype和id都是万能指针，指向对象。<br/>
1）id在编译的时候不能判断对象的真实类型，instancetype在编译的时候可以判断对象的真实类型。<br/>
2）id可以用来定义变量，可以作为返回值类型，也可以作为形参类型；instancetype只能作为返回值类型。<br/>

4、self和super的区别？<br/>
1）self调用自己方法，super调用父类方法。<br/>
2）self是类，super是预编译指令。<br/>
3）[self class]和[super class]输出是一样的。当使用self调用方法时，会从当前类的方法列表中开始找；而当使用super时，则从父类的方法列表中开始找。
当使用self调用时，底层会使用objc_msgSend函数，传入的是消息接收者，即类自身；当使用super调用时，则会使用objc_msgSendSuper函数，传入的是一个包括接收者和superClass指针的结构体，调用时会从接收者的superClass的方法列表中开始找。<br/>

5、@synthesize和@dynamic分别有什么作用？<br/>
1）@property有两个对应的词，一个是@synthesize，一个是@dynamic。如果@synthesize和@dynamic都没写，那么默认的就是@syntheszie var = _var;<br/>
2）@synthesize的意思是如果你没有手动实现setter方法和getter方法，那么编译器会自动为你加上这两个方法。@dynamic则是告诉编译器属性的setter与getter方法由用户自己实现，不自动生成。（当然对 readonly的属性只需提供getter即可）。<br/>
假如一个属性被声明为@dynamic，并且没有提供@setter方法和@getter方法，编译的时候没问题，但是当程序运行到setter或getter时就会crash。编译时没问题，运行时才执行相应的方法，这就是所谓的动态绑定。<br/>

6、__typeof__和__typeof和typeof的区别？<br/>
__typeof __( )和__typeof( )是C语言的编译器特定扩展，因为标准C不包含这样的运算符。<br/> 标准C要求编译器用双下划线前缀语言扩展（这也是为什么你不应该为自己的函数，变量等做这些）。<br/>
typeof( )与前两者完全相同，只不过去掉了下划线，同时现代的编译器也可以理解。<br/>
所以这三个意思是相同的，但没有一个是标准C，不同的编译器会按需选择符合标准的写法。<br/>

7、介绍一下OC中的类簇？<br/>
OC中有许多类簇，大部分collection类都是类簇。例如NSArray与其可变版本NSMutableArray。这样看来实际上有两个抽象基类，一个用于不可变数组，一个用于可变数组。尽管具备公共接口的类有两个，但仍然可以合起来算一个类簇。不可变的类定义了对所有数组都通用的方法，而可变类则定义了那些只适用于可变数组的方法。两个类共同属于同一个类簇，这意味着二者在实现各自类型的数组时可以共用实现代码，此外还能把可变数组复制成不可变数组，反之亦然。

8、struct和class的区别？<br/>
class是引用类型（位于栈上面的指针(引用)和位于堆上的实体对象）；结构体是值类型（实例直接位于栈中）。
