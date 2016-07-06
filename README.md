# GuidePage

本来是做个引导图呢，受到keepDemo的启发，发现它们的注册登录页效果感觉挺高大上，也给其他app登录注册提供了一种设计思路，即用视屏作页面背景。	
代码比较简单，用到的控件也比较少，话不多少，用的swift，直接上代码！

### 先上效果图

![image](https://github.com/zhuchen1990/testGuidePage/blob/master/GuidePage.gif )


### code
```
import UIKit
import AVFoundation
import AVKit

let kWidth = UIScreen.mainScreen().bounds.width
let kHeight = UIScreen.mainScreen().bounds.height
```

```
	override func viewDidLoad() {
        super.viewDidLoad()
        let filePath = NSBundle.mainBundle().pathForResource("1", ofType: "mp4")
        let url = NSURL(fileURLWithPath: filePath!)
        moviePlayController = AVPlayerViewController()
        player = AVPlayer(URL: url)
        moviePlayController.player = player
        moviePlayController.view.frame = self.view.bounds
        self.view.addSubview(moviePlayController.view)
        moviePlayController.showsPlaybackControls = false
        player.play()
    
        bgAlphaView.frame = moviePlayController.view.frame
        moviePlayController.view.addSubview(bgAlphaView)
        settingScrollView()
        settingTimer()
        
        //repate play
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.repeatPlay(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        
    }	

```
```
func settingScrollView() -> Void {
        scrollView.bounces = false
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.contentSize = CGSizeMake(kWidth * 4, scrollView.bounds.height)
        for index in 0..<4 {
            let label = UILabel()
            label.textAlignment = .Center
            label.frame.size = CGSizeMake(kWidth, 40)
            label.frame.origin = CGPointMake(CGFloat(index) * kWidth, scrollView.bounds.height - 60)
            label.textColor = UIColor.whiteColor()
            label.text = labels[index]
            scrollView.addSubview(label)
        }
        pageControl.currentPage = 0
    }


```
```
	func settingTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(self.changePage), userInfo: nil, repeats: true)
    }
    
    func changePage() {
       let page = (pageControl.currentPage + 1) % 4
       pageControl.currentPage = page
       scrollView.setContentOffset(CGPointMake(CGFloat(page) * kWidth, 0), animated: true)
    }
    
    func repeatPlay(noti : NSNotification){
        print("播放完成")
        //第几秒 ＝ value ／ timescale
        player.seekToTime(CMTime(value: 0, timescale: 1))
        player.play()
        
    }
```

```
extension ViewController : UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / kWidth)
        pageControl.currentPage = page
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        guard  let _ = timer else {
            return
        }
        timer.invalidate()
        timer = nil
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        settingTimer()
    }
    
}
```
代码比较简单，大家应该都能看的懂，由于MPMovieplayerController已经在ios9.0中被废弃了，用来替代的是AVPlayerViewcontroller，至于循环播放，MPMovieplayerController可以setRepeatMode为MPMovieRepeatModeOne，而AVPlayerViewcontroller没有找到这个属性，所以只能通过监听通知来实现了。
对AVkit框架有兴趣的同学可以查查apple的api，其实功能很强大！
