##  iOS调试技巧

1、LLDB常用的调试命令有哪些？<br/>
1）po：print object的缩写，表示显示对象的文本描述，如果对象不存在则打印nil。<br/>
2）p：可以用来打印基本数据类型。<br/>
3）call：执行一段代码 如：call NSLog(@"%@", @"yang")。<br/>
4）expr：动态执行指定表达式。<br/>
5）bt：打印当前线程堆栈信息 （bt all 打印所有线程堆栈信息）。<br/>
6）image：常用来寻找栈地址对应代码位置 如：image lookup --address 0xxxx。<br/>

2、断点调试有哪些？<br/>
1）条件断点：打上断点之后，对断点进行编辑，设置相应过滤条件。<br/>
1-1）Condition：返回一个布尔值，当布尔值为真触发断点，一般里面我们可以写一个表达式。<br/>
1-2）Ignore：忽略前N次断点，到N+1次再触发断点。<br/>
1-3）Action：断点触发事件，分为六种。<br/>
AppleScript：执行脚本。<br/>
Capture GPU Frame：用于OpenGL ES调试，捕获断点处GPU当前绘制帧。<br/>
Debugger Command：和控制台中输入LLDB调试命令一致。<br/>
Log Message：输出自定义格式信息至控制台。<br/>
Shell Command：接收命令文件及相应参数列表，Shell Command是异步执行的，只有勾选“Wait until done”才会等待Shell命令执行完在执行调试。<br/>
Sound：断点触发时播放声音。<br/>
1-4）Options：选中后，表示断点不会终止程序的运行。<br/>
2）异常断点：可以快速定位不满足特定条件的异常，比如常见的数组越界，这时候很难通过异常信息定位到错误所在位置，异常断点就可以发挥作用了。<br/>
Exception：可以选择抛出异常对象类型：OC或C++。<br/>
Break：选择断点接收的抛出异常来源是Throw还是Catch语句。<br/>
3）符号断点：符号断点的创建方式和异常断点一样，在符号断点中可以指定要中断执行的方法。<br/>
Symbol:[类名 方法名]可以执行到指定类的指定方法中开始断点。<br/>

3、iOS 常见的崩溃类型有哪些？<br/>
1）unrecognized selector crash。<br/>
2）KVO crash。<br/>
3）NSNotification crash。<br/>
4）NSTimer crash。<br/>
5）Container crash。<br/>
6）NSString crash。<br/>
7）Bad Access crash （野指针）。<br/>
8）UI not on Main Thread Crash。<br/>
