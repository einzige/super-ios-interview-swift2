import UIKit
import AVFoundation

@objc protocol PlayableDelegate: NSObjectProtocol {
    @objc optional func onPlayerFailure()
    @objc optional func beforeAudioLoad()
    @objc optional func onPlay()
    @objc optional func onFinishedPlaying()
    @objc optional func onStoppedPlaying()
    @objc optional func onPause()
}

class Player: AVPlayer, AVAudioPlayerDelegate {
    var currentPosition: Float = 0.0
    var delegate: PlayableDelegate?
    var playing: Bool {
        return rate > 0 && error == nil
    }
    
    override init() {
        super.init()
        addStatusObserver(self)
    }
    
    override init(playerItem item: AVPlayerItem?) {
        super.init(playerItem: item)
        addStatusObserver(self)
        observeItem(item!)
    }
    
    func addStatusObserver(_ observer: NSObject) {
        addObserver(observer, forKeyPath: "status", options: [], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if status == AVPlayerStatus.failed {
                globals.logger.info("Failed to initialize the player")
                delegate?.onPlayerFailure?()
            } else if status == AVPlayerStatus.readyToPlay {
                play(position: currentPosition)
            } else if status == AVPlayerStatus.unknown {
                globals.logger.info("Player status changed to unknown")
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            delegate?.onFinishedPlaying?()
        } else {
            delegate?.onStoppedPlaying?()
        }
    }
    
    override func pause() {
        print("PAUSE")
        super.pause()
        delegate?.onPause?()
    }
    
    override func play() {
        play(position: currentPosition)
    }
    
    func play(_ item: AVPlayerItem) {
        super.pause()
        currentPosition = 0.0
        observeItem(item)
    }

    func play(position: Float = 0.0) {
        super.pause()
        currentPosition = position
        
        if status == AVPlayerStatus.readyToPlay {
            if currentItem != nil {
                if currentItem!.status == AVPlayerItemStatus.readyToPlay {
                    print("PLAY")
                    delegate?.onPlay?()
                    //globals.logger.info("Playing \(currentItem)")
                    seek(to: getSeekTime())
                    super.play()
                } else {
                    if currentItem!.status == AVPlayerItemStatus.failed {
                        globals.logger.info("Audio item failed")
                    }
                    globals.logger.info("Audio item is not ready yet")
                }
            } else {
                globals.logger.info("Current item is nil")
            }
        } else {
            globals.logger.info("Player is not ready")
        }
    }
    
    fileprivate func observeItem(_ item: AVPlayerItem) {
        delegate?.beforeAudioLoad?()
        replaceCurrentItem(with: item)
        item.addObserver(self, forKeyPath: "status", options: [], context: nil)
    }
    
    fileprivate func getSeekTime() -> CMTime {
        let currentItemDuration = currentItem!.duration
        let duration = CMTimeGetSeconds(currentItemDuration)
        let seekPosition = duration * Float64(currentPosition)
        
        return CMTimeMakeWithSeconds(seekPosition, currentItemDuration.timescale)
    }
}
