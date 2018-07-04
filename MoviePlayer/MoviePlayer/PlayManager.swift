//
//  PlayManager.swift
//  MoviePlayer
//
//  Created by lemo on 2018/7/4.
//  Copyright © 2018年 wangli. All rights reserved.
//

import UIKit
import AVFoundation

class PlayManager: NSObject {
    
    var player: AVPlayer?
    var item: AVPlayerItem?
    var playLayer: AVPlayerLayer?
    
    var isreadToPlay: Bool?
    
    var viewController: UIViewController?
    
    func playVideo(filepath path: String) {
        let filepath = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(fileURLWithPath: filepath!)
        play(url: url)
    }
     //1, 网络视频播放
    func playVideo(urlString path: String) {
        let urlString = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlString!)
        play(url: url!)
        
    }
    
    func play(url: URL) {
        item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item!)
        playLayer = AVPlayerLayer(player: player!)
        playLayer?.frame = (viewController?.view.bounds)!
        viewController?.view.layer.addSublayer(playLayer!)
        item?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
//        player?.play()
    }

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            let status = AVPlayerItemStatus(rawValue: (change![NSKeyValueChangeKey.newKey])! as! Int)
            switch status {
            case .failed?:
                //加载失败
                print("加载失败")
                self.isreadToPlay = false
            case .readyToPlay?:
                //准备播放
                self.isreadToPlay = true
                print("准备播放:\(String(describing: player?.currentTime()))")
                
                
            case .unknown?:
                //状态未知
                print("状态未知")
                self.isreadToPlay = false
                
            default:
                print("hh")
            }
        }
    }

    deinit {
        item?.removeObserver(self, forKeyPath: "status")
    }
}
