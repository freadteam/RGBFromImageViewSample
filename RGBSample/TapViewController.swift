//
//  TapViewController.swift
//  RGBSample
//
//  Created by Ryo Endo on 2018/06/29.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import UIKit

class TapViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var image = UIImage()
    //表示されている画像のタップ座標用変数
    var tapPoint = CGPoint(x: 0, y: 0)
    
    
    override func viewDidLoad() {
        //image = UIImage(named: "mitsushima.jpg")!
        //image = UIImage(named: "cat.jpg")!
        image = UIImage(named: "test.jpg")!
        var imageHeight = image.size.height
        var imageWidth = image.size.width
        print(imageHeight, imageWidth)
        let width = self.view.frame.width
        let height = self.view.frame.height
        let centerX = self.view.center.x
        let centerY = self.view.center.y
        let widthRatio = imageWidth
        let heightRatio = imageHeight
        //画像の大きさに応じてiamgeviewのサイズを変える
        if imageHeight > self.view.frame.height && imageWidth > self.view.frame.width {
                print("1")
                imageWidth = width
                imageHeight = width*heightRatio/widthRatio
        } else if imageHeight > self.view.frame.height {
            print("3")
            imageHeight = height
            imageWidth = height*widthRatio/heightRatio
            
        } else if imageWidth > self.view.frame.width {
            print("4")
            imageWidth = width
            imageHeight = width*heightRatio/widthRatio
        } else {
            print("そのままを表示")
        }

        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.frame.size = CGSize(width: imageWidth, height: imageHeight)
        print(imageHeight, imageWidth)
        imageView.center = CGPoint(x: centerX, y: centerY)
        imageView.image = image
        // 撮影した画像をデータ化したときに右に90度回転してしまう問題の解消
        //        UIGraphicsBeginImageContext(image.size)
        //        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        //        image.draw(in: rect)
        //        image = UIGraphicsGetImageFromCurrentImageContext()!
        //        UIGraphicsEndImageContext()
        //let data = UIImagePNGRepresentation(image)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   //imageviewをタップした時に色を判別
    @IBAction func getImageRGB(_ sender: UITapGestureRecognizer) {
        //タップした座標の取得
        tapPoint = sender.location(in: imageView)
        
        let cgImage = imageView.image?.cgImage!
        let pixelData = cgImage?.dataProvider!.data
        let data: UnsafePointer = CFDataGetBytePtr(pixelData)
        //1ピクセルのバイト数
        let bytesPerPixel = (cgImage?.bitsPerPixel)! / 8
        //1ラインのバイト数
        let bytesPerRow = (cgImage?.bytesPerRow)!
        print("bytesPerPixel=\(bytesPerPixel) bytesPerRow=\(bytesPerRow)")
        //タップした位置の座標にあたるアドレスを算出
        let pixelAd: Int = Int(tapPoint.y) * bytesPerRow + Int(tapPoint.x) * bytesPerPixel
        //それぞれRGBAの値をとる
        let r = CGFloat(Int( CGFloat(data[pixelAd])))///CGFloat(255.0)*100)) / 100
        let g = CGFloat(Int( CGFloat(data[pixelAd+1])))///CGFloat(255.0)*100)) / 100
        let b = CGFloat(Int( CGFloat(data[pixelAd+2])))///CGFloat(255.0)*100)) / 100
        let a = CGFloat(Int( CGFloat(data[pixelAd+3])/CGFloat(255.0)*100)) / 100
        
        let pixelColors = [r,g,b,a]
        print(pixelColors,tapPoint)
        
    }
    
    
}
