//
//  Mosaic.swift
//  Mosaic
//
//  Created by Ashif Khan on 10/02/16.

import UIKit

class Mosaic:NSObject{
    static var tileSize:Int=20
    
    ////Resize image
    class func scaleImage(image: UIImage, toSize newSize: CGSize) -> (UIImage) {
        let newRect = CGRectIntegral(CGRectMake(0,0, newSize.width, newSize.height))
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetInterpolationQuality(context, .High)
        let flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height)
        CGContextConcatCTM(context, flipVertical)
        CGContextDrawImage(context, newRect, image.CGImage)
        let newImage = UIImage(CGImage: CGBitmapContextCreateImage(context)!)
        UIGraphicsEndImageContext()
        return newImage
    }
    class func generateMosaik(fromImages:Array<UIImage>,forImage:UIImage)->UIImage {
        
        ///Double the size of original image....
        let forImageDouble:UIImage=Mosaic.scaleImage(forImage, toSize: CGSizeMake(forImage.size.width * 4.0, forImage.size.width * 4.0))
        
        ///count the rows and columns to be generated based upon the tileSize
        let rows:Int = Int(forImageDouble.size.width / CGFloat(tileSize))
        let cols:Int = Int(forImageDouble.size.height / CGFloat(tileSize))
        
        ////cache for the tiles generated earlier
        var tiles=Dictionary<Int,UIImage>()
        
        ///begin a new image context for our drwaing purposes
        ///this new image context acts as a canvas for drawing
        UIGraphicsBeginImageContext(forImageDouble.size)
        for (var i=0;i<rows;i++){
            for(var j=0;j<cols;j++){
                ///get a random number from 0 to number of supporting images available
                let random=Int(arc4random_uniform(UInt32(fromImages.count)))
                if tiles[random] == nil{
                    /// if a tile with given number does not exists
                    /// create a tile for the given number from source image
                    /// and store it inside the dictionary(tiles)
                    tiles[random]=Mosaic.scaleImage(fromImages[random], toSize: CGSizeMake(CGFloat(tileSize), CGFloat(tileSize)))
                }
                /// Use the tile to draw in the image context
                tiles[random]!.drawInRect(CGRectMake(CGFloat(i * tileSize), CGFloat(j * tileSize), CGFloat(tileSize), CGFloat(tileSize)))
            }
        }
        /// Tiles drawing is done, now clear the dictionary
        tiles.removeAll()
        /// Draw the overlay image in the context with opacity less then 1.0 to get the Mosaik effect
        forImageDouble.drawInRect(CGRect(origin: CGPointZero, size: forImageDouble.size),blendMode:.Normal, alpha:0.6)
        /// store the result of context, this is our final output
        let finalImage:UIImage  = UIGraphicsGetImageFromCurrentImageContext();
        
        /// clear the image context
        UIGraphicsEndImageContext();
        
        ///return the result
        return finalImage;
    }
}