//
//  VideoPlayer.swift
//  EggTimer
//
//  Created by Maxence Gama on 04/11/2020.
//

import UIKit
import AVKit

class VideoPlayer: UIView {
    
    private var playerLooper: AVPlayerLooper?

    @IBOutlet weak var vwPlayer: UIView!
    
    var player: AVQueuePlayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        let viewFromXib = Bundle.main.loadNibNamed("VideoPlayerView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
        addPlayerToView(self.vwPlayer)
    }
    
    fileprivate func addPlayerToView(_ view: UIView) {
        player = AVQueuePlayer()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.bounds
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.cornerRadius = 25
        view.layer.addSublayer(playerLayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerEndPlay), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func playVideoWithFileName(_ fileName: String) {
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: "mp4") else { return }
        let videoURL = URL(fileURLWithPath: filePath)
        let playerItem = AVPlayerItem(url: videoURL)
        player?.replaceCurrentItem(with: playerItem)
        player?.actionAtItemEnd = .none
        
        playerLooper = AVPlayerLooper(player: player!, templateItem: playerItem)
        
        player?.isMuted = true
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: AVAudioSession.CategoryOptions.mixWithOthers )
        
        playVideo()
    }
    
    func playVideo() {
        player?.play()
    }
    
    func stopVideo() {
        player?.pause()
    }

    @objc func playerEndPlay() {
        print("Player ended loop")
    }
    
    func createVideoComposition(for playerItem: AVPlayerItem) -> AVVideoComposition {
        let composition = AVVideoComposition(asset: playerItem.asset, applyingCIFiltersWithHandler: { request in
          // Here we can use any CIFilter
          guard let filter = CIFilter(name: "CIColorPosterize") else {
            return request.finish(with: NSError())
          }
          filter.setValue(request.sourceImage, forKey: kCIInputImageKey)
          return request.finish(with: filter.outputImage!, context: nil)
        })
        return composition
      }
}
