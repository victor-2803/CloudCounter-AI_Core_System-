//
//  ContentView.swift
//  CloudCounter
//
//  Created by Mr.Chanoudom Tann on 17/2/2569 BE.
//

////
//
//  ContentView.swift
//  CloudCounter
//

import SwiftUI
import AVFoundation

struct ContentView: View {

    @StateObject private var model: CounterModel = CounterModel()

    @State private var pulse = false
    @State private var scan = false
    @State private var flash = false
    @State private var showConfetti = false
    @State private var audioPlayer: AVAudioPlayer?

    @State private var autoMode = false
    @State private var autoTimer: Timer?

    let synthesizer = AVSpeechSynthesizer()

    var progress: Double {
        min(Double(model.value) / 50.0, 1.0)
    }

    var intensity: Double {
        min(Double(model.value) / 50.0, 1.2)
    }

    var body: some View {
        ZStack {

            // 🌌 Dynamic Blue Background
            LinearGradient(
                colors: [
                    Color.black,
                    Color(
                        red: 0.0,
                        green: 0.2 + (0.4 * intensity),
                        blue: 0.5 + (0.5 * intensity)
                    )
                ],
                startPoint: scan ? .topLeading : .bottomTrailing,
                endPoint: scan ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.3), value: model.value)

            // ⚡ Flash
            if flash {
                Color.cyan.opacity(0.3)
                    .ignoresSafeArea()
            }

            VStack(spacing: 30) {

                Text("AI CORE SYSTEM")
                    .font(.system(size: 18, weight: .medium, design: .monospaced))
                    .foregroundColor(.cyan)
                    .tracking(4)

                ZStack {

                    Circle()
                        .stroke(Color.cyan.opacity(0.2), lineWidth: 12)
                        .frame(width: 220, height: 220)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Color.cyan, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 220, height: 220)
                        .shadow(color: .cyan, radius: 15)
                        .animation(.easeInOut, value: progress)

                    Text("\(model.value)")
                        .font(.system(size: 80, weight: .bold, design: .rounded))
                        .foregroundColor(.cyan)
                        .shadow(color: .cyan, radius: pulse ? 40 : 15)
                        .scaleEffect(pulse ? 1.08 : 1.0)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: pulse)
                }

                HStack(spacing: 25) {

                    futuristicButton(title: "-1") {
                        model.decrement()
                        playSound("throttle")
                    }

                    futuristicButton(title: "+1") {
                        model.increment()
                        playSound("launch")
                    }
                }

                // 🤖 AUTO MODE BUTTON
                futuristicButton(title: autoMode ? "STOP AUTO" : "AUTO MODE") {
                    toggleAutoMode()
                }

                futuristicButton(title: "RESET") {
                    stopAutoMode()
                    model.reset()
                    playSound("shutdown")
                }
            }
            .padding()

            if showConfetti {
                ConfettiView()
            }
        }
        .onAppear {
            pulse = true
            scan = true
        }
        .onChange(of: model.value) { _, newValue in
            if newValue >= 50 {
                triggerCelebration()
                stopAutoMode()
            }
        }
    }

    // 🚀 AUTO MODE LOGIC
    func toggleAutoMode() {
        autoMode.toggle()

        if autoMode {
            autoTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { _ in
                model.increment()
            }
        } else {
            stopAutoMode()
        }
    }

    func stopAutoMode() {
        autoMode = false
        autoTimer?.invalidate()
        autoTimer = nil
    }

    // 🎉 Celebration
    func triggerCelebration() {
        flash = true
        showConfetti = true
        playSound("launch")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            flash = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showConfetti = false
        }
    }

    // 🔊 Sound Player
    func playSound(_ name: String) {
        if let url = Bundle.main.url(forResource: name, withExtension: "wav") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Sound error")
            }
        }
    }

    // 🔥 Button Style
    func futuristicButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(.headline, design: .monospaced))
                .foregroundColor(.cyan)
                .padding(.horizontal, 28)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.cyan, lineWidth: 1.5)
                        .background(Color.black.opacity(0.6))
                )
                .shadow(color: .cyan, radius: 10)
        }
    }
}

//////////////////////////////////////////////////////////////
// 🎆 Confetti View
//////////////////////////////////////////////////////////////

struct ConfettiView: View {

    @State private var animate = false

    var body: some View {
        GeometryReader { geo in
            ForEach(0..<30) { _ in
                Circle()
                    .fill([Color.cyan, Color.blue, Color.purple, Color.white].randomElement()!)
                    .frame(width: 8, height: 8)
                    .position(
                        x: CGFloat.random(in: 0...geo.size.width),
                        y: animate ? geo.size.height + 50 : -50
                    )
                    .animation(
                        .linear(duration: Double.random(in: 2...4)),
                        value: animate
                    )
            }
        }
        .ignoresSafeArea()
        .onAppear {
            animate = true
        }
    }
}
