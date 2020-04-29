##  block相关

1、什么是block？什么是block调用？<br/>
block是将函数及其执行上下文封装起来的对象，本质是一个OC对象，内部也有一个isa指针。block调用就是函数的调用。<br/>

2、谈一谈block的变量截获？<br/>
1）局部变量（涉及到跨函数访问，所以肯定要捕获）。对于局部auto变量（离开作用域就销毁），会捕获到block内部，并且是值传递。对于局部static变量，会捕获到block内部，并且是指针传递。<br/>
2）全局变量：无论是auto还是static的全局变量都不会捕获到block内部，而是直接访问。<br/>
3）__block修饰的局部变量，block会以指针形式捕获，并且生成一个新的结构体对象，该对象会有个指向自身的指针__forwarding以及对应的局部变量值。<br/>

3、介绍一下block的几种形式？<br/>
block有全局block( _NSConcreteGlobalBlock)、栈block(_NSConcreteStackBlock)、堆block(_NSConcreteMallocBlock )三种形式，其中栈block存储在栈(stack)区，堆block存储在堆(heap)区，全局block存储在已初始化数据(.data)区。<br/>
全局block是没有访问局部auto变量的block，对其进行copy操作后仍然是全局block；栈block是访问了局部auto变量且没有进行copy操作的block，对其进行copy操作后会变成堆block；堆block是访问了局部auto变量且进行了copy操作的block，对其进行copy操作会增加引用计数。<br/>
注意：<br/>
在ARC环境下，编译器会根据情况自动将栈上的block复制到堆上。比如：
1）block作为函数返回值时。<br/>
2）将block赋值给__strong指针时。<br/>
3）block作为Cocoa API中方法名含有UsingBlock的方法参数时。<br/>
4）block作为GCD参数时。<br/>

4、__forwarding指针的意义是什么？<br/>
__block修饰局部auto变量在copy时，由于__forwarding的存在，栈上的指针会指向堆上的__forwarding变量，而堆上的__forwarding指针指向其自身，所以，如果对__block修饰的局部auto变量修改，实际上是在修改堆上的__block变量。这样，无论在任何内存位置，都可以顺利地访问同一个__block变量。block捕获的__block修饰的变量会去持有变量。

5、__block修饰符的作用是什么？有什么使用注意点？<br/>
编译器会将__block修饰的局部auto变量包装成一个对象，可用于解决block内部无法修改局部auto变量值的问题。__block不能修饰全局变量和局部静态变量。<br/>

6、介绍一下__block的内存管理？<br/>
当block在栈上时，并不会对__block变量产生强引用。<br/>
当block被copy到堆时：<br/>
1）会调用block内部的copy函数；<br/>
2）copy函数内部会调用_Block_object_assign函数；<br/>
3）_Block_object_assign函数会对__block变量形成强引用。<br/>
当block从堆中移除时：<br/>
1）会调用block内部的dispose函数；<br/>
2）dispose函数内部会调用_Block_object_dispose函数；<br/>
3）_Block_object_dispose函数会自动释放引用的__block变量。<br/>

7、block在内部新增或删除NSMutableArray中的元素时需不需要添加__block？<br/>
不需要。<br/>

8、block为什么会产生循环引用？如何解决block的循环引用问题？<br/>
对象有一个block属性，这个Block属性中又对这个对象本身产生强引用，故而产生循环引用。<br/>
在ARC环境下首选__weak、__unsafe_unretained解决，也可以使用__block，但是使用__block必须调用block，在block内部将对象置为nil。而MRC环境下没有__weak，并且使用__block不会对所指向对象进行retain，因此作为首选。<br/>

9、block的属性修饰词为什么是copy？使用block有哪些使用注意？<br/>
当block在使用外部的局部auto变量时，内存是存在于栈区的，栈区的特点是对象随时有可能被销毁，一旦销毁后再继续调用就会造成系统崩溃。用copy修饰block是为了将其copy到堆上，从而自己管理内存。使用block需要注意循环引用的问题。
