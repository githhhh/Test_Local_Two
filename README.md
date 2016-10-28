## 推荐一个不错的解决方案：

  虽然是swift ，但思路很不错。
  http://blog.csdn.net/VictorMoKai/article/details/48894873

  接管系统Bundle方法这样不需要在拷贝storyboardc文件到对应.lproj目录。

  object_setClass(NSBundle.mainBundle(), BundleEx.self)

  找到一个oc 版本：

  https://github.com/maximbilan/ios_language_manager/blob/master/README.md
  
## 我的 ios app国际化解决思路

> 本人愚笨, 写这个时间早,虽然可以实现，不过觉得上面的方法比较优雅。 以下仅做参考。
 
实现功能：

* 实现程序内切换语言，而不是重置系统语言。 
* 对于storyboard 和 xib 中用到的图片切换语言时不会丢失（不同语言公用图片）
* 支持storyboard 和xib 混用  
* 更新stroyboard 和xib 后 自动合并.string 文件，不会覆盖掉老数据。
（xcode默认会覆盖掉旧数据，根据修改后的storyboard或xib重新生成.string文件）

说明： 
   >   适用于不同语言使用相同图片在 sb 和 xib中。如果想不同语言使用不同图片在sb 和 xib 中的话，还是别折腾了吧。有那功夫还是直接在代码里写吧。


[实现过程](http://www.cnblogs.com/DamonTang/p/3972318.html)


