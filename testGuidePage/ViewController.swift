//
//  ViewController.swift
//  testGuidePage
//
//  Created by 朱晨 on 16/7/5.
//  Copyright © 2016年 ZhuChen. All rights reserved.
//

import UIKit
//import AVFoundation
import AVKit
import MediaPlayer

let kWidth = UIScreen.mainScreen().bounds.width
let kHeight = UIScreen.mainScreen().bounds.height

class ViewController: UIViewController {

    var moviePlayController : AVPlayerViewController!
    var player : AVPlayer!
    let labels = ["每个动作都精确规范","规划陪伴你的训练过程","分享汗水后你的性感","全程记录你的健身数据"]
    var timer : NSTimer!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bgAlphaView: UIView!
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
        
        
        //repate play
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.repeatPlay(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        bgAlphaView.frame = moviePlayController.view.frame
        moviePlayController.view.addSubview(bgAlphaView)
        settingScrollView()
        settingTimer()
        
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

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


