##  KVC相关

1、介绍一下KVC？<br/>
KVC(Key-Value Coding)就是指iOS的开发中，可以允许开发者通过Key名直接访问对象的属性，或者给对象的属性赋值。而不需要调用明确的存取方法。这样就可以在运行时动态地访问和修改对象的属性。而不是在编译时确定，这也是iOS开发中的黑魔法之一。

2、KVC的原理是什么？即KVC的赋值和取值过程是什么？<br/>
赋值：<br/>
1）按照setKey、_setKey的顺序查找方法。<br/>
2）若找到方法则传递参数、调用方法；若没找到方法查看accessInstanceVariablesDirectly方法的返回值。<br/>
3）若返回NO调用setValue:forUndefinedKey:并抛出异常NSUnknownKeyException；若返回YES按照_key、_isKey、key、isKey顺序查找成员变量（默认返回YES）。<br/>
4）若找到成员变量直接赋值；若没找到调用setValue:forUndefinedKey:并抛出异常NSUnknownKeyException。<br/>
取值：<br/>
1）按照getKey、key、isKey、_key顺序查找方法。<br/>
2）若找到方法则调用方法；若没找到查看accessInstanceVariablesDirectly方法的返回值。<br/>
3）若返回NO调用valueForUndefinedKey:并抛出异常NSUnknownKeyException；若返回YES按照_key、_isKey、key、isKey顺序查找成员变量。<br/>
4）若找到成员变量直接赋值；若没找到调用valueForUndefinedKey:并抛出异常NSUnknownKeyException。<br/>

3、通过KVC修改属性会触发KVO吗？<br/>
会触发KVO。<br/>
