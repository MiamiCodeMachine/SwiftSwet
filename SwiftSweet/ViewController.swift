//
//  ViewController.swift
//  SwiftSweet
//
//  Created by Carlos Duran on 6/17/15.
//  Copyright (c) 2015 Carlos Duran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageViewer: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let flickr:FlickrHelper = FlickrHelper()

        flickr.searchFlickrForString("world", completion: {(searchString:String!, flickrPhotos:NSMutableArray!, error:NSError!) ->()  in
            let flickrPhoto:FlickrPhoto = flickrPhotos.objectAtIndex(0) as! FlickrPhoto
            let image:UIImage = flickrPhoto.thumbnail
            
            self.imageViewer.image = image;
            

        })

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

