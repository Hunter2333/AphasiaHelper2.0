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
    @Binding var imageRecogResults: [ImageRecogResult]
    @Binding var isShown: Bool
    @Binding var isShowCameraView: Bool
    @State var componentWords: [Word]
    
    init(image: Binding<UIImage?>, imageRecogResults: Binding<[ImageRecogResult]>, isShown: Binding<Bool>, isShowCameraView: Binding<Bool>, componentWords: State<[Word]>) {
        _image = image
        _imageRecogResults = imageRecogResults
        _isShown = isShown
        _isShowCameraView = isShowCameraView
        _componentWords = componentWords
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // TODO
            image = uiImage
            let imageObjectDetector = ImageObjectDetector(image: image)
            //let imageObjectDetector = ImageObjectDetector(image: UIImage(named: "catdog"))
            if imageObjectDetector.predictObjects.count > 0 {
                image = imageObjectDetector.drawRectanglesOnImage()
                let croppedImages = imageObjectDetector.cropObjectsOnImage()
                for i in 0..<imageObjectDetector.predictObjects.count {
                    // 填充词语的类型
                    var wordType = WordType.Subject
                    switch imageObjectDetector.predictObjects[i].specInfo.wordType {
                    case "主语":
                        wordType = WordType.Subject
                    case "谓语":
                        wordType = WordType.Predicate
                    case "宾语":
                        wordType = WordType.Object
                    default:
                        break
                    }
                    // isSelected: 需要检查是否在当前组成的一句话中
                    var isSelected = false
                    for componentWord in componentWords {
                        if(wordType == componentWord.type && imageObjectDetector.predictObjects[i].specInfo.id == componentWord.DBKey) {
                            isSelected = true
                        }
                    }
                    imageRecogResults.append(ImageRecogResult(img: croppedImages[i], word: Word(DBKey: imageObjectDetector.predictObjects[i].specInfo.id, name: imageObjectDetector.predictObjects[i].specInfo.name, urlToImage: imageObjectDetector.predictObjects[i].specInfo.url, type: wordType, isSelected: isSelected)))
                }
            } else {
                image = uiImage
                imageRecogResults = [ImageRecogResult]()
            }
            isShown = false
            isShowCameraView = true
            // TODO 1
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
        image = nil
        imageRecogResults = [ImageRecogResult]()
        isShown = false
        isShowCameraView = false
    }
    
}


struct ImagePicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    @Binding var image: UIImage?
    @Binding var imageRecogResults: [ImageRecogResult]
    @Binding var isShown: Bool
    @Binding var isShowCameraView: Bool
    @State var componentWords: [Word]
    var sourceType: UIImagePickerController.SourceType = .camera
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePickerCoordinator(image: $image, imageRecogResults: $imageRecogResults, isShown: $isShown, isShowCameraView: $isShowCameraView, componentWords: _componentWords)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
        
    }
    
}
