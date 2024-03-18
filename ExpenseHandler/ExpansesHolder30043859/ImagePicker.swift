//
//  ImagePicker.swift
//  ExpansesHolder30043859
//
//  Created by Bucur I (FCES) on 01/03/2024.
//

import Foundation
import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {//used to handle the imgaes for the application
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {//controller - uses delegate
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {//update controller

    }

    func makeCoordinator() -> Coordinator {//makes the coorinator
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {//delegate for images
        let parent: ImagePicker

        init(_ parent: ImagePicker) {//constructor
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {//loads image
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}
