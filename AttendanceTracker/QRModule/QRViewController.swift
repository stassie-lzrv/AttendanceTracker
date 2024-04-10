import Foundation
import UIKit
import AVFoundation


public protocol QRViewInput: AnyObject {
    func showConfirmationSheet(code: String)
    func showSuccessAlert()
    func showFailedAlert()
}

final class QRViewController: UIViewController {
    var output: QRViewOutput?
    var captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEnvironment()
        setupSubviews()
        
        navigationItem.hidesBackButton = true
        if let image = UIImage(systemName: "chevron.backward")?.withTintColor(.black) {
            let sizeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
            let button = UIBarButtonItem(image: image.applyingSymbolConfiguration(sizeConfig), style: .plain, target: self, action: #selector(backButtonTapped))
            self.navigationItem.leftBarButtonItem = button
        }
    }
    
    @objc
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupSubviews() {
        let overlayImage = UIImage(named: "qr_frame")
        let imageView = UIImageView(image: overlayImage)
        imageView.frame = CGRect(x: (view.bounds.width - 200)/2, y: (view.bounds.height - 200)/2, width: 200, height: 200)
        view.layer.addSublayer(imageView.layer)
        title = "Отсканируйте QR-код"
    }
    
    private func setupEnvironment() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(previewLayer)
                
        captureSession.startRunning()
    }

    
}

extension QRViewController: QRViewInput {
    func showConfirmationSheet(code: String) {
        let bottomSheetVC = ConfirmationBottomSheetViewController()
        bottomSheetVC.codeLabel.text = code
        bottomSheetVC.delegate = self
        bottomSheetVC.modalPresentationStyle = .automatic

        self.present(bottomSheetVC, animated: true, completion: nil)
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Посещение отмечено", message: "", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Хорошо", style: .default) { [self] _ in
            if let viewControllers = navigationController?.viewControllers {
                guard viewControllers.count > 2 else { return }
                navigationController?.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
            }
        }
                
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }
    
    func showFailedAlert() {
        let alert = UIAlertController(title: "Посещение не отмечено", message: "Обратитесь к преподавателю", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Хорошо", style: .default) { [self] _ in
            if let viewControllers = navigationController?.viewControllers {
                guard viewControllers.count > 2 else { return }
                navigationController?.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
            }
        }
                
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }
}

extension QRViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            captureSession.stopRunning()
            
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.output?.processQRValue(stringValue)
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.captureSession.startRunning()
            }
        }
}

extension QRViewController: ConfirmationDelegate {
    func didTapDone(inputCode: String) {
        output?.didEnterCode(inputCode: inputCode)
    }
}
