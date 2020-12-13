//
//  SettingViewModel+Backup.swift
//  DaDaIkSeon
//
//  Created by 정재명 on 2020/12/13.
//

import Foundation

// MARK: Backup
extension SettingViewModel {
    func handlerForBackupSetting(_ input: SettingBackup) {
        switch input {
        case .backupToggle:
            if state.backupToggle {
                updateBackupMode(false)
            } else {
                // 백업 비밀번호가 내장되어 있으면 바로 true 요청.
                if nil != state.service.readBackupPassword() {
                    updateBackupMode(true)
                } else {
                    trigger(.settingBackup(.editBackupPasswordMode))
                }
            }
        case .editBackupPasswordMode:
            state.backupPasswordEditMode.toggle()
            state.backupPasswordEditCheckMode = false
            state.editErrorMessage = .none
        case .editBackupPassword(let password):
            if check(password: password) {
                state.service.updateBackupPassword(password)
                state.backupPasswordEditMode = false
                state.backupPasswordEditCheckMode = true
                state.editErrorMessage = .none
            } else {
                state.backupPasswordEditCheckMode = false
                state.editErrorMessage = .stringSize
            }
        case .checkPassword(let last, let check):
            if last == check {
                state.service.updateBackupPassword(last)
                state.backupPasswordEditCheckMode = false
                state.editErrorMessage = .none
                // 토큰 update해줘야 함.
                if backupToggleGoingToOn() {
                    updateBackupMode(true)
                }
            } else {
                state.editErrorMessage = .different
            }
        }
    }
    
    func updateBackupMode(_ mode: Bool) {
        state.service.updateBackupMode(currentUDID, backup: mode) { result in
            switch result {
            case .result:
                DispatchQueue.main.async {
                    self.state.backupToggle = mode
                }
            case .dataParsingError:
                break
            case .messageError:
                break
            case .networkError:
                break
            }
        }
    }
    
    func check(password: String) -> Bool {
        password.count > 5
    }
    
    func backupToggleGoingToOn() -> Bool {
        state.backupToggle == false
    }
    
}
