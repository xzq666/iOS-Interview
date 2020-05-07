##  RunLoop相关

1、Runloop 和线程的关系？<br/>
一个线程对应一个 Runloop。主线程默认就有 Runloop，子线程的 Runloop 以懒加载的形式手动开启。Runloop 存储在一个全局的可变字典里，线程是 key，Runloop 是 value。<br/>

2、介绍一下 RunLoop 的运行模式？<br/>
1）kCFRunLoopDefaultMode：App的默认运行模式，通常主线程是在这个运行模式下运行的。<br/>
2）UITrackingRunLoopMode：跟踪用户交互事件（用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他Mode影响）<br/>
3）kCFRunLoopCommonModes：伪模式，不是一种真正的运行模式。<br/>
4）UIInitializationRunLoopMode：在刚启动App时第进入的第一个Mode，启动完成后就不再使用。<br/>
5）GSEventReceiveRunLoopMode：接受系统内部事件，通常用不到。<br/>
RunLoop只会运行在一个模式下，要切换模式，就要暂停当前模式，重写启动一个运行模式。<br/>

3、RunLoop 的内部逻辑是怎么样的？<br/>
RunLoop 内部就是一个函数，函数内部是一个 do-while 循环。当调用 CFRunLoopRun() 时，线程就会一直停留在这个循环里，直到超时或被手动停止，该函数才会返回。<br/>
![avatar](https://upload-images.jianshu.io/upload_images/12311242-7d2c214d37c3d2ae.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200)<br/>
1）通知 Observer 即将进入 RunLoop。<br/>
2）通知 Observer 即将处理 Timer。<br/>
3）通知 Observer 即将处理非基于端口的输入源（即将处理 Source0）。<br/>
4）处理那些准备好的非基于端口的输入源（处理 Source0）。<br/>
5）如果基于端口的输入源准备就绪并等待处理，请立刻处理该事件。转到第 9 步（处理 Source1）。<br/>
6）通知 Observer 线程即将休眠。<br/>
7）将线程置于休眠状态，直到发生以下事件之一：事件到达基于端口的输入源（port-based input sources）、Timer 到时间执行、外部手动唤醒、为 RunLoop 设定的时间超时。<br/>
8）通知 Observer 线程刚被唤醒（还没处理事件）。<br/>
9）处理待处理事件：如果是 Timer 事件，处理 Timer 并重新启动循环，跳到第 2 步；如果输入源被触发，处理该事件；如果 RunLoop 被手动唤醒但尚未超时，重新启动循环，跳到第 2 步。<br/>
10）通知Observer即将退出RunLoop。<br/>

4、autoreleasePool 是在何时被释放的？<br/>
App启动后，苹果在主线程 RunLoop 里注册了两个 Observer，其回调都是 _wrapRunLoopWithAutoreleasePoolHandler()。第一个 Observer 监视的事件是 Entry(即将进入RunLoop)，其回调内会调用 _objc_autoreleasePoolPush() 创建自动释放池。其 order 是 -2147483647，优先级最高，保证创建释放池发生在其他所有回调之前。第二个 Observer 监视了两个事件： BeforeWaiting(准备进入休眠) 时调用_objc_autoreleasePoolPop() 和 _objc_autoreleasePoolPush() 释放旧的池并创建新池；Exit(即将退出RunLoop) 时调用 _objc_autoreleasePoolPop() 来释放自动释放池。这个 Observer 的 order 是 2147483647，优先级最低，保证其释放池发生在其他所有回调之后。<br/>
在主线程执行的代码，通常是写在诸如事件回调、Timer回调内的。这些回调会被 RunLoop 创建好的 AutoreleasePool 环绕着，所以不会出现内存泄漏，开发者也不必显示创建 Pool 了。<br/>

5、GCD 在 Runloop 中有什么使用吗？<br/>
GCD 只有在由子线程返回到主线程的情况下才会触发 RunLoop。会触发 RunLoop 的 Source1 事件。<br/>

6、PerformSelector 的实现原理？<br/>
当调用 performSelecter:afterDelay: 后，实际上其内部会创建一个 Timer 并添加到当前线程的 RunLoop 中。所以如果当前线程没有 RunLoop，则这个方法会失效。<br/>
当调用 performSelector:onThread:时，实际上其会创建一个 Timer 加到对应的线程去，同样的，如果对应线程没有 RunLoop 该方法也会失效。<br/>

7、PerformSelector:afterDelay:这个方法在子线程中是否起作用？<br/>
不起作用，子线程默认没有 Runloop。可以使用 GCD 的 dispatch_after 来代替。<br/>

8、CADispalyTimer和Timer哪个更精确？<br/>
CADisplayLink 更精确。<br/>
iOS设备的屏幕刷新频率是固定的，CADisplayLink在正常情况下会在每次刷新结束都被调用，精确度相当高。<br/>
NSTimer的精确度就显得低了点，比如NSTimer的触发时间到的时候，runloop如果在阻塞状态，触发时间就会推迟到下一个runloop周期。并且 NSTimer新增了tolerance属性，让用户可以设置可以容忍的触发的时间的延迟范围。<br/>
CADisplayLink使用场合相对专一，适合做UI的不停重绘，比如自定义动画引擎或者视频播放的渲染。NSTimer的使用范围要广泛的多，各种需要单次或者循环定时处理的任务都可以使用。在UI相关的动画或者显示内容使用 CADisplayLink 比起用 NSTimer 的好处就是我们不需要在格外关心屏幕的刷新频率了，因为它本身就是跟屏幕刷新同步的。<br/>

9、RunLoop是怎么响应用户操作的，具体流程是怎么样的？<br/>
source1捕捉响应，source0执行响应。<br/>

10、说一说RunLoop的几种状态？<br/>
1）kCFRunLoopEntry：即将进入Loop<br/>
2）kCFRunLoopBeforeTimers：即将处理Timer<br/>
3）kCFRunLoopBeforeSources：即将进入Source<br/>
4）kCFRunLoopBeforeWaiting：即将进入休眠<br/>
5）kCFRunLoopAfterWaiting：刚从休眠中唤醒<br/>
6）kCFRunLoopExit：即将退出Loop<br/>
