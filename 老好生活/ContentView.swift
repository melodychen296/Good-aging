import SwiftUI

// MARK: - 主應用程式入口
struct ContentView: View {
    // 使用者持久化儲存資訊（初次下載時皆為空白，須由使用者或家屬填寫）
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("userAddress") private var userAddress: String = ""
    @AppStorage("contactName") private var contactName: String = ""
    @AppStorage("contactPhone") private var contactPhone: String = ""
    @AppStorage("communityPhone") private var communityPhone: String = ""
    @AppStorage("medicationName") private var medicationName: String = ""
    
    // 介面狀態：0:提醒, 1:知識, 2:安心, 3:福利, 4:個人資料
    @State private var currentTab: Int = 0
    @State private var isExtraLargeText: Bool = false
    
    var body: some View {
        if !hasCompletedOnboarding {
            // 初次下載安裝：引導填寫基本資訊
            OnboardingSetupView(
                userName: $userName,
                userAddress: $userAddress,
                contactName: $contactName,
                contactPhone: $contactPhone,
                communityPhone: $communityPhone,
                medicationName: $medicationName,
                isCompleted: $hasCompletedOnboarding
            )
        } else {
            // 已完成初次設定：進入手機 App 主介面
            VStack(spacing: 0) {
                // 手機頂部問候列
                MobileHeaderView(
                    userName: userName,
                    isExtraLargeText: $isExtraLargeText,
                    onGoProfile: {
                        currentTab = 4 // 切換至個人資料分頁
                    }
                )
                
                // 主內容切換區 (五大功能)
                ZStack {
                    Color(white: 0.96)
                        .ignoresSafeArea()
                    
                    switch currentTab {
                    case 0:
                        RemindersModuleView(
                            isExtraLarge: isExtraLargeText,
                            medicationName: medicationName.isEmpty ? "降血壓藥" : medicationName
                        )
                    case 1:
                        KnowledgeModuleView(isExtraLarge: isExtraLargeText)
                    case 2:
                        SafetyModuleView(
                            isExtraLarge: isExtraLargeText,
                            userAddress: userAddress.isEmpty ? "未設定住址" : userAddress,
                            contactName: contactName.isEmpty ? "緊急聯絡人" : contactName,
                            contactPhone: contactPhone.isEmpty ? "119" : contactPhone,
                            communityPhone: communityPhone.isEmpty ? "1999" : communityPhone
                        )
                    case 3:
                        WelfareModuleView(isExtraLarge: isExtraLargeText)
                    case 4:
                        ProfileModuleView(
                            userName: $userName,
                            userAddress: $userAddress,
                            contactName: $contactName,
                            contactPhone: $contactPhone,
                            communityPhone: $communityPhone,
                            medicationName: $medicationName,
                            isExtraLarge: isExtraLargeText,
                            onResetOnboarding: {
                                hasCompletedOnboarding = false
                            }
                        )
                    default:
                        RemindersModuleView(
                            isExtraLarge: isExtraLargeText,
                            medicationName: medicationName.isEmpty ? "降血壓藥" : medicationName
                        )
                    }
                }
                
                // 手機底部五大標籤導航列
                MobileTabBar(currentTab: $currentTab, isExtraLarge: isExtraLargeText)
            }
        }
    }
}

// MARK: ==========================================
// MARK: 初次下載使用：填寫長輩個人資訊引導畫面
// MARK: ==========================================
struct OnboardingSetupView: View {
    @Binding var userName: String
    @Binding var userAddress: String
    @Binding var contactName: String
    @Binding var contactPhone: String
    @Binding var communityPhone: String
    @Binding var medicationName: String
    @Binding var isCompleted: Bool
    
    @State private var errorMessage: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 頂部歡迎說明
                    VStack(alignment: .center, spacing: 8) {
                        Text("👵 老好生活")
                            .font(.system(size: 28, weight: .black))
                            .foregroundColor(Color.orange)
                        
                        Text("歡迎使用高齡生活安心助手")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color.black)
                        
                        Text("初次使用，請先填寫基本資訊。\n（若長輩不便操作，可由家人或子女協助填寫）")
                            .font(.system(size: 15))
                            .foregroundColor(Color.gray)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
                    .padding(.bottom, 6)
                    
                    // 表單區域
                    VStack(spacing: 16) {
                        InputFieldCard(
                            label: "1. 請問該如何稱呼您？*",
                            placeholder: "例如：陳奶奶、林阿公",
                            icon: "person.fill",
                            text: $userName
                        )
                        
                        InputFieldCard(
                            label: "2. 自宅居住地址*",
                            placeholder: "例如：台北市大安區信義路三段147巷5號",
                            icon: "location.fill",
                            text: $userAddress,
                            note: "緊急求助通報時，手機螢幕會顯示此地址，方便唸給 119 聽。"
                        )
                        
                        InputFieldCard(
                            label: "3. 最常聯繫的家人稱謂*",
                            placeholder: "例如：大女兒 小玲、兒子 阿明",
                            icon: "heart.fill",
                            text: $contactName
                        )
                        
                        InputFieldCard(
                            label: "4. 家人電話號碼*",
                            placeholder: "例如：0912-345-678",
                            icon: "phone.fill",
                            text: $contactPhone
                        )
                        
                        InputFieldCard(
                            label: "5. 在地里長或社區服務電話 (選填)",
                            placeholder: "例如：02-2700-1234",
                            icon: "building.2.fill",
                            text: $communityPhone
                        )
                        
                        InputFieldCard(
                            label: "6. 每日常備用藥名稱 (選填)",
                            placeholder: "例如：降血壓藥、心臟藥",
                            icon: "pills.fill",
                            text: $medicationName,
                            note: "系統將自動在生活提醒中為您建立每日服藥項目。"
                        )
                    }
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color.red)
                            .padding(.horizontal, 4)
                    }
                    
                    // 完成設定大按鈕
                    Button(action: validateAndSubmit) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))
                            Text("填寫完成，開啟老好生活")
                                .font(.system(size: 19, weight: .bold))
                        }
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.orange)
                        .cornerRadius(16)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 20)
            }
            .background(Color(white: 0.96))
            .navigationTitle("首次使用設定")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func validateAndSubmit() {
        if userName.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "請輸入您的稱謂（如：陳奶奶）"
            return
        }
        if userAddress.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "請輸入居住地址，以確保緊急求助定位準確"
            return
        }
        if contactPhone.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "請輸入緊急聯絡人家人的電話"
            return
        }
        errorMessage = ""
        isCompleted = true
    }
}

// 輸入卡片通用元件
struct InputFieldCard: View {
    let label: String
    let placeholder: String
    let icon: String
    @Binding var text: String
    var note: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundColor(Color.orange)
                    .font(.system(size: 16))
                Text(label)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.black)
            }
            
            TextField(placeholder, text: $text)
                .font(.system(size: 17))
                .padding(14)
                .background(Color(white: 0.98))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            
            if !note.isEmpty {
                Text(note)
                    .font(.system(size: 13))
                    .foregroundColor(Color.gray)
                    .padding(.leading, 2)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
    }
}

// MARK: ==========================================
// MARK: 手機版頂部問候列
// MARK: ==========================================
struct MobileHeaderView: View {
    let userName: String
    @Binding var isExtraLargeText: Bool
    let onGoProfile: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("老好生活")
                    .font(.system(size: isExtraLargeText ? 24 : 20, weight: .black))
                    .foregroundColor(Color.orange)
                Text("\(userName)，早安！")
                    .font(.system(size: isExtraLargeText ? 18 : 15, weight: .bold))
                    .foregroundColor(Color.black.opacity(0.75))
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                // 字體縮放按鈕
                Button(action: {
                    isExtraLargeText.toggle()
                }) {
                    Text(isExtraLargeText ? "標準字" : "特大字")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color.orange)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.orange.opacity(0.12))
                        .cornerRadius(16)
                }
                
                // 點擊頭像快速進入個人資料頁
                Button(action: onGoProfile) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 26))
                        .foregroundColor(Color.orange)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.2)),
            alignment: .bottom
        )
    }
}

// MARK: ==========================================
// MARK: 手機版底部五大標籤導航
// MARK: ==========================================
struct MobileTabBar: View {
    @Binding var currentTab: Int
    let isExtraLarge: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarItemBtn(title: "生活提醒", icon: "alarm.fill", isSelected: currentTab == 0, isExtraLarge: isExtraLarge) {
                currentTab = 0
            }
            TabBarItemBtn(title: "老好知識", icon: "book.fill", isSelected: currentTab == 1, isExtraLarge: isExtraLarge) {
                currentTab = 1
            }
            TabBarItemBtn(title: "安心通", icon: "shield.fill", isSelected: currentTab == 2, isExtraLarge: isExtraLarge) {
                currentTab = 2
            }
            TabBarItemBtn(title: "福利通", icon: "gift.fill", isSelected: currentTab == 3, isExtraLarge: isExtraLarge) {
                currentTab = 3
            }
            TabBarItemBtn(title: "個人資料", icon: "person.crop.circle.fill", isSelected: currentTab == 4, isExtraLarge: isExtraLarge) {
                currentTab = 4
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.2)),
            alignment: .top
        )
    }
}

struct TabBarItemBtn: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let isExtraLarge: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: isExtraLarge ? 24 : 20, weight: .bold))
                Text(title)
                    .font(.system(size: isExtraLarge ? 13 : 11, weight: isSelected ? .bold : .medium))
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(isSelected ? Color.orange : Color.gray)
        }
    }
}

// MARK: ==========================================
// MARK: 模組 1：老好生活提醒 (Reminders)
// MARK: ==========================================
struct RemindersModuleView: View {
    let isExtraLarge: Bool
    let medicationName: String
    
    @State private var medDone: Bool = false
    @State private var waterCups: Int = 4
    @State private var bpDone: Bool = false
    @State private var toastMessage: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 飲水定量記錄大卡片
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("💧 今日喝溫水量：\(waterCups * 250) cc")
                            .font(.system(size: isExtraLarge ? 22 : 18, weight: .bold))
                            .foregroundColor(Color.blue)
                        Spacer()
                        Text("目標 1500 cc")
                            .font(.system(size: 14))
                            .foregroundColor(Color.gray)
                    }
                    
                    // 水杯進度
                    HStack(spacing: 8) {
                        ForEach(1...6, id: \.self) { index in
                            Image(systemName: index <= waterCups ? "cup.and.saucer.fill" : "cup.and.saucer")
                                .font(.system(size: 26))
                                .foregroundColor(index <= waterCups ? Color.blue : Color.gray.opacity(0.3))
                                .frame(maxWidth: .infinity)
                        }
                    }
                    
                    Button(action: {
                        if waterCups < 6 {
                            waterCups += 1
                            toastMessage = "已記錄喝了一杯溫水（+\(250)cc）"
                        } else {
                            toastMessage = "今日 1500cc 飲水目標已全部達成！"
                        }
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("我剛喝了一杯溫水（加 250cc）")
                        }
                        .font(.system(size: isExtraLarge ? 19 : 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(14)
                    }
                }
                .padding(18)
                .background(Color.white)
                .cornerRadius(18)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.blue.opacity(0.2), lineWidth: 1.5)
                )
                
                // 吃藥提醒
                ReminderCheckCardRow(
                    timeString: "早上 08:30",
                    title: "早飯後服藥：\(medicationName)",
                    hint: "飯後搭配半杯溫水服用",
                    isDone: $medDone,
                    isExtraLarge: isExtraLarge
                )
                
                // 血壓提醒
                ReminderCheckCardRow(
                    timeString: "傍晚 17:30",
                    title: "晚間血壓量測（722原則）",
                    hint: "靜坐5分鐘再量，量兩次取平均值",
                    isDone: $bpDone,
                    isExtraLarge: isExtraLarge
                )
                
                // 回診備忘卡
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: "cross.case.fill")
                            .foregroundColor(Color.purple)
                        Text("回診提醒：下週看診")
                            .font(.system(size: isExtraLarge ? 19 : 17, weight: .bold))
                            .foregroundColor(Color.purple)
                    }
                    Text("定期回診拿慢箋，出門請攜帶健保卡。")
                        .font(.system(size: isExtraLarge ? 17 : 15, weight: .medium))
                    Text("診後可將血壓紀錄給醫師參考。")
                        .font(.system(size: 14))
                        .foregroundColor(Color.gray)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(18)
                
                if !toastMessage.isEmpty {
                    Text(toastMessage)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color.green)
                        .padding(10)
                        .background(Color.green.opacity(0.12))
                        .cornerRadius(10)
                }
            }
            .padding(16)
        }
    }
}

struct ReminderCheckCardRow: View {
    let timeString: String
    let title: String
    let hint: String
    @Binding var isDone: Bool
    let isExtraLarge: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(timeString)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color.orange)
                Spacer()
                Text(isDone ? "已完成" : "待處理")
                    .font(.system(size: 13, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(isDone ? Color.green.opacity(0.15) : Color.gray.opacity(0.15))
                    .foregroundColor(isDone ? Color.green : Color.gray)
                    .cornerRadius(8)
            }
            
            Text(title)
                .font(.system(size: isExtraLarge ? 22 : 19, weight: .bold))
                .strikethrough(isDone, color: Color.gray)
                .foregroundColor(isDone ? Color.gray : Color.black)
            
            HStack(spacing: 6) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(Color.orange)
                Text(hint)
                    .font(.system(size: isExtraLarge ? 16 : 14))
                    .foregroundColor(Color.gray)
            }
            
            Button(action: {
                isDone.toggle()
            }) {
                HStack {
                    Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 22, weight: .bold))
                    Text(isDone ? "已完成（點擊重置）" : "我做好了！按此打勾")
                        .font(.system(size: isExtraLarge ? 18 : 16, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isDone ? Color.green.opacity(0.15) : Color.orange)
                .foregroundColor(isDone ? Color.green : Color.white)
                .cornerRadius(12)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(18)
    }
}

// MARK: ==========================================
// MARK: 模組 2：老好知識庫 (包含豐富圖解插圖與深度講解)
// MARK: ==========================================
struct KnowledgeModuleView: View {
    let isExtraLarge: Bool
    @State private var selectedTopic: KnowledgeTopic? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 頂部導引
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(Color.orange)
                        .font(.system(size: 22))
                    Text("老好衛教圖解手冊")
                        .font(.system(size: isExtraLarge ? 22 : 18, weight: .black))
                    Spacer()
                    Text("附步驟插圖")
                        .font(.system(size: 13, weight: .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.12))
                        .foregroundColor(Color.orange)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 4)
                
                // 主題 1：防詐騙
                ArticleCardWithPreview(
                    tag: "🛡️ 防詐騙專題",
                    tagColor: Color.orange,
                    title: "假檢警詐騙！這3句話一出立刻掛電話",
                    summary: "檢察官絕不會打電話叫您轉帳或交出存簿！記住一聽二掛三查證。",
                    illustrationType: .antiFraud,
                    isExtraLarge: isExtraLarge
                ) {
                    selectedTopic = .antiFraud
                }
                
                // 主題 2：居家防跌
                ArticleCardWithPreview(
                    tag: "🚶 居家防跌專題",
                    tagColor: Color.blue,
                    title: "浴室防跌4大防護：洗澡安心不再怕地滑",
                    summary: "浴室是家中最易跌倒之處，掌握止滑墊、安全扶手、洗澡椅與照明。",
                    illustrationType: .bathroomSafety,
                    isExtraLarge: isExtraLarge
                ) {
                    selectedTopic = .fallPrevention
                }
                
                // 主題 3：慢性病量血壓
                ArticleCardWithPreview(
                    tag: "❤️ 慢性病照護",
                    tagColor: Color.red,
                    title: "天天量血壓：輕鬆記住「722 原則」",
                    summary: "血壓不是有量就好！掌握黃金時段，回診時醫師調藥最精準。",
                    illustrationType: .bloodPressure,
                    isExtraLarge: isExtraLarge
                ) {
                    selectedTopic = .bloodPressure
                }
                
                // 主題 4：肌少症坐姿健腿操
                ArticleCardWithPreview(
                    tag: "🦵 腿力防衰老",
                    tagColor: Color.green,
                    title: "預防肌少症：看電視就能做的坐姿健腿操",
                    summary: "雙腳有力走路才穩！每天坐著練抬腿，搭配每餐豆魚蛋肉蛋白質。",
                    illustrationType: .legExercise,
                    isExtraLarge: isExtraLarge
                ) {
                    selectedTopic = .legExercise
                }
            }
            .padding(16)
        }
        .sheet(item: $selectedTopic) { topic in
            KnowledgeDetailSheetView(topic: topic, isExtraLarge: isExtraLarge)
        }
    }
}

// 知識主題枚舉
enum KnowledgeTopic: Identifiable {
    case antiFraud
    case fallPrevention
    case bloodPressure
    case legExercise
    
    var id: Int {
        switch self {
        case .antiFraud: return 1
        case .fallPrevention: return 2
        case .bloodPressure: return 3
        case .legExercise: return 4
        }
    }
}

enum IllustrationType {
    case antiFraud
    case bathroomSafety
    case bloodPressure
    case legExercise
}

// 知識卡片元件（含精緻插圖預覽）
struct ArticleCardWithPreview: View {
    let tag: String
    let tagColor: Color
    let title: String
    let summary: String
    let illustrationType: IllustrationType
    let isExtraLarge: Bool
    let onOpen: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 標籤
            HStack {
                Text(tag)
                    .font(.system(size: 13, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(tagColor.opacity(0.12))
                    .foregroundColor(tagColor)
                    .cornerRadius(8)
                Spacer()
                Text("點擊看圖解 ➔")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color.orange)
            }
            
            // 嵌入對應主題的插圖橫幅
            Group {
                switch illustrationType {
                case .antiFraud:
                    AntiFraudBannerIllustration()
                case .bathroomSafety:
                    BathroomBannerIllustration()
                case .bloodPressure:
                    BloodPressureBannerIllustration()
                case .legExercise:
                    LegExerciseBannerIllustration()
                }
            }
            
            Text(title)
                .font(.system(size: isExtraLarge ? 22 : 18, weight: .bold))
                .foregroundColor(Color.black)
            
            Text(summary)
                .font(.system(size: isExtraLarge ? 17 : 14))
                .foregroundColor(Color.gray)
                .lineLimit(2)
            
            Button(action: onOpen) {
                HStack {
                    Text("詳細衛教解說與口訣")
                        .font(.system(size: isExtraLarge ? 18 : 15, weight: .bold))
                    Spacer()
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.system(size: 20))
                }
                .foregroundColor(Color.orange)
                .padding(.top, 4)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.03), radius: 4, y: 2)
    }
}

// MARK: 知識詳情彈窗 (深入講解與完整圖解)
struct KnowledgeDetailSheetView: View {
    let topic: KnowledgeTopic
    let isExtraLarge: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    switch topic {
                    case .antiFraud:
                        AntiFraudDetailContent(isExtraLarge: isExtraLarge)
                    case .fallPrevention:
                        FallPreventionDetailContent(isExtraLarge: isExtraLarge)
                    case .bloodPressure:
                        BloodPressureDetailContent(isExtraLarge: isExtraLarge)
                    case .legExercise:
                        LegExerciseDetailContent(isExtraLarge: isExtraLarge)
                    }
                }
                .padding(20)
            }
            .background(Color(white: 0.97))
            .navigationTitle("老好健康小百科")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("關閉") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.orange)
                }
            }
        }
    }
}

// MARK: ==========================================
// MARK: 4 大主題原生插圖與詳細解說組件
// MARK: ==========================================

// --- 主題 1：防詐騙插圖與解說 ---
struct AntiFraudBannerIllustration: View {
    var body: some View {
        HStack(spacing: 8) {
            VStack(spacing: 4) {
                Text("① 聽")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color.orange)
                Image(systemName: "phone.bubble.left.fill")
                    .font(.system(size: 22))
                    .foregroundColor(Color.orange)
                Text("可疑來電")
                    .font(.system(size: 11))
                    .foregroundColor(Color.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.orange.opacity(0.08))
            .cornerRadius(12)
            
            Image(systemName: "arrow.right")
                .foregroundColor(Color.gray.opacity(0.5))
            
            VStack(spacing: 4) {
                Text("② 掛")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color.red)
                Image(systemName: "phone.down.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(Color.red)
                Text("立刻掛斷")
                    .font(.system(size: 11))
                    .foregroundColor(Color.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.red.opacity(0.08))
            .cornerRadius(12)
            
            Image(systemName: "arrow.right")
                .foregroundColor(Color.gray.opacity(0.5))
            
            VStack(spacing: 4) {
                Text("③ 查")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color.blue)
                Image(systemName: "shield.lefthalf.filled")
                    .font(.system(size: 22))
                    .foregroundColor(Color.blue)
                Text("打 165 查證")
                    .font(.system(size: 11))
                    .foregroundColor(Color.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.blue.opacity(0.08))
            .cornerRadius(12)
        }
    }
}

struct AntiFraudDetailContent: View {
    let isExtraLarge: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("假檢警詐騙！這3句話一出立刻掛電話")
                .font(.system(size: isExtraLarge ? 26 : 22, weight: .black))
                .foregroundColor(Color.black)
            
            AntiFraudBannerIllustration()
                .padding(.vertical, 6)
            
            // 騙子 3 大話術警示
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(Color.red)
                    Text("聽見以下這三句話，百分之百是騙局：")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color.red)
                }
                
                FraudQuoteRow(text: "「你的健保卡/身分證被盜用，涉及洗錢大案！」")
                FraudQuoteRow(text: "「這件案子偵查不公開，千萬不能跟家人或子女講！」")
                FraudQuoteRow(text: "「法院要監管你的銀行帳戶，待會派專員去家裡收存摺與現金！」")
            }
            .padding(14)
            .background(Color.red.opacity(0.08))
            .cornerRadius(14)
            
            // 深入詳細說明
            VStack(alignment: .leading, spacing: 12) {
                Text("🔍 為什麼這絕對是假的？")
                    .font(.system(size: isExtraLarge ? 20 : 18, weight: .bold))
                
                Text("1. 警察與檢察官【絕對不會】在電話中做筆錄。\n2. 檢察官【絕對不會】要求監管人民的存款，更不會派人到家裡拿存簿與提款卡密碼。\n3. 對方只要交代「不能告訴家人」，就是為了切斷長輩與外界的求助管道！")
                    .font(.system(size: isExtraLarge ? 18 : 16))
                    .lineSpacing(6)
                    .foregroundColor(Color.black.opacity(0.8))
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            
            // 應對守則
            VStack(alignment: .leading, spacing: 8) {
                Text("✅ 長輩遇事防身法：")
                    .font(.system(size: isExtraLarge ? 20 : 18, weight: .bold))
                    .foregroundColor(Color.orange)
                Text("遇到電話讓您心慌時，不要猶豫，【直接把電話掛掉】！接著打開老好生活的安心通，打電話給孩子或里長伯問清楚，心情就能放輕鬆。")
                    .font(.system(size: isExtraLarge ? 18 : 16))
                    .lineSpacing(6)
            }
            .padding(16)
            .background(Color.orange.opacity(0.08))
            .cornerRadius(16)
        }
    }
}

struct FraudQuoteRow: View {
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            Text("✖")
                .foregroundColor(Color.red)
                .font(.system(size: 14, weight: .bold))
            Text(text)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color.black.opacity(0.85))
        }
    }
}

// --- 主題 2：浴室防跌插圖與解說 ---
struct BathroomBannerIllustration: View {
    var body: some View {
        HStack(spacing: 8) {
            BathroomFeatureItem(icon: "square.grid.3x3.fill", title: "吸盤止滑墊", sub: "地面防滑", color: Color.blue)
            BathroomFeatureItem(icon: "figure.seated.side", title: "防滑洗澡椅", sub: "坐著洗不暈", color: Color.green)
            BathroomFeatureItem(icon: "hand.raised.fill", title: "安全扶手", sub: "起身借力", color: Color.purple)
            BathroomFeatureItem(icon: "lightbulb.fill", title: "走廊夜燈", sub: "夜間不摸黑", color: Color.orange)
        }
    }
}

struct BathroomFeatureItem: View {
    let icon: String
    let title: String
    let sub: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            Text(title)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color.black)
            Text(sub)
                .font(.system(size: 10))
                .foregroundColor(Color.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(color.opacity(0.08))
        .cornerRadius(12)
    }
}

struct FallPreventionDetailContent: View {
    let isExtraLarge: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("浴室防跌4大防護：洗澡安心不再怕地滑")
                .font(.system(size: isExtraLarge ? 26 : 22, weight: .black))
            
            BathroomBannerIllustration()
                .padding(.vertical, 4)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("🛁 浴室安心改造 4 大重點：")
                    .font(.system(size: isExtraLarge ? 20 : 18, weight: .bold))
                    .foregroundColor(Color.blue)
                
                StepExplainRow(step: "1", title: "鋪設大面積吸盤止滑墊", desc: "挑選底部帶有密集吸盤的橡膠防滑踏墊，出入浴室穿著粗糙紋理的防滑室內拖鞋。洗完澡順手用刮水器把積水刮乾。")
                StepExplainRow(step: "2", title: "安裝牢固不鏽鋼扶手", desc: "馬桶旁與淋浴區安裝水平或 L 型安全扶手。千千萬萬不要抓扯毛巾架起身，毛巾架承受不住長輩體重，極易脫落摔傷！")
                StepExplainRow(step: "3", title: "使用有靠背的洗澡椅", desc: "長輩彎腰洗腳、洗頭時最容易失去平衡。坐在一張穩固、四腳帶橡膠防滑套的洗澡椅上淋浴，舒服又安全。")
                StepExplainRow(step: "4", title: "夜間常亮走廊小夜燈", desc: "晚上起身上廁所，千萬不要摸黑走路！走廊與浴室插座插上低瓦數 LED 感應小夜燈，看清每一步。")
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            
            // 起床慢三步
            VStack(alignment: .leading, spacing: 8) {
                Text("🚶 起床防跌「慢三步口訣」：")
                    .font(.system(size: isExtraLarge ? 20 : 18, weight: .bold))
                    .foregroundColor(Color.orange)
                Text("• 第一步：醒來先在床上平躺 30 秒，伸展一下四肢。\n• 第二步：坐起在床緣，雙腳垂下靜止 30 秒，避免姿勢性低血壓頭暈。\n• 第三步：雙腳著地穿好防滑鞋，站穩 30 秒後再邁開步伐。")
                    .font(.system(size: isExtraLarge ? 17 : 15))
                    .lineSpacing(6)
            }
            .padding(16)
            .background(Color.orange.opacity(0.08))
            .cornerRadius(16)
        }
    }
}

struct StepExplainRow: View {
    let step: String
    let title: String
    let desc: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text(step)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color.white)
                .frame(width: 24, height: 24)
                .background(Color.blue)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.black)
                Text(desc)
                    .font(.system(size: 14))
                    .foregroundColor(Color.gray)
                    .lineSpacing(4)
            }
        }
        .padding(.vertical, 2)
    }
}

// --- 主題 3：血壓 722 插圖與解說 ---
struct BloodPressureBannerIllustration: View {
    var body: some View {
        HStack(spacing: 12) {
            VStack(spacing: 4) {
                Text("7")
                    .font(.system(size: 26, weight: .black))
                    .foregroundColor(Color.red)
                Text("連續量 7 天")
                    .font(.system(size: 12, weight: .bold))
                Text("每週記錄")
                    .font(.system(size: 10))
                    .foregroundColor(Color.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.red.opacity(0.08))
            .cornerRadius(12)
            
            VStack(spacing: 4) {
                Text("2")
                    .font(.system(size: 26, weight: .black))
                    .foregroundColor(Color.orange)
                Text("早晚各 1 次")
                    .font(.system(size: 12, weight: .bold))
                Text("起床後/睡覺前")
                    .font(.system(size: 10))
                    .foregroundColor(Color.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.orange.opacity(0.08))
            .cornerRadius(12)
            
            VStack(spacing: 4) {
                Text("2")
                    .font(.system(size: 26, weight: .black))
                    .foregroundColor(Color.purple)
                Text("每次量 2 遍")
                    .font(.system(size: 12, weight: .bold))
                Text("間隔1分取平均")
                    .font(.system(size: 10))
                    .foregroundColor(Color.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.purple.opacity(0.08))
            .cornerRadius(12)
        }
    }
}

struct BloodPressureDetailContent: View {
    let isExtraLarge: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("天天量血壓：輕鬆記住「722 原則」")
                .font(.system(size: isExtraLarge ? 26 : 22, weight: .black))
            
            BloodPressureBannerIllustration()
                .padding(.vertical, 4)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("💡 為什麼在醫院量的往往不準？")
                    .font(.system(size: isExtraLarge ? 20 : 18, weight: .bold))
                    .foregroundColor(Color.red)
                Text("許多長輩到了醫院穿梭候診容易緊張，測出的血壓往往飆高，這在醫學上叫做「白袍高血壓」。\n因此，在自己熟悉的家中量測、記錄一週早晚平均值，醫師參考這個數值調整用藥才是最準確、最安全的！")
                    .font(.system(size: isExtraLarge ? 17 : 15))
                    .lineSpacing(6)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("🪑 量血壓正確坐姿 3 步驟：")
                    .font(.system(size: isExtraLarge ? 20 : 18, weight: .bold))
                
                HStack(alignment: .top, spacing: 8) {
                    Text("✓").foregroundColor(Color.green).font(.system(size: 16, weight: .bold))
                    Text("靜坐休息 5 分鐘：測量前不要講話、不要走動或憋尿。")
                        .font(.system(size: 15))
                }
                HStack(alignment: .top, spacing: 8) {
                    Text("✓").foregroundColor(Color.green).font(.system(size: 16, weight: .bold))
                    Text("壓脈帶與心臟同高：手臂平放在桌面上，位置與心臟齊平。")
                        .font(.system(size: 15))
                }
                HStack(alignment: .top, spacing: 8) {
                    Text("✓").foregroundColor(Color.green).font(.system(size: 16, weight: .bold))
                    Text("雙腳平踩地面：背靠椅背，不要翹二郎腿。")
                        .font(.system(size: 15))
                }
            }
            .padding(16)
            .background(Color.red.opacity(0.06))
            .cornerRadius(16)
        }
    }
}

// --- 主題 4：健腿操與肌少症插圖與解說 ---
struct LegExerciseBannerIllustration: View {
    var body: some View {
        HStack(spacing: 8) {
            VStack(spacing: 4) {
                Image(systemName: "chair.lounge.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color.green)
                Text("1. 坐正靠背")
                    .font(.system(size: 11, weight: .bold))
                Text("腰部挺直")
                    .font(.system(size: 10))
                    .foregroundColor(Color.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(Color.green.opacity(0.08))
            .cornerRadius(12)
            
            Image(systemName: "arrow.right")
                .foregroundColor(Color.gray.opacity(0.5))
            
            VStack(spacing: 4) {
                Image(systemName: "figure.walk")
                    .font(.system(size: 20))
                    .foregroundColor(Color.green)
                Text("2. 單腿抬平")
                    .font(.system(size: 11, weight: .bold))
                Text("腳尖往上勾")
                    .font(.system(size: 10))
                    .foregroundColor(Color.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(Color.green.opacity(0.08))
            .cornerRadius(12)
            
            Image(systemName: "arrow.right")
                .foregroundColor(Color.gray.opacity(0.5))
            
            VStack(spacing: 4) {
                Image(systemName: "timer")
                    .font(.system(size: 20))
                    .foregroundColor(Color.green)
                Text("3. 停留 5 秒")
                    .font(.system(size: 11, weight: .bold))
                Text("左右各10次")
                    .font(.system(size: 10))
                    .foregroundColor(Color.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(Color.green.opacity(0.08))
            .cornerRadius(12)
        }
    }
}

struct LegExerciseDetailContent: View {
    let isExtraLarge: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("預防肌少症：看電視就能做的坐姿健腿操")
                .font(.system(size: isExtraLarge ? 26 : 22, weight: .black))
            
            LegExerciseBannerIllustration()
                .padding(.vertical, 4)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("🦵 為什麼雙腿會無力？")
                    .font(.system(size: isExtraLarge ? 20 : 18, weight: .bold))
                    .foregroundColor(Color.green)
                Text("人體肌肉量在 40 歲後每十年減少 8%，70 歲後更以兩倍速流失！如果長輩開始覺得起身費力、走兩步就想坐下，這就是肌肉流失的信號。\n好消息是：肌肉隨時練都有效，坐在椅子上就能練大腿股四頭肌！")
                    .font(.system(size: isExtraLarge ? 17 : 15))
                    .lineSpacing(6)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("🍳 每餐一掌心優質蛋白質：")
                    .font(.system(size: isExtraLarge ? 20 : 18, weight: .bold))
                    .foregroundColor(Color.orange)
                Text("光運動還不夠，長輩每餐一定要補充充足蛋白質，肌肉才長得回來：\n• 早餐：無糖豆漿一杯 + 水煮蛋一顆\n• 午餐：掌心大小的清蒸魚肉或雞肉\n• 晚餐：嫩豆腐、毛豆或瘦肉片")
                    .font(.system(size: isExtraLarge ? 17 : 15))
                    .lineSpacing(6)
            }
            .padding(16)
            .background(Color.orange.opacity(0.08))
            .cornerRadius(16)
        }
    }
}

// MARK: ==========================================
// MARK: 模組 3：老好安心通 (Safety)
// MARK: ==========================================
struct SafetyModuleView: View {
    let isExtraLarge: Bool
    let userAddress: String
    let contactName: String
    let contactPhone: String
    let communityPhone: String
    
    @State private var isCountingDown: Bool = false
    @State private var countdownSec: Int = 5
    @State private var timer: Timer? = nil
    @State private var showSosSentAlert: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 自宅地址（即時呈現初次填寫之正確地址）
                VStack(alignment: .leading, spacing: 6) {
                    Text("📍 目前所在位置（自宅）")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color.red)
                    Text(userAddress)
                        .font(.system(size: isExtraLarge ? 23 : 19, weight: .black))
                        .foregroundColor(Color.black)
                    Text("求救或叫救護車時，請直接看螢幕唸出上方地址。")
                        .font(.system(size: 13))
                        .foregroundColor(Color.gray)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(18)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.red.opacity(0.3), lineWidth: 1.5)
                )
                
                // 一鍵求助大按鈕（具備 5 秒防誤觸倒數）
                VStack(spacing: 12) {
                    if isCountingDown {
                        VStack(spacing: 10) {
                            Text("⚠️ 正在啟動求助！")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(Color.red)
                            Text("\(countdownSec) 秒後將自動通知 \(contactName) 與 119")
                                .font(.system(size: 16))
                            Button(action: cancelCountdown) {
                                Text("✖ 按此取消（我不小心按到了）")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.gray)
                                    .cornerRadius(12)
                            }
                        }
                        .padding(16)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(18)
                    } else if showSosSentAlert {
                        VStack(spacing: 6) {
                            Text("✅ 已送出緊急求助！")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color.green)
                            Text("地址與定位已發送給 \(contactName)，請留在原地。")
                                .font(.system(size: 14))
                                .foregroundColor(Color.gray)
                            Button("重置狀態") {
                                showSosSentAlert = false
                            }
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color.blue)
                            .padding(.top, 4)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(18)
                    } else {
                        Button(action: startCountdown) {
                            VStack(spacing: 6) {
                                Image(systemName: "sos.circle.fill")
                                    .font(.system(size: 40))
                                Text("一鍵緊急求助呼叫")
                                    .font(.system(size: isExtraLarge ? 23 : 20, weight: .heavy))
                                Text("點擊後有 5 秒鐘可取消（防止誤觸）")
                                    .font(.system(size: 13))
                                    .opacity(0.9)
                            }
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.red)
                            .cornerRadius(18)
                        }
                    }
                }
                
                // 常用電話卡片
                VStack(spacing: 12) {
                    PhoneRowCard(
                        name: contactName,
                        phone: contactPhone,
                        tag: "主要家屬",
                        color: Color.orange
                    )
                    
                    if !communityPhone.isEmpty {
                        PhoneRowCard(
                            name: "社區/里長服務",
                            phone: communityPhone,
                            tag: "在地據點",
                            color: Color.blue
                        )
                    }
                    
                    PhoneRowCard(
                        name: "119 救護車與消防",
                        phone: "119",
                        tag: "緊急醫療",
                        color: Color.red
                    )
                }
            }
            .padding(16)
        }
    }
    
    private func startCountdown() {
        isCountingDown = true
        countdownSec = 5
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            if countdownSec > 1 {
                countdownSec -= 1
            } else {
                t.invalidate()
                isCountingDown = false
                showSosSentAlert = true
            }
        }
    }
    
    private func cancelCountdown() {
        timer?.invalidate()
        isCountingDown = false
    }
}

struct PhoneRowCard: View {
    let name: String
    let phone: String
    let tag: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(name)
                        .font(.system(size: 18, weight: .bold))
                    Text(tag)
                        .font(.system(size: 12, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(color.opacity(0.12))
                        .foregroundColor(color)
                        .cornerRadius(6)
                }
                Text(phone)
                    .font(.system(size: 14))
                    .foregroundColor(Color.gray)
            }
            Spacer()
            
            Link(destination: URL(string: "tel://\(phone.replacingOccurrences(of: "-", with: ""))") ?? URL(string: "tel://119")!) {
                HStack(spacing: 4) {
                    Image(systemName: "phone.fill")
                    Text("撥打")
                }
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Color.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(color)
                .cornerRadius(12)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
    }
}

// MARK: ==========================================
// MARK: 模組 4：老好福利通 (Welfare)
// MARK: ==========================================
struct WelfareModuleView: View {
    let isExtraLarge: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 敬老卡點數卡
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("敬老愛心卡每月福利")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color.white.opacity(0.9))
                        Spacer()
                        Text("每月自動補滿")
                            .font(.system(size: 13))
                            .foregroundColor(Color.white.opacity(0.8))
                    }
                    Text("480 點")
                        .font(.system(size: 34, weight: .heavy))
                        .foregroundColor(Color.white)
                    Text("可用於搭乘市區公車、雙北捷運、合約敬老計程車折抵。")
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.9))
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue)
                .cornerRadius(18)
                
                // 長照 2.0 專線 1966
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("長照 2.0 專線 1966")
                                .font(.system(size: 19, weight: .bold))
                                .foregroundColor(Color.purple)
                            Text("前 5 分鐘通話免費！專員到府評估")
                                .font(.system(size: 13))
                                .foregroundColor(Color.gray)
                        }
                        Spacer()
                        Link(destination: URL(string: "tel://1966")!) {
                            Text("撥打 1966")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Color.purple)
                                .cornerRadius(10)
                        }
                    }
                    
                    Text("• 居服員到府洗澡、備餐、翻身換藥\n• 輪椅、無障礙扶手改裝補助\n• 醫院就醫復康巴士接送服務")
                        .font(.system(size: 14))
                        .foregroundColor(Color.purple)
                        .lineSpacing(4)
                }
                .padding(16)
                .background(Color.purple.opacity(0.08))
                .cornerRadius(18)
                
                // 社區長青共餐
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("🍲 社區關懷據點與長青共餐")
                            .font(.system(size: 18, weight: .bold))
                        Spacer()
                        Text("每週二、四")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color.orange)
                    }
                    Text("社區活動中心提供熱騰騰營養午餐、銀髮伸展操與免費量血壓，歡迎來和鄰居話家常。")
                        .font(.system(size: 14))
                        .foregroundColor(Color.gray)
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(18)
            }
            .padding(16)
        }
    }
}

// MARK: ==========================================
// MARK: 模組 5：個人資料頁面 (可隨時檢視與修改資訊)
// MARK: ==========================================
struct ProfileModuleView: View {
    @Binding var userName: String
    @Binding var userAddress: String
    @Binding var contactName: String
    @Binding var contactPhone: String
    @Binding var communityPhone: String
    @Binding var medicationName: String
    let isExtraLarge: Bool
    let onResetOnboarding: () -> Void
    
    @State private var isEditing: Bool = false
    @State private var editName: String = ""
    @State private var editAddress: String = ""
    @State private var editContactName: String = ""
    @State private var editContactPhone: String = ""
    @State private var editCommunityPhone: String = ""
    @State private var editMedicationName: String = ""
    @State private var showSavedToast: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 長輩個人名片
                VStack(spacing: 12) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 64))
                        .foregroundColor(Color.orange)
                    
                    Text(userName.isEmpty ? "未設定稱謂" : userName)
                        .font(.system(size: isExtraLarge ? 26 : 22, weight: .black))
                    
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.shield.fill")
                            .foregroundColor(Color.green)
                        Text("老好生活守護中")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color.green)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(Color.white)
                .cornerRadius(20)
                
                if showSavedToast {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("個人資訊已成功儲存！")
                    }
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color.green)
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color.green.opacity(0.12))
                    .cornerRadius(12)
                }
                
                // 資訊卡片區
                if !isEditing {
                    // 檢視模式
                    VStack(spacing: 12) {
                        ProfileInfoRow(icon: "location.fill", label: "自宅地址", value: userAddress.isEmpty ? "未設定" : userAddress, color: Color.red)
                        ProfileInfoRow(icon: "heart.fill", label: "主要家屬", value: contactName.isEmpty ? "未設定" : contactName, color: Color.orange)
                        ProfileInfoRow(icon: "phone.fill", label: "家人電話", value: contactPhone.isEmpty ? "未設定" : contactPhone, color: Color.orange)
                        ProfileInfoRow(icon: "pills.fill", label: "常備用藥", value: medicationName.isEmpty ? "未填寫" : medicationName, color: Color.blue)
                        if !communityPhone.isEmpty {
                            ProfileInfoRow(icon: "building.2.fill", label: "里長電話", value: communityPhone, color: Color.purple)
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(18)
                    
                    // 編輯按鈕
                    Button(action: {
                        editName = userName
                        editAddress = userAddress
                        editContactName = contactName
                        editContactPhone = contactPhone
                        editCommunityPhone = communityPhone
                        editMedicationName = medicationName
                        isEditing = true
                    }) {
                        HStack {
                            Image(systemName: "square.and.pencil")
                            Text("修改個人與家人資訊")
                        }
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.orange)
                        .cornerRadius(14)
                    }
                } else {
                    // 編輯模式
                    VStack(spacing: 14) {
                        Text("✏️ 編輯個人資料")
                            .font(.system(size: 18, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        InputFieldCard(label: "稱謂", placeholder: "例如：陳奶奶", icon: "person.fill", text: $editName)
                        InputFieldCard(label: "自宅住址", placeholder: "例如：台北市大安區...", icon: "location.fill", text: $editAddress)
                        InputFieldCard(label: "家人稱謂", placeholder: "例如：大女兒 小玲", icon: "heart.fill", text: $editContactName)
                        InputFieldCard(label: "家人電話", placeholder: "例如：0912-345-678", icon: "phone.fill", text: $editContactPhone)
                        InputFieldCard(label: "常備藥名", placeholder: "例如：降血壓藥", icon: "pills.fill", text: $editMedicationName)
                        InputFieldCard(label: "里長電話 (選填)", placeholder: "例如：02-2700-1234", icon: "building.2.fill", text: $editCommunityPhone)
                        
                        HStack(spacing: 12) {
                            Button(action: {
                                isEditing = false
                            }) {
                                Text("取消")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color.gray)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color(white: 0.92))
                                    .cornerRadius(12)
                            }
                            
                            Button(action: {
                                userName = editName
                                userAddress = editAddress
                                contactName = editContactName
                                contactPhone = editContactPhone
                                medicationName = editMedicationName
                                communityPhone = editCommunityPhone
                                isEditing = false
                                showSavedToast = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    showSavedToast = false
                                }
                            }) {
                                Text("儲存修改")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.green)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(18)
                }
                
                // 重設設定按鈕（測試用）
                Button(action: {
                    onResetOnboarding()
                }) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("清除資料，重回初次下載引導")
                    }
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color.red)
                    .padding(.vertical, 12)
                }
            }
            .padding(16)
        }
    }
}

struct ProfileInfoRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
                .frame(width: 28)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 13))
                    .foregroundColor(Color.gray)
                Text(value)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color.black)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - 預覽
#Preview {
    ContentView()
}
