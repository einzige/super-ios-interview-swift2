import UIKit
import AVFoundation

@IBDesignable class AudioPlayer: DesignableView, PlayableDelegate {
    override var nibName: String? { return "AudioPlayer" }
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var timing: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var seekTarget: UIView!
    
    @IBAction func onPlayButtonClicked() {
        if player.playing {
            player.pause()
        } else {
            displayPlayMode()
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                var newBounds = self.view.bounds
                newBounds.size.width = self.view.bounds.width - 40
                
                self.view.bounds = newBounds
                self.view.layoutIfNeeded()
                self.initPendingState()
            }, completion: nil)
            player.play(position: position)
        }
    }
    
    var filePath: String? = "https://connectpal-media.s3.amazonaws.com/9e212140d69511e482582df3baba0229__a8beb860d69511e49f659554a76238a2____03-29-15---Andy-Dean---Whole-Show.mp3"
    
    fileprivate var _textColor = UIColor.black
    fileprivate var _position: Float = 0.0
    fileprivate var _item: AVPlayerItem?
    
    lazy var player: Player = {
        let result = Player(playerItem: self.item)
        result.delegate = self
        return result
    }()
    
    lazy var item: AVPlayerItem = {
        return AVPlayerItem(url: URL(string: self.filePath!)!)
    }()
    
    var position: Float {
        get { return _position }
        
        set(value) {
            if value < 0.03 {
                _position = 0.0
            } else if value > 1.0 {
                _position = 1.0
            } else if position < 0.0 {
                _position = 0.0
            } else {
                _position = value
            }
        }
    }
    
    @IBInspectable var textColor: UIColor {
        get { return _textColor }
        
        set(value) {
            _textColor = value
            title.textColor = _textColor
            timing.textColor = _textColor
        }
    }
    
    @IBInspectable var backgroundLayerColor: UIColor? {
        get { return view.backgroundColor }
        
        set(value) {
            view.backgroundColor = value
        }
    }
    
    override func didMoveToSuperview() {
        loader.stopAnimating()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AudioPlayer.onSeek(_:)))
        seekTarget.addGestureRecognizer(tapRecognizer)
    }
    
    override func setupView() {
        view.autoresizingMask = UIViewAutoresizing.flexibleWidth
        var newFrame = view.frame
        newFrame.size = CGSize(width: newFrame.width, height: 40.0);
        view.frame = newFrame;
    }
    
    func onSeek(_ sender: UITapGestureRecognizer) {
        let xLocation = sender.location(in: seekTarget).x
        position = Float(xLocation / seekTarget.bounds.width)
        
        progressBar.setProgress(position, animated: true)
        player.play(position: position)
    }
    
    func onPause() {
        playButton.setTitle("▶︎", for: UIControlState())
    }
    
    func onPlay() {
        displayPlayMode()
    }
    
    fileprivate func displayPlayMode() {
        playButton.setTitle("❚❚", for: UIControlState())
    }
    
    fileprivate func initPendingState() -> Bool{
        loader.startAnimating()
        return true
    }
}
