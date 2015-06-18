//
//  ViewController.swift
//  SwiftSweet
//
//  Created by Carlos Duran on 6/17/15.
//  Copyright (c) 2015 Carlos Duran. All rights reserved.
//

import UIKit

struct VCGlobalConstants {
    static let kSearchTerm = "nicola tesla"
    //    println(GlobalConstants.flickrKey)
}

class ViewController: UIViewController {

    @IBOutlet weak var imageViewer: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.imageViewer.backgroundColor = UIColor.lightGrayColor()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func loadImages(sender: AnyObject) {
        
        let flickr:FlickrHelper = FlickrHelper()
        
        flickr.searchFlickrForString(VCGlobalConstants.kSearchTerm, completion: {(searchString:String!, flickrPhotos:NSMutableArray!, error:NSError!) ->()  in
            
            let flickrPhoto:FlickrPhoto = flickrPhotos.objectAtIndex(Int(arc4random_uniform(UInt32(flickrPhotos.count)))) as! FlickrPhoto
            let image:UIImage = flickrPhoto.thumbnail
            dispatch_async(dispatch_get_main_queue(), {
                self.imageViewer.image = image;
                self.imageViewer.backgroundColor = UIColor.clearColor()
                

            })
        })
    }
}

