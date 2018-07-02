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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //imageviewをタップした時に色を判別
    @IBAction func getImageRGB(_ sender: UITapGestureRecognizer) {
        
        guard imageView.image != nil else {return}
        
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
        
        //navigationbarに結果を表示
        var navTitleArray = [String]()
        for i in 0..<pixelColors.count {
            var text: String!
            switch i {
            case 0:
                text = "R:" + String(Int(pixelColors[i]))
            case 1:
                text = " G:" + String(Int(pixelColors[i]))
            case 2:
                text = " B:" + String(Int(pixelColors[i]))
            default:
                //CGFloat → String
                text = " a:" + String(format: "%.1f", pixelColors[i])
            }
            navTitleArray.append(text)
        }
        navigationItem.title = navTitleArray.joined()
    }
    
    
}


//画像を選択
extension TapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //画像を選んだ時の処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //サイズを圧縮する
        // let resizedImage = selectedImage.scale(byFactor: 0.4)
        
        image = selectedImage
        
        var imageHeight = image.size.height
        var imageWidth = image.size.width
        
        let navigationBarHeight = navigationController?.navigationBar.frame.height
        let width = self.view.frame.width
        let height = self.view.frame.height
        let centerX = self.view.center.x
        let centerY = self.view.center.y
        let widthRatio = imageWidth
        let heightRatio = imageHeight
        //画像の大きさに応じてiamgeviewのサイズを変える
        if imageHeight > self.view.frame.height || imageWidth > self.view.frame.width {
            
            imageWidth = width
            imageHeight = width*heightRatio/widthRatio
            
        } else if imageHeight > self.view.frame.height {
            
            imageHeight = height
            imageWidth = height*widthRatio/heightRatio
            
        } else if imageWidth > self.view.frame.width {
            
            imageWidth = width
            imageHeight = width*heightRatio/widthRatio
            
        } else {
        }
        
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.frame.size = CGSize(width: imageWidth, height: imageHeight)
        //画像がnavigationbarに被らないようにする
        if imageHeight/2 > (height/2 - navigationBarHeight!) {
            imageView.center = CGPoint(x: centerX, y: centerY + navigationBarHeight!)
        } else {
            imageView.center = CGPoint(x: centerX, y: centerY)
        }
        
        imageView.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func tappedlibrary() {
        let sourceType:UIImagePickerControllerSourceType =
            UIImagePickerControllerSourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.photoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
        else{
            print("error")
            
        }
    }
    
    func tappedcamera() {
        let sourceType:UIImagePickerControllerSourceType =
            UIImagePickerControllerSourceType.camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
        else{
            print("error")
        }
    }
    
    @IBAction func selecteImageButton(_ sender: UITapGestureRecognizer) {
        //アラート表示のために
        let actionSheet = UIAlertController(title: "", message: "写真の選択", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let tappedcamera = UIAlertAction(title: "カメラで撮影する", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            self.tappedcamera()
        })
        
        let tappedlibrary = UIAlertAction(title: "ライブラリから選択する", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            self.tappedlibrary()
        })
        
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
            print("キャンセル")
        })
        
        actionSheet.addAction(tappedcamera)
        actionSheet.addAction(tappedlibrary)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    
    
}

