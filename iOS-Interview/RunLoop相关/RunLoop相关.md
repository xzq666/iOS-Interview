##  RunLoop相关

1、什么是RunLoop？<br/>
RunLoop 是通过内部维护的事件循环(Event Loop)来对事件/消息进行管理的一个对象。<br/>
1）没有消息处理时休眠，以避免资源占用，CPU由用户态切换到内核态。<br/>
2）有消息需要处理时，立刻被唤醒，由内核态切换到用户态。<br/>
UIApplicationMain 内部默认开启了主线程的 RunLoop，并执行了一段无限循环的代码(不是简单的 for 循环 或 while 循环)。

    // 无限循环伪代码
    int main(int argc, char *argv[])
    {
        BOOL running = YES;
        do {
        
        } while (running);
        return 0;
    }
只要app在运行中，UIApplicationMain 函数就一直没有返回，而是不断接收处理消息以及等待休眠，所以运行程序之后会保持持续运行状态。

2、Runloop 和线程的关系？<br/>
一个线程对应一个 Runloop。主线程默认就有 Runloop，子线程的 Runloop 以懒加载的形式手动开启。Runloop 存储在一个全局的可变字典里，线程是 key，Runloop 是 value。<br/>

3、介绍一下 RunLoop 的运行模式？<br/>
1）kCFRunLoopDefaultMode：App的默认运行模式，通常主线程是在这个运行模式下运行的。<br/>
2）UITrackingRunLoopMode：跟踪用户交互事件（用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他Mode影响）<br/>
3）kCFRunLoopCommonModes：伪模式，不是一种真正的运行模式。<br/>
4）UIInitializationRunLoopMode：在刚启动App时第进入的第一个Mode，启动完成后就不再使用。<br/>
5）GSEventReceiveRunLoopMode：接受系统内部事件，通常用不到。<br/>
RunLoop只会运行在一个模式下，要切换模式，就要暂停当前模式，重写启动一个运行模式。<br/>

4、RunLoop 的内部逻辑是怎么样的？<br/>
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

5、autoreleasePool 是在何时被释放的？<br/>
App启动后，苹果在主线程 RunLoop 里注册了两个 Observer，其回调都是 _wrapRunLoopWithAutoreleasePoolHandler()。第一个 Observer 监视的事件是 Entry(即将进入RunLoop)，其回调内会调用 _objc_autoreleasePoolPush() 创建自动释放池。其 order 是 -2147483647，优先级最高，保证创建释放池发生在其他所有回调之前。第二个 Observer 监视了两个事件： BeforeWaiting(准备进入休眠) 时调用_objc_autoreleasePoolPop() 和 _objc_autoreleasePoolPush() 释放旧的池并创建新池；Exit(即将退出RunLoop) 时调用 _objc_autoreleasePoolPop() 来释放自动释放池。这个 Observer 的 order 是 2147483647，优先级最低，保证其释放池发生在其他所有回调之后。<br/>
在主线程执行的代码，通常是写在诸如事件回调、Timer回调内的。这些回调会被 RunLoop 创建好的 AutoreleasePool 环绕着，所以不会出现内存泄漏，开发者也不必显示创建 Pool 了。<br/>

6、GCD 在 Runloop 中有什么使用吗？<br/>
GCD 只有在由子线程返回到主线程的情况下才会触发 RunLoop。会触发 RunLoop 的 Source1 事件。<br/>

7、PerformSelector 的实现原理？<br/>
当调用 performSelecter:afterDelay: 后，实际上其内部会创建一个 Timer 并添加到当前线程的 RunLoop 中。所以如果当前线程没有 RunLoop，则这个方法会失效。<br/>
当调用 performSelector:onThread:时，实际上其会创建一个 Timer 加到对应的线程去，同样的，如果对应线程没有 RunLoop 该方法也会失效。<br/>

8、PerformSelector:afterDelay:这个方法在子线程中是否起作用？<br/>
不起作用，子线程默认没有 Runloop。可以使用 GCD 的 dispatch_after 来代替。<br/>

9、CADispalyTimer和Timer哪个更精确？<br/>
CADisplayLink 更精确。<br/>
iOS设备的屏幕刷新频率是固定的，CADisplayLink在正常情况下会在每次刷新结束都被调用，精确度相当高。CADisplayLink 内部实际是操作了一个 Source，如果在两次屏幕刷新之间执行了一个长任务，那其中就会有一帧被跳过去，造成界面卡顿的感觉。Facebook 开源的 AsyncDisplayLink 就是为了解决界面卡顿的问题，其内部也用到了 RunLoop。<br/>
NSTimer的精确度就显得低了点，比如NSTimer的触发时间到的时候，Runloop 如果在阻塞状态，触发时间就会推迟到下一个 Runloop 周期。并且 NSTimer新增了tolerance属性，让用户可以设置可以容忍的触发的时间的延迟范围。<br/>
CADisplayLink使用场合相对专一，适合做UI的不停重绘，比如自定义动画引擎或者视频播放的渲染。NSTimer的使用范围要广泛的多，各种需要单次或者循环定时处理的任务都可以使用。在UI相关的动画或者显示内容使用 CADisplayLink 比起用 NSTimer 的好处就是我们不需要在格外关心屏幕的刷新频率了，因为它本身就是跟屏幕刷新同步的。<br/>

10、RunLoop是怎么响应用户操作的，具体流程是怎么样的？<br/>
source1捕捉响应，source0执行响应。<br/>

11、说一说RunLoop的几种状态？<br/>
1）kCFRunLoopEntry：即将进入RunLoop。<br/>
2）kCFRunLoopBeforeTimers：即将处理Timer。<br/>
3）kCFRunLoopBeforeSources：即将进入Source。<br/>
4）kCFRunLoopBeforeWaiting：即将进入休眠。<br/>
5）kCFRunLoopAfterWaiting：刚从休眠中唤醒。<br/>
6）kCFRunLoopExit：即将退出RunLoop。<br/>

12、怎样保证子线程数据回来更新 UI 的时候不打断用户的滑动操作？<br/>
当我们在子请求数据的同时滑动浏览当前页面，如果数据请求成功要切回主线程更新 UI，那么就会影响当前正在滑动的体验。可以将更新 UI 事件放在主线程的 NSDefaultRunLoopMode 上执行，这样就会等用户不再滑动页面，主线程 RunLoop 由 UITrackingRunLoopMode 切换到 NSDefaultRunLoopMode 时再去更新 UI。<br/>

13、介绍一下 RunLoop 的数据结构？<br/>
NSRunLoop(Foundation) 是 CFRunLoop(CoreFoundation) 的封装，提供了面向对象的API。<br/>
RunLoop 相关的类主要有5个：<br/>
1）CFRunLoopRef(RunLoop对象)<br/>
由pthread(线程对象)、currentMode(当前所处的运行模式)、modes(多个运行模式的集合)、commonModes(模式名称字符串集合)、commonModeItems(Observer、Timer、Source集合)构成。<br/>
2）CFRunLoopModeRef(运行模式)<br/>
由name、source0、source1、observer、timers构成。<br/>
3）CFRunLoopSourceRef(输入源/事件源)<br/>
分为source0(非基于 port 的，也就是用户触发的事件。需要手动唤醒线程，将当前线程从内核态切换到用户态)和source1(基于 port 的，包含一个 mach_port 和一个回调，可监听系统端口和通过内核和其他线程发送的消息，能主动唤醒 RunLoop，接收分发系统事件)。<br/>
4）CFRunLoopTimerRef(定时源)<br/>
基于时间的触发器，基本上说的就是 NSTimer。在预定的时间点唤醒 RunLoop 执行回调。因为它是基于 RunLoop 的，因此它不是实时的(NSTimer 是不准确的。因为 RunLoop  只负责分发源的消息。如果线程当前正在处理繁重的任务，就有可能导致 Timer 本次延时，或者少执行一次)。
5）CFRunLoopObserverRef(观察者)<br/>
监听 RunLoop 的状态。<br/>

14、解释一下事件响应的过程？<br/>
苹果注册了一个 source1(基于 mach port 的)用来接收系统事件，其回调函数为__IOHIDEventSystemClientQueueCallback()。<br/>
当一个硬件事件(触摸/锁屏/摇晃等)发生后，首先由 IOKit.framework 生成一个 IOHIDEvent 事件并由 SpringBoard 接收。 SpringBoard 只接收按键(锁屏/静音等)、触摸、加速或接近传感器等几种 Event。然后用 mach port 转发给需要的 App 进程，此时苹果注册的那个 source1 就会触发回调，并调用 _UIApplicationHandleEventQueue() 进行应用内部的分发。<br/>
_UIApplicationHandleEventQueue() 会把 IOHIDEvent 事件处理并包装成 UIEvent 进行处理或分发，其中包括识别UIGesture、处理屏幕旋转、发送给UIWindow等。通常事件比如 点击、touchesBegin/Move/End/Cancel事件都是在这个回调中完成的。<br/>

15、解释一下手势识别的过程？<br/>
当_UIApplicationHandleEventQueue()识别了一个手势时，首先会调用Cancel将当前的touchesBegin/Move/End系列回调打断，随后系统将对应的UIGestureRecognizer标记为待处理。<br/>
苹果注册了一个 Observer 监测 BeforeWaiting 事件，这个 Observer 有个回调函数 _UIGestureRecognizerUpdateObserver()，其内部会获取所有刚被标记为待处理的UIGestureRecognizer，并执行UIGestureRecognizer的回调。<br/>
当任意UIGestureRecognizer变化(创建/销毁/状态改变)时，这个回调都会进行相应处理。<br/>

16、利用 RunLoop 解释一下页面的渲染过程？<br/>
当我们调用[UIView setNeedsDisplay]时会调用[view.layer setNeedsDisplay]。这等于给当前的 layer 打上了一个脏标记，而此时并没有直接进行绘制工作，而是会到当前的 Runloop
即将休眠，也就是 beforeWaiting 时才会进行绘制工作。<br/>
紧接着会调用[CALayer display]进入到真正绘制的工作。CALayer层会判断自己的 delegate 有没有实现异步绘制的代理方法 displayLayer ，这个代理方法是异步绘制的入口，如果没有实现这个方法，那么会继续进行系统绘制的流程，然后绘制结束。<br/>
CALayer 内部会创建一个Backing Store，用来获取图形上下文。接下来会判断这个 layer 是否有 delegate。若有，则调用[layer.delegate drawLayer:inContext:]，并返回[UIView drawRect:]的回调，让我们在系统绘制的基础上再做一些事情。若没有，则调用[CALayer drawInContext:]。以上两个分支，最终 CALayer 都会将位图提交到 Backing Store，最后提交给 GPU。至此绘制的过程结束。<br/>

17、什么是异步绘制？<br/>
异步绘制就是把需要绘制的图形提前在子线程处理好并将准备好的图像数据直接返给主线程使用，这样可以降低主线程的压力。<br/>
通过系统的[view.delegate displayLayer:]这个入口实现异步绘制。<br/>
1）代理负责生成对应的Bitmap。<br/>
2）设置该Bitmap为layer.contents属性的值。<br/>
