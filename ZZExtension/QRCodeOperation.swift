//
//  QRCodeOperation.swift
//  ZZExtension
//
//  Created by rui on 2016/11/27.
//  Copyright © 2016年 isee15. All rights reserved.
//

import Cocoa
import CoreImage

class QRCodeOperation: NSObject, CommandOperation {

    func doAction(input: String) -> AnyObject {
        let img = generateQRCode(from: input)
        let attachmentCell = NSTextAttachmentCell(imageCell: img)
        let attachment = NSTextAttachment()
        attachment.attachmentCell = attachmentCell
        let attributeStr = NSAttributedString(attachment: attachment)

        return attributeStr
    }

    func reverseAction(input: String) -> String {
        let pasteboard = NSPasteboard.general()
        if let images = pasteboard.readObjects(forClasses: [NSImage.self], options: nil) as? [NSImage] {
            for image in images {
                let imageData = image.tiffRepresentation!
                let ciImage = CIImage(data: imageData)
                return performQRCodeDetection(image: ciImage!).decode
            }
        }
        return "detect QRCode from Clipboard"
    }

    func generateQRCode(from string: String) -> NSImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            let rep = NSCIImageRep(ciImage: filter.outputImage!.applying(transform))
            let outImage = NSImage()
            outImage.addRepresentation(rep)
            return outImage
        }

        return nil
    }

    func performQRCodeDetection(image: CIImage) -> (outImage: CIImage?, decode: String) {
        var resultImage: CIImage?
        var decode = ""
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: options)
        if let detector = detector {
            let features = detector.features(in: image)
            for feature in features as! [CIQRCodeFeature] {
                resultImage = drawHighlightOverlayForPoints(image: image, topLeft: feature.topLeft, topRight: feature.topRight,
                        bottomLeft: feature.bottomLeft, bottomRight: feature.bottomRight)
                decode = feature.messageString!
            }
        }
        return (resultImage, decode)
    }

    func drawHighlightOverlayForPoints(image: CIImage, topLeft: CGPoint, topRight: CGPoint,
                                       bottomLeft: CGPoint, bottomRight: CGPoint) -> CIImage {
        var overlay = CIImage(color: CIColor(red: 1.0, green: 0, blue: 0, alpha: 0.5))
        overlay = overlay.cropping(to: image.extent)
        overlay = overlay.applyingFilter("CIPerspectiveTransformWithExtent",
                withInputParameters: [
                        "inputExtent": CIVector(cgRect: image.extent),
                        "inputTopLeft": CIVector(cgPoint: topLeft),
                        "inputTopRight": CIVector(cgPoint: topRight),
                        "inputBottomLeft": CIVector(cgPoint: bottomLeft),
                        "inputBottomRight": CIVector(cgPoint: bottomRight)
                ])
        return overlay.compositingOverImage(image)
    }

}
