//
//  ImagePicker.swift
//  AphasiaHelper2.0
//
//  Created by Xiaoqing Sun on 2021/2/6.
//

import Foundation
import SwiftUI

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var image: UIImage?
    @Binding var isShown: Bool
    @Binding var isShowCameraView: Bool
    
    init(image: Binding<UIImage?>, isShown: Binding<Bool>, isShowCameraView: Binding<Bool>) {
        _image = image
        _isShown = isShown
        _isShowCameraView = isShowCameraView
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //image = uiImage
            image = UIImage(named: "catdog")
            isShown = false
            isShowCameraView = true
            let imageObjectDetector = ImageObjectDetector(image: self.image)
            // TODO 1
//            {
//                "isSuccess": true,
//                "rel": [
//                    {
//                        "name": "狗",
//                        "x1": 204,
//                        "y1": 44,
//                        "x2": 450,
//                        "y2": 452
//                    },
//                    {
//                        "name": "猫",
//                        "x1": 38,
//                        "y1": 121,
//                        "x2": 290,
//                        "y2": 400
//                    }
//                ]
//            }
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        image = nil
        isShown = false
        isShowCameraView = false
    }
    
}


struct ImagePicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    @Binding var image: UIImage?
    @Binding var isShown: Bool
    @Binding var isShowCameraView: Bool
    var sourceType: UIImagePickerController.SourceType = .camera
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePickerCoordinator(image: $image, isShown: $isShown, isShowCameraView: $isShowCameraView)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
        
    }
    
}
