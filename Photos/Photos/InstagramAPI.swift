//
//  InstagramAPI.Swift
//  Photos
//
//  Created by Gene Yoo on 11/3/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import Foundation

class InstagramAPI {

    
    /* Connects with the Instagram API and pulls resources from the server. */
    func loadPhotos(completion: (([Photo]) -> Void)!) {
        /*
        * 1. Get the endpoint URL to the popular photos
        *    HINT: Look in Utils
        * 2. Create a Session
        * 3. Create a Data Task with a URL and completionHandler
        *    If no error:
        *       a. Get NSDictionary from the JSON object, from key the "photos"
        *       b. Create Array of NSDictionaries (one NSDictionary for each photo)
        *       c. For each NSDictionary, create a Photo object, and add to Photos array
        *       d. Wait for completion of Photos array
        */
        // FILL ME IN
        var url: NSURL
        url = Utils.getPopularURL()
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error == nil {
                //FIX ME
                var photos: [Photo]!
                do {
                    let feedDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    // FILL ME IN, REMEMBER TO USE FORCED DOWNCASTING
                    photos = []
                    let parsedPhotos = feedDictionary.valueForKey("data") as! NSArray
                    for (var i = 0; i < parsedPhotos.count; i++) {
                        let currentPhoto:NSDictionary = parsedPhotos.objectAtIndex(i) as! NSDictionary
                        photos.append(self.parseInstagramJson(currentPhoto))
                    }
                    
                    
                    // DO NOT CHANGE BELOW
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        dispatch_async(dispatch_get_main_queue()) {
                            completion(photos)
                        }
                    }
                } catch let error as NSError {
                    print("ERROR: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    func parseInstagramJson(instagramJson:NSDictionary) -> Photo {
        let user:NSDictionary = instagramJson.valueForKey("user") as! NSDictionary
        let username:String = (user.valueForKey("username"))! as! String
        let likes:NSDictionary  = instagramJson.valueForKey("likes") as! NSDictionary
        let numberOfLikes:Int = (likes.valueForKey("count"))! as! Int
        let allPhotoResolutions:NSDictionary  = instagramJson.valueForKey("images") as! NSDictionary
        let lowResolutionPhotos:NSDictionary = allPhotoResolutions.valueForKey("low_resolution") as! NSDictionary
        let photoUrl:String = (lowResolutionPhotos.valueForKey("url"))! as! String
        let photoProperties:NSDictionary = ["url": photoUrl, "username": username, "likes": numberOfLikes]
        let newPhoto = Photo(data: photoProperties)
        return newPhoto
    }
}