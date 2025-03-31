//
//  SceneDelegate.swift
//  AITestApp
//
//  Created by L_0045_r.watanabe on 2025/03/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var splashWindow: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = scene as? UIWindowScene else { return }

        let mainVC = MainViewController()
        let mainWindow = UIWindow(windowScene: windowScene)
        mainWindow.rootViewController = mainVC
        self.window = mainWindow
        mainWindow.makeKeyAndVisible()

        showSplashScreen(over: windowScene)
    }

    private func showSplashScreen(over windowScene: UIWindowScene) {
        splashWindow = UIWindow(windowScene: windowScene)
        splashWindow?.windowLevel = .alert + 1
        splashWindow?.backgroundColor = .white

        let splashVC = SplashViewController()
        splashWindow?.rootViewController = splashVC
        splashWindow?.makeKeyAndVisible()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.splashWindow?.alpha = 0
            }) { [weak self] _ in
                self?.splashWindow?.isHidden = true
                self?.splashWindow = nil
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

