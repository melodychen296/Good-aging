# 老好生活 Good Aging

> **「科技的本質應該是帶有溫度的，發達的技術不該把人推得更遠，而是要用來縮短人們之間的距離、傳遞安心與關懷。」**  
> 
> *"The essence of technology lies in its warmth; advanced technology should never push people apart, but rather shorten the distance between us and deliver peace of mind and care."*

---

## 專案簡介 / Project Overview

**老好生活 Good Aging** 是「行動載具應用程式設計入門」課程中我的人機協作專案。因應獨居長者日益增加的社會趨勢，我運用高齡友善（Accessibility）的設計思維，將日常健康提醒、圖解衛教資訊、一鍵緊急求助與敬老福利查詢，整合為一款極簡且直覺的 iOS 輔助工具。

**Good Aging** is a human-AI collaborative project developed for the mobile application design course. Addressing the growing trend of seniors living alone, it leverages age-friendly accessibility principles to integrate daily health reminders, illustrated health education, one-tap emergency requests, and senior welfare inquiries into an intuitive, minimalistic iOS assistant.

---

## 應用程式流程與模組 / App Flow & Features

1. **生活提醒 (Daily Reminders)**：追蹤每日飲水量（250cc 快速累加）、降血壓藥服藥打勾、「722 原則」血壓紀錄提醒以及回診提醒。  
   *(Tracks daily water intake with 250cc increments, logs medication completion, prompts "7-2-2" blood pressure checks, and provides clinic follow-up reminders.)*
2. **老好知識 (Health Education)**：將年長者常需要的知識（如防詐騙、浴室防跌、量測血壓與預防肌少症等）轉化成清晰的流程圖卡教學，點入後提供更詳細的說明手冊，藉此培養老年人獨自居住所需的必備能力。  
   *(Converts essential knowledge—such as anti-fraud, bathroom fall prevention, blood pressure measurement, and sarcopenia prevention—into clear visual flowcharts. Tapping in opens detailed instruction manuals to foster independent living capabilities for seniors.)*
3. **安心通 (Emergency & Contacts)**：置頂顯眼標示目前所在地址（便於緊急報路），搭配 5 秒緩衝倒數的 SOS 求助鈕與家人/里長/119 快捷撥號。  
   *(Prominently displays current home address for emergency location reporting, paired with a 5-second countdown buffer SOS button and quick-dial keys.)*
4. **福利通 (Senior Welfare)**：整合敬老愛心卡點數、長照 2.0 專線 (1966) 與社區關懷據點活動整理。  
   *(Consolidates Senior Card points, direct dialing to the Long-Term Care 1966 hotline, and organized local community care center activities.)*
5. **個人資料 (Profile & Setup)**：備忘基本資料與常備用藥資訊，可依個人需求隨時進行更正與修訂。  
   *(Stores personal details and standing medication records, allowing updates and corrections as needed.)*

---

## AI 協同開發亮點 / AI-Assisted Development Highlights

本專案運用 **Antigravity** 作為 AI Copilot，與 **Xcode** 進行高效的人機協作開發：  
*This project utilized **Antigravity** as an AI Copilot alongside **Xcode** for efficient human-AI collaborative development:*

- 先透過 Antigravity 梳理高齡友善 UX 需求（大字級、大打擊面積、高對比色），自動生成 SwiftUI 模組程式碼與 `@AppStorage` 資料持久化架構。  
  *(Used Antigravity to structure senior-friendly UX requirements, auto-generating SwiftUI modules and `@AppStorage` data persistence code.)*
- 在 Xcode 建置遇到跨平台不相容時，借助 AI 診斷並加上 `#if os(iOS)` 條件編譯修飾符，快速排除 Build Failed 錯誤並在模擬器成功執行。  
  *(When facing cross-platform build errors in Xcode, leveraged AI to diagnose and wrap code with `#if os(iOS)` conditional compilation modifiers for smooth execution on the simulator.)*
