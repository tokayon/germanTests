//
//  Constants.swift
//  GermanTests
//
//  Created by Serge Sinkevych on 6/18/25.
//

import Foundation

struct Constants {
    static let questionsCount: Int = 33
    static let warningRemainingSeconds: Int = 60

    struct Settings {
        static let defaultTranslationLanguage: String = "en"
        static let defaultTestDuration: Int = 30 * 60 // in seconds
    }
    
    struct Links {
        static let sayThanks = "https://www.tokayonapps.com/say-thanks/"
        static let terms = "https://www.tokayonapps.com/quiz-de-terms-page/"
        static let policy = "https://www.tokayonapps.com/quiz-de-policy-page/"
    }
    
    struct Labels {
        static let about = "About"
        static let legal = "Legal"
        static let termsAndConditions = "Terms & Conditions"
        static let privacyPolicy = "Privacy Policy"
        
        static let settings: [String: String] = [
            "en": "Settings",
            "ru": "Настройки",
            "uk": "Налаштування"
        ]
        
        static let translation: [String: String] = [
            "en": "Translation",
            "ru": "Перевод",
            "uk": "Переклад"
        ]
        
        static let prefTranslation: [String: String] = [
            "en": "Preferred Translation",
            "ru": "Язык перевода",
            "uk": "Мова перекладу"
        ]
        
        static let chooseLanguage: [String: String] = [
            "en": "Choose Language",
            "ru": "Выберите язык",
            "uk": "Оберіть мову"
        ]
        
        static let test: [String: String] = [
            "en": "Test",
            "ru": "Тест",
            "uk": "Тест"
        ]
         
        static let testDuration: [String: String] = [
            "en": "Test Duration",
            "ru": "Длительность теста",
            "uk": "Тривалість тесту"
        ]
        
        static let practice: [String: String] = [
            "en": "Practice",
            "ru": "Практика",
            "uk": "Практика"
        ]
        
        static let loadingQuestions: [String: String] = [
            "en": "Loading questions...",
            "ru": "Загрузка вопросов...",
            "uk": "Завантаження запитань..."
        ]
        
        static let stopTestAlert: [String: String] = [
            "en": "Are you sure you want to stop the test?",
            "ru": "Вы уверены, что хотите остановить тест?",
            "uk": "Ви впевнені, що хочете зупинити тест?"
        ]
        
        static let stopTest: [String: String] = [
            "en": "Stop Test",
            "ru": "Остановить тест",
            "uk": "Зупинити тест"
        ]
        
        static let cancel: [String: String] = [
            "en": "Cancel",
            "ru": "Отмена",
            "uk": "Скасувати"
        ]
        
        static let noProgress: [String: String] = [
            "en": "Your progress will not be saved.",
            "ru": "Ваш прогресс не будет сохранен.",
            "uk": "Ваш прогрес не буде збережено."
        ]
        
        static let question: [String: String] = [
            "en": "Question",
            "ru": "Вопрос",
            "uk": "Запитання"
        ]
        
        static let of: [String: String] = [
            "en": "of",
            "ru": "из",
            "uk": "з"
        ]
        
        static let search: [String: String] = [
            "en": "Search",
            "ru": "Поиск",
            "uk": "Пошук"
        ]
        
        static let select: [String: String] = [
            "en": "Select",
            "ru": "Выбрать",
            "uk": "Вибрати"
        ]
        
        static let start: [String: String] = [
            "en": "Start",
            "ru": "Начать",
            "uk": "Почати"
        ]
        
        static let congrats: [String: String] = [
            "en" : "Congrats",
            "ru" : "Поздравляем",
            "uk" : "Поздравляюмо"
        ]
        
        static let failed: [String: String] = [
            "en": "Failed",
            "ru": "Провал",
            "uk": "Провал"
        ]
        
        static let correct: [String: String] = [
            "en": "Correct",
            "ru": "Правильно",
            "uk": "Правильно"
        ]
        
        static let time: [String: String] = [
            "en": "Time",
            "ru": "Время",
            "uk": "Час"
        ]
        
        static let min: [String: String] = [
            "en": "min",
            "ru": "мин",
            "uk": "хв"
        ]
        
        static let seconds: [String: String] = [
            "en": "sec",
            "ru": "сек",
            "uk": "сек"
        ]
        
        static let appVersion: [String: String] = [
            "en": "App Version",
            "ru": "Версия",
            "uk": "Версія"
        ]
        
        static let sounds: [String: String] = [
            "en": "Sound",
            "ru": "Звук",
            "uk": "Звук"
        ]
        
        static let soundEffects: [String: String] = [
            "en": "Sound Effects",
            "ru": "Звуковые эффекты",
            "uk": "Звукові ефекти"
        ]
        
        static let support: [String: String] = [
            "en": "Support",
            "ru": "Поддержка",
            "uk": "Підтримка"
        ]
        
        static let sayThanks: [String: String] = [
            "en": "Say thanks",
            "ru": "Сказать спасибо",
            "uk": "Сказати дякую"
        ]
    }
}
