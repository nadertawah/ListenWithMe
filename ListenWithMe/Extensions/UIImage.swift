//
//  UIImage.swift
//  ListenWithMe
//
//  Created by nader said on 20/08/2022.
//

import UIKit

extension UIImage
{
    var isPortrait:  Bool    { return size.height > size.width }
    var isLandscape: Bool    { return size.width > size.height }
    var breadth:     CGFloat { return min(size.width, size.height) }
    var breadthSize: CGSize  { return CGSize(width: breadth, height: breadth) }
    var breadthRect: CGRect  { return CGRect(origin: .zero, size: breadthSize) }
    
    var circleMasked: UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait  ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    static func imageFromString(imgSTR: String) -> UIImage?
    {
        guard let decodedData = NSData(base64Encoded: imgSTR, options: NSData.Base64DecodingOptions(rawValue: 0)) else{return nil}
        
        let image = UIImage(data: decodedData as Data)
        
        return image
    }
    
    func imageToString() -> String
    {
        self.jpegData(compressionQuality: 0.2)!.base64EncodedString()
    }
    
    func resizeImageTo(size: CGSize) -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
