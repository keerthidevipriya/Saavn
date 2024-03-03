//
//  ViewController.swift
//  Saavn
//
//  Created by Keerthi Devipriya(kdp) on 03/03/24.
//

import UIKit
import SDWebImage
import AVFoundation
import AudioToolbox
import MediaPlayer

class ViewController: UIViewController {
    
    enum Constant {
        static let na = "NA"
        static let imgConstant: CGFloat = 150
        static let marginTop: CGFloat = 200
        static let sideMargin: CGFloat = 16
        static let playIconConstant: CGFloat = 60
    }
    
    var isPlaying: Bool = false
    private var audioPlayer: AVAudioPlayer?
    var player: AVPlayer!
    var viewModel: DetailViewModel!
    var album: Album?
    
    lazy var containerView: UIView = {
        var lbl = UIView()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var albumName: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = .systemFont(ofSize: 16)
        return lbl
    }()
    
    lazy var albumImg: UIImageView = {
        var lbl = UIImageView()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.contentMode = .scaleToFill
        return lbl
    }()
    
    lazy var playBtn: UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        return btn
    }()
    
    static func makeViewController(viewModel: DetailViewModel) -> ViewController {
        let vc = ViewController()
        vc.fetchAlbumsData()
        vc.viewModel = viewModel
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchAlbumsData()
    }
    
    func fetchAlbumsData() {
        ApiIntegration.getAlbum { album in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.album = album
                let albumDomainModel = AlbumDomainModel(model: album)
                self.viewModel = DetailViewModel(albumDomainModel: albumDomainModel)
                self.configure()
                self.playSound()
            }
        }
    }
    
    func configure() {
        setUpData()
        configureViewHierarchy()
        configureViewConstraints()
        configureViewTheme()
    }
    
    func setUpData() {
        albumName.text = album?.album ?? Constant.na
        let url = URL(string: album?.image_url ?? String())
        albumImg.sd_setImage(with: url, placeholderImage: UIImage(named: "AppIcon"))
        let playIcon = UIImage(systemName: "play.fill")
        playBtn.setImage(playIcon, for: .normal)
    }
    
    func configureViewHierarchy() {
        containerView.addSubview(albumImg)
        containerView.addSubview(albumName)
        containerView.addSubview(playBtn)
        view.addSubview(containerView)
    }
    
    func configureViewConstraints() {
        NSLayoutConstraint.activate([
            containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            containerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            albumImg.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            albumImg.widthAnchor.constraint(equalToConstant: Constant.imgConstant),
            albumImg.heightAnchor.constraint(equalToConstant: Constant.imgConstant),
            albumImg.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constant.marginTop),
            
            albumName.topAnchor.constraint(equalTo: albumImg.bottomAnchor, constant: Constant.sideMargin),
            albumName.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            playBtn.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            playBtn.widthAnchor.constraint(equalToConstant: Constant.playIconConstant),
            playBtn.heightAnchor.constraint(equalToConstant: Constant.playIconConstant),
            playBtn.topAnchor.constraint(equalTo: albumName.bottomAnchor, constant: Constant.sideMargin),
        ])
        
    }

    func configureViewTheme() {
        containerView.backgroundColor = .white
        self.view.backgroundColor = .white
    }
}

extension ViewController {
    @objc func playTapped() {
        isPlaying.toggle()
        
        if isPlaying {
            let playIcon = UIImage(systemName: "pause.fill")
            playBtn.setImage(playIcon, for: .normal)
            player.pause()
        } else {
            let playIcon = UIImage(systemName: "play.fill")
            playBtn.setImage(playIcon, for: .normal)
            playSound()
        }
    }
    
    func playSound() {
        guard  let url = URL.init(string: album?.perma_url ?? String()) else
        {
            print("error to get the mp3 file")
            return
        }
        do{
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = AVPlayer(url: url as URL)
            player.rate = 1.0
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension ViewController: AVAudioPlayerDelegate {
    
}

