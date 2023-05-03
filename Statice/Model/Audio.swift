//
//  Audio.swift
//  Statice
//
//  Created by blance on 2023/5/1.
//

import AVKit

func playAudio(url: URL){
    do {
        let audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    } catch {
        print("Audio play error: \(error)")
    }
}
