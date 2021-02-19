//
//  ImagePicker.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2021/2/6.
//

import Foundation
import SwiftUI

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @ObservedObject var imageObjectDetector: ImageObjectDetector
    @Binding var isShown: Bool
    @Binding var isShowCameraView: Bool
    
    init(imageObjectDetector: ObservedObject<ImageObjectDetector>, isShown: Binding<Bool>, isShowCameraView: Binding<Bool>) {
        _imageObjectDetector = imageObjectDetector
        _isShown = isShown
        _isShowCameraView = isShowCameraView
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            imageObjectDetector.updateImage(image: uiImage)
            // 延迟后面语句的执行直到getPredictResult中的网络请求返回结果 -> completionHandler: parseObjectsFromResponse(data:response:error:)
            imageObjectDetector.getPredictResult()
            
            isShown = false
            isShowCameraView = true
//            {
//              "isSuccess": true,
//              "rel": [
//                {
//                  "name": "狗",
//                  "x1": 204,
//                  "y1": 44,
//                  "x2": 450,
//                  "y2": 452,
//                  "specInfo": {
//                    "category": "动物",
//                    "name": "狗",
//                    "id": 524,
//                    "url": "http://image.uniskare.xyz/image/object/动物/狗.png",
//                    "wordType": "宾语"
//                  }
//                },
//                {
//                  "name": "猫",
//                  "x1": 38,
//                  "y1": 121,
//                  "x2": 290,
//                  "y2": 400,
//                  "specInfo": {
//                    "category": "动物",
//                    "name": "猫",
//                    "id": 548,
//                    "url": "http://image.uniskare.xyz/image/object/动物/猫.png",
//                    "wordType": "宾语"
//                  }
//                }
//              ]
//            }
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
        isShowCameraView = false
    }
    
}


struct ImagePicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    @ObservedObject var imageObjectDetector: ImageObjectDetector
    @Binding var isShown: Bool
    @Binding var isShowCameraView: Bool
    var sourceType: UIImagePickerController.SourceType = .camera
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePickerCoordinator(imageObjectDetector: _imageObjectDetector, isShown: $isShown, isShowCameraView: $isShowCameraView)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
        
    }
    
}
