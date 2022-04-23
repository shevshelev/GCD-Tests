//
//  ImageViewController.swift
//  GCD Tests
//
//  Created by Shevshelev Lev on 23.04.2022.
//

import UIKit

class ImageViewController: UIViewController {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .large
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var loadButton: UIButton = {
        getButton(with: "Load image")
    }()
    
    private lazy var blurButton: UIButton = {
       getButton(with: "Load and blur image")
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
    }
    
    override func viewWillLayoutSubviews() {

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5),
            
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 20),
            activityIndicator.heightAnchor.constraint(equalToConstant: 20),
            
            loadButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50),
            loadButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            loadButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            loadButton.heightAnchor.constraint(equalToConstant: 34),
            
            blurButton.topAnchor.constraint(equalTo: loadButton.bottomAnchor, constant: 10),
            blurButton.leadingAnchor.constraint(equalTo: loadButton.leadingAnchor),
            blurButton.trailingAnchor.constraint(equalTo: loadButton.trailingAnchor),
            blurButton.heightAnchor.constraint(equalTo: loadButton.heightAnchor)
        ])
    }
    
    private func setupSubviews() {
        let subviews = [imageView, activityIndicator, loadButton, blurButton]
        subviews.forEach { view.addSubview($0)}
        loadButton.addTarget(self, action: #selector(loadButtonPressed), for: .touchUpInside)
        blurButton.addTarget(self, action: #selector(blurButtonPressed), for: .touchUpInside)
    }
    
    private func getButton(with title: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }
    
    @objc private func loadButtonPressed() {
        imageView.image = nil
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .utility).async {
            guard let imageData = NetworkManager.shared.fetchImageData(from: "https://funart.pro/uploads/posts/2021-03/1617054484_41-p-oboi-priroda-4k-44.jpg") else { return }
            DispatchQueue.main.async {[unowned self] in
                self.activityIndicator.stopAnimating()
                self.imageView.image = UIImage(data: imageData)
            }
        }
    }
    
    @objc private func blurButtonPressed() {
        imageView.image = nil
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .utility).async {
            guard let imageData = NetworkManager.shared.fetchImageData(from: "https://funart.pro/uploads/posts/2021-03/1617054458_19-p-oboi-priroda-4k-19.jpg") else { return }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.imageView.image = UIImage(data: imageData)
            }
            let filter = CIFilter(name: "CIGaussianBlur")
            let image = CIImage(data: imageData)
            filter?.setValue(image, forKey: kCIInputImageKey)
            filter?.setValue(30, forKey: kCIInputRadiusKey)
            
            let cropFilter = CIFilter(name: "CICrop")
            cropFilter?.setValue(filter?.outputImage, forKey: kCIInputImageKey)
            cropFilter?.setValue(CIVector(cgRect: image?.extent ?? CGRect()), forKey: "inputRectangle")
            
            guard let output = cropFilter?.outputImage else { print("2"); return}
            let context = CIContext(options: nil)
            guard let cgImage = context.createCGImage(output, from: output.extent) else { print("3"); return}
            let bluredImage = UIImage(cgImage: cgImage)
            
            DispatchQueue.main.async {
                self.imageView.image = bluredImage
            }
        }
    }


}

