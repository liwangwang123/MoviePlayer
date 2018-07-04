//
//  ViewController.swift
//  MoviePlayer
//
//  Created by lemo on 2018/7/3.
//  Copyright © 2018年 wangli. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player: AVPlayer?
    var item: AVPlayerItem?
    var playLayer: AVPlayerLayer?
    
    var slider: UISlider?
    var isreadToPlay: Bool?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //networkVideoPlay(urlString: "http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4")
        
        let file = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let fileName = file! + "/6a0.mp4"
        localVideoPlay(filePath: fileName)
        
        
    }
    
    //1, 网络视频播放
    func networkVideoPlay(urlString path: String) {
        let pathString = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: pathString!)
        item = AVPlayerItem(url: url!)
        
        player = AVPlayer(playerItem: item!)
        playLayer = AVPlayerLayer(player: player!)
        playLayer?.frame = self.view.bounds
        self.view.layer.addSublayer(playLayer!)
        player?.play()
    }
    
    //2, 本地视频播放
    func localVideoPlay(filePath path: String) {
        let pathString = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(fileURLWithPath: pathString!)
        item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        playLayer = AVPlayerLayer(player: player)
        playLayer?.frame = self.view.bounds
        self.view.layer.addSublayer(playLayer!)
        player?.play()
        
        //添加监听
        item?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            let status = (change![NSKeyValueChangeKey.newKey])!
            switch status {
            case AVPlayerItemStatus.failed:
                //失败
                print("加载失败")

            case AVPlayerItemStatus.readyToPlay:
                //失败
                print("准备播放")

            case AVPlayerItemStatus.unknown:
                //失败
                print("状态未知")

            default:
                print("hh")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

