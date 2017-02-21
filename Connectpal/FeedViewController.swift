import UIKit

class FeedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var posts: [AnyObject] = [AnyObject]()
    var profileImageCache = [Int: UIImage]()
    
    override func viewDidAppear(_ animated: Bool) {
        { return api.feed() } ~> postsLoaded
    }
    
    func postsLoaded(_ response: APIResponse) {
        self.posts = response.getData()["posts"] as! [AnyObject]
        self.collectionView?.reloadData()
        loader.isHidden = true
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewLayout.invalidateLayout()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "post-cell", for: indexPath) as! PostCell
        let post = Post(data: posts[indexPath.row] as! [String: AnyObject])
        let author = post.user!
        
        cell.pullFields(post)
        
        if author.smallProfilePictureUrl != nil {
            var image = profileImageCache[author.ID]
            
            if image == nil {
                // If the image does not exist, we need to download it
                let imgURL: URL = URL(string: author.smallProfilePictureUrl!)!
                
                // Download an NSData representation of the image at the URL
                let request: URLRequest = URLRequest(url: imgURL)
                
                
                NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: {(response: URLResponse?, data: Data?, error: NSError?) -> Void in
                    if error == nil {
                        image = UIImage(data: data!)
                        
                        // Store the image into the cache
                        self.profileImageCache[author.ID] = image! as UIImage
                        DispatchQueue.main.async(execute: {
                            if let cellToUpdate = collectionView.cellForItem(at: indexPath) as? PostCell {
                                cellToUpdate.postImage?.image = image
                            }
                        })
                    }
                    else {
                        print("Error: \(error!.localizedDescription)")
                    }
                } as! (URLResponse?, Data?, Error?) -> Void)
            } else {
                DispatchQueue.main.async(execute: {
                    if let cellToUpdate = collectionView.cellForItem(at: indexPath) as? PostCell {
                        cellToUpdate.postImage?.image = image
                    }
                })
            }
        }
        
        //let player = AudioPlayer(frame: CGRectMake(0,200,320,200))
        //cell.addSubview(player)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let post = Post(data: posts[indexPath.row] as! [String: AnyObject])
        
        // Virtual label to estimate cell's height
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue", size: 14.0)
        label.text = post.message?.htmlSafe
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        let screenSize = UIScreen.main.bounds
        let padding = 5 + 5 as CGFloat
        let margin = 5 + 5 as CGFloat
        
        let labelWidth = screenSize.width - padding - margin
        let maxHeight = 3999 as CGFloat
        
        let maxLabelSize = CGSize(width: labelWidth, height: maxHeight)
        let size = label.sizeThatFits(maxLabelSize)
    
        return CGSize(width: screenSize.width - margin, height: size.height + 120)
    }
}
