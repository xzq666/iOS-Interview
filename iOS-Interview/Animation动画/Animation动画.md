##  Animation动画

1、UIView动画与核心动画的区别？<br/>
核心动画只作用在layer，核心动画修改的值都是假像，它的真实位置没有发生变化。当需要与用户进行交互时用UIView动画，不需要与用户进行交互时两个都可以。<br/>

2、请说一下对CALayer的认识？<br/>
layer层是涂层绘制、渲染、以及动画的完成者，它无法直接处理触摸事件(也可以捕捉事件)。layer包含的方面非常多，常见的属性有Frame、Bounds、Position、AnchorPoint、Contents等。<br/>

3、CALayer的Contents有哪些主要属性？<br/>
ContentsRect：单位制(0 - 1)，限制显示的范围区域。<br/>
ContentGravity：类似于ContentMode，不过不是枚举值，而是字符串。<br/>
ContentsScale：决定了物理显示屏是什么屏。<br/>
ContentsCenter：跟拉伸有关的属性。<br/>

4、什么是隐式动画？<br/>
每一个UIView内部都默认有着一个CALayer，称之为Root Layer(根层)，而所有的非Root Layer，即手动创建的CALayer对象都默认存在着隐式动画，当对这些手动创建的CALayer的部分属性进行修改时，就会默认产生一些动画效果，而这些属性则称之为可动画属性(Animatable Properties)。例如bounds、backgroundColor、position等都是动画属性。<br/>
默认的隐式动画可以通过CATransaction的setDisableActions来关闭。<br/>
CALayer有两个非常重要的属性：<br/>
1）position：用来设置CALayer在分层中的位置，以父层的左上角为原点。<br/>
2）anchorPoint：锚点，是描述CALayer自身的，决定着CALayer上哪个点定位在position属性所在的父层的位置，以自身的左上角为原点，默认为CALayer的中点(0.5，0.5)，注意锚点的x、y取值范围为0~1。<br/>

5、介绍一下核心动画？<br/>
核心动画(Core Animation)的动画执行过程都是在后台线程操作的，不会阻塞主线程。<br/>
核心动画的使用步骤：<br/>
1）首先要有一个CALayer。<br/>
2）初始化一个CAAnimation对象，设置相关动画属性。<br/>
3）调用CALayer的addAnimation:forKey:方法，将CAAnimation对象添加到CALayer中，开始动画。<br/>
4）调用CALayer的removeAnimationForKey:方法可停止CALayer中的动画。<br/>
常用的核心动画有：基本动画、关键帧动画、转场动画、动画组。<br/>
