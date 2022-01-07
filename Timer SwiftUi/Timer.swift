//
//  TimerView.swift
//  Timer SwiftUi
//
//  Created by Булат Сагдиев on 11.12.2021.
//

import SwiftUI
import UserNotifications

struct TimerView: View {
    
    // states for Parallax effect
    @State var angel: CGFloat = 20
    @State var rotateX: CGFloat = 90.0
    @State var rotateY: CGFloat = -45.0
    
    @State var isStart = false
    @State var to: CGFloat = 0
    @State var count = 0
    
//    таймер
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.blue.opacity(0.09).edgesIgnoringSafeArea(.all)
            
            VStack {
                ZStack {
    //                Настройка трэк слоя
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 15, lineCap: .round))
                        .frame(width: 200, height: 200)
    //                Настройка слоя индикации
                    Circle()
                        .trim(from: 0, to: self.to)
                        .stroke(Color("pink"), style: StrokeStyle(lineWidth: 15, lineCap: .round))
                        .frame(width: 200, height: 200)
                        .rotationEffect(.init(degrees: -90))
                    
                    VStack {
                        Text("\(self.count)")
                            .font(.system(size: 45))
                            .fontWeight(.light)
                        Text("OF 15")
                            .font(.title3)
                            .padding(5)
                    }
                }
                // Parallax effect
                .rotation3DEffect(.degrees(angel), axis: (x: rotateX, y: rotateY, z: 0.0))
                .animation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true))
                .onAppear {
                    angel = -12
                    rotateX = -45.0
                    rotateY = -90.0
                }
                
                HStack(spacing: 20) {
//                    кнопка Старт
                    Button {
                        if self.count == 15  {
                            self.count = 0
                            withAnimation(.default) {
                                self.to = 0
                            }
                        }
                        self.isStart.toggle()
                    } label: {
                        
                        HStack(spacing: 15) {
                            Image(systemName: self.isStart ? "pause.fill" : "play.fill")
                                .foregroundColor(Color("black"))
                            Text(self.isStart ? "Пауза" : "Старт")
                                .foregroundColor(Color("black"))
                        }
                        .padding(.vertical)
                        .frame(width: (UIScreen.main.bounds.width / 2) - 55)
                        .background(Color("blue"))
                        .clipShape(Capsule())
                        .shadow(radius: 6)
                    }
//                    кнопка restart
                    Button {
//                        сброс
                        self.count = 0
//                        для правильной анимации
                        withAnimation(.default) {
                            self.to = 0
                        }
                    } label: {
                        
                        HStack(spacing: 15) {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(Color("blue"))
                            Text("Сброс")
                                .foregroundColor(Color("blue"))
                        }
                        .padding(.vertical)
                        .frame(width: (UIScreen.main.bounds.width / 2) - 55)
                        .background(
                            Capsule()
                                .stroke(Color("blue"), lineWidth: 2)
                                    )
                        .shadow(radius: 6)
                    }
                }
                .padding(.top, 55)
            }
        }
//        запрос разрешения уведомлений
        .onAppear(perform: {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { _, _ in
            }
        })
//        действия для таймера
        .onReceive(self.timer) { (_) in
            if self.isStart {
                
                if self.count != 15 {
                    self.count += 1
                    print(count)
                    withAnimation(.default) {
                        self.to = CGFloat(self.count) /  15
                    }
                } else {
                    self.isStart.toggle()
                    self.notify()
                }
            }
        }
    }
//    уведомление в бэкграунде
    func notify() {
        let content = UNMutableNotificationContent()
        content.title = "Внимание"
        content.body = "Время вышло!"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger )
        UNUserNotificationCenter.current().add( request, withCompletionHandler: nil)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
            .preferredColorScheme(.dark)
    }
}
