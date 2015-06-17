//
//  FlickrHelper.swift
//  SwiftSweet
//
//  Created by Carlos Duran on 6/17/15.
//  Copyright (c) 2015 Carlos Duran. All rights reserved.
//

import UIKit

struct GlobalConstants {
    static let flickrKey = "ca07d4b08e6a3ee86cf6d9a0b8803204"
    //    println(GlobalConstants.flickrKey)
}

class FlickrHelper: NSObject {

    class func  URLForSearchString (searchString:String) ->String {

        let apiKey:String = GlobalConstants.flickrKey
        let search:String =  searchString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(search)&per_page=20&format=json&nojsoncallback=1"
    }

    class func URLForFlickrPhoto(photo:FlickrPhoto, size:String)->String {
        var _size:String = size
        
        if size.isEmpty{
            _size = "m"
        }
        return
            "http://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.photoID)_\(photo.secret)_\(_size).jpg"
    }
    
    func searchFlickrForString(searchStr:String, completion:
                (searchString:String!, flickrPhotos:NSMutableArray!, error:NSError!)->())
    {
        let searchURL:String = FlickrHelper.URLForSearchString(searchStr)
        let queue:dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        dispatch_async(queue, {
            var error:NSError?

            let searchResultString:String! = String(contentsOfURL: NSURL(string: searchURL)!, encoding: NSUTF8StringEncoding, error: &error)

            if  error != nil {
                    completion(searchString: searchStr, flickrPhotos: nil, error: error)
            } else {
                let jsonData:NSData! = searchResultString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                let resultDict:NSDictionary! =  NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error) as! NSDictionary

                if  error != nil {
                    completion(searchString: searchStr, flickrPhotos: nil, error: error)
                } else {
                    let status:String = resultDict.objectForKey("stat") as! String
                    if status == "fail" {
                        let error:NSError? = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:resultDict])
                    } else {
                        let resultArray:NSArray =
                        resultDict.objectForKey("photos")?.objectForKey("photo") as! NSArray
                        
                        let flickrPhotos:NSMutableArray = NSMutableArray()
                        
                        for photoObject in resultArray {
                            let photoDict:NSDictionary = photoObject as! NSDictionary
                            // Let's see what we 'got
                            println(photoDict)
                            var flickrPhoto:FlickrPhoto = FlickrPhoto()
                            flickrPhoto.farm = photoDict.objectForKey("farm") as! Int
                            flickrPhoto.server = photoDict.objectForKey("server")as! String
                            flickrPhoto.secret = photoDict.objectForKey("secret") as! String
                            flickrPhoto.photoID = photoDict.objectForKey("id")as! String
                            
                            let searchURL:String = FlickrHelper.URLForFlickrPhoto(flickrPhoto, size: "m")
                            let imageData:NSData = NSData(contentsOfURL: NSURL(string: searchURL)!, options: nil, error: &error)!
                            let image:UIImage = UIImage(data: imageData)!
                            flickrPhoto.thumbnail = image
                            flickrPhotos.addObject(flickrPhoto)
                        }
                        completion(searchString: searchStr, flickrPhotos: flickrPhotos, error: nil)
                    }
            }
            }
    })
    }
}
