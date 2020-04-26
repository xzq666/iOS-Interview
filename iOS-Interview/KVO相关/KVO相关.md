##  KVO相关

1、介绍一下KVO？<br/>
KVO(Key-Value Observing)是观察者模式的另一实现，使用了isa混写(isa-swizzling)来实现KVO，在添加完观察者之后，把被观察对象的isa指针指向了一个新的动态创建的继承自被观察者的NSKVONotifying_Object类，在这个新的动态创建类中重写setter方法，从而达到监听的效果。通过直接赋值成员变量不会触发KVO，setter需要加上willChangeValueForKey和didChangeValueForKey方法来手动触发才行。<br/>

2、KVO的实现原理是什么？<br/>
1）当给A类添加KVO的时候，runtime会动态生成一个子类NSKVONotifying_A，让A类的isa指针指向NSKVONotifying_A类，重写class方法，隐藏对象真实类信息；<br/>
2）重写监听属性的setter方法，内部调用了Foundation的_NSSetObjectValueAndNotify函数；<br/>
3）_NSSetObjectValueAndNotify函数内部首先调用willChangeValueForKey，然后给属性赋值，最后调用didChangeValueForKey，系统会调用observer的observeValueForKeyPath去告诉监听器属性值发生了改变；<br/>
4）重写dealloc进行KVO相关的内存释放；<br/>

3、如何手动触发KVO？<br/>
手动调用willChangeValueForKey和didChangeValueForKey。键值观察通知依赖于willChangeValueForKey和didChangeValueForKey，在一个被观察属性发生改变之前，willChangeValueForKey一定会被调用，这就会记录旧的值；而当改变发生后，didChangeValueForKey会被调用，继而observeValueForKey:ofObject:change:context:也会被调用。<br/>
