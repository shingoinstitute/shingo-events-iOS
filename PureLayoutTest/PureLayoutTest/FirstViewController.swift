//
//  FirstViewController.swift
//  PureLayoutTest
//
//  Created by Craig Blackburn on 2/12/16.
//  Copyright © 2016 Craig Blackburn. All rights reserved.
//

import UIKit
import Alamofire

class FirstViewController: UIViewController {

    var venueMaps = [VenueMap]()
    let stockPhotos = [
        "http://i.istockimg.com/image-zoom/69764945/3/380/253/stock-photo-69764945-dogs-playing.jpg",
        "http://i.istockimg.com/image-zoom/52848884/3/357/380/stock-photo-52848884-english-bulldog-puppy-3-months-old-.jpg",
        "http://i.istockimg.com/image-zoom/48185660/3/380/253/stock-photo-48185660-cute-cat-oudoors.jpg"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for url in stockPhotos
        {
            let venueMap = VenueMap(name: "pic name", url: url)
            venueMaps.append(venueMap)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as? ViewController
        destination?.venueMaps = venueMaps
    }
    

}

class VenueMap {
    var name:String!
    var url:String!
    var image:UIImage!
    
    init()
    {
        name = ""
        url = ""
        image = UIImage()
    }
    
    convenience init(name:String, url:String)
    {
        self.init()
        self.name = name
        self.url = url
        self.getImage(url)
    }
    
    func getImage(url:String)
    {
        Alamofire.request(.GET, url).responseImage
            { response in
                if response.result.isSuccess
                {
                    if let image = response.result.value
                    {
                        self.image = image
                        print("Image download success!")
                    }
                }
                else
                {
                    print("Image download failed!")
                }
        }
    }
}