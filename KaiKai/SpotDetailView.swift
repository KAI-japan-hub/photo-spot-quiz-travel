import SwiftUI
import MapKit

struct SpotDetailView: View {
    let spotName: String
    @State private var capturedImage: UIImage?
    @State private var showingCamera = false
    @ObservedObject var locationViewModel: LocationViewModel
    
    // スポットの詳細情報を格納する辞書
    private let spotDetails: [String: String] = [
        // 映えスポット・自然美（ポジティブ感情が出やすい）
        "嵐山の竹林の道": "嵐山の竹林は、高々とそびえる竹林が、トンネルのように道を覆い、静かで幻想的な雰囲気を醸し出しています。",
        "東福寺": "東大寺と興福寺になぞらえて「東福寺」と名付けられました。京都五山の第四位の禅寺であり、紅葉の名所としても知られています。入場料金600円です！", // 変更: 東福寺（通天橋） -> 東福寺
        "南禅寺": "1291年に無関普門禅師が亀山法皇の離宮を禅寺として開創しました。境内は史跡に指定されており、国宝の方丈や重要文化財の三門など、歴史的に貴重な建造物が多く、また方丈庭園は国の名勝に指定されています", // 変更: 南禅寺 水路閣 -> 南禅寺
        "哲学の道": "銀閣寺から南禅寺付近まで続く散策路。桜の名所として有名で、哲学者・西田幾多郎が散歩したことにちなんで名付けられました。",
        "京都府立植物園": "季節の花々や広大な温室が楽しめる、歴史ある植物園です。四季折々の自然を満喫できます。",

        // 街歩き・体験型（楽しい・活気・好奇心）
        "錦市場": "「京の台所」とも呼ばれる商店街。京都の伝統的な食材やお土産が揃い、食べ歩きも楽しめます。",
        "祇園白川沿い": "白川の流れに沿って風情ある町並みが広がるエリア。特に桜の時期や夜のライトアップが美しいです。",
        "京都駅": "言わずと知れた京都の玄関口である。", 
        "鴨川": "鴨川と高野川の合流地点に広がる三角形の地形。飛び石があり、市民の憩いの場として親しまれています。", // 変更: 出町柳・鴨川デルタ -> 鴨川

        // 文化・歴史（静けさ・尊厳・知的好奇心）
        "上賀茂神社": "京都最古の神社の一つとして知られ、境内全域が世界遺産「古都京都の文化財」に登録されています。厄除、災難除け、必勝の神として信仰されています",
        "京都御所": "平安時代から明治時代初期まで、天皇が住み、朝廷の事務を執り行った宮殿です。現在の建物は、1855年に再建されたもので、紫宸殿や清涼殿など、平安時代の建築様式を色濃く残しています。",
        "平安神宮と神苑": "平安遷都の立役者である第50代桓武天皇と、孝明天皇を祭神としています。広大な神苑も見どころです。",
        "清水寺": "清水寺は、京都東山にある世界遺産登録寺院で、国宝の本堂や重要文化財の仁王門、三重塔など、見どころが満載です。", // 変更: 清水寺（舞台付近） -> 清水寺
        "伏見稲荷大社": "全国にある稲荷神社の総本宮です。最も有名なのは、商売繁盛や五穀豊穣の神様として信仰されていることと、鮮やかな朱色が連なる千本鳥居です。", 

        // 芸術・体験・個性派（感情の幅が出やすい）
        "京都国際マンガミュージアム": "明治時代の小学校校舎を改修した博物館。約30万点のマンガ資料が収蔵されており、芝生で自由にマンガを読むことができます。",
        "二条城": "徳川家康が築城し、天皇の守護と将軍の宿泊所として使用されました。明治時代には皇室の別邸（二条離宮）となり、現在は世界文化遺産に登録されています。", // 変更: 二条城（二の丸御殿） -> 二条城
        "京都市京セラ美術館": "日本の公立美術館として長い歴史を持つ美術館で、伝統的な日本画から現代アートまで幅広い展示を行っています。",
        "下鴨神社": "鴨川の下流に鎮座する神社です。世界遺産「古都京都の文化財」の一つに登録されています。原生林に囲まれた参道は神秘的な雰囲気です。", // 変更: 下鴨神社 糺の森 -> 下鴨神社
        "嵐電嵐山駅": "嵐電嵐山駅を彩る、京友禅のポールが並ぶ幻想的な空間。夜にはライトアップされ、美しい光の森となります。",
        "京都産業大学":"大学"// 変更: 嵐電・嵐山駅のキモノフォレスト -> 嵐電嵐山駅
    ]
    
    // 写真URLを格納する辞書（実際のアプリでは適切な画像URLまたはアセット名を設定）
    private let spotImages: [String: String] = [
        "清水寺": "kiyomizu", // 変更: 清水寺（舞台付近） -> 清水寺
        "東福寺":"tohukuji", // 変更: 東福寺（通天橋） -> 東福寺
        "京都御所":"kyotogosho",
        "嵐山の竹林の道":"chikurin",
        "錦市場":"nishikiichiba",
        "上賀茂神社":"kamigamo",
        "南禅寺": "nanzenji", // 変更: 南禅寺 水路閣 -> 南禅寺
        "哲学の道": "tetsugaku",
        "京都駅": "kyotostation", // 変更: 京都駅大階段と空中径路 -> 京都駅
        "京都市京セラ美術館": "kyosera",
        "京都産業大学": "kyousan",
        "伏見稲荷大社": "hushimi",
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(spotName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.9) // ← 画面の90%に制限
                    .lineLimit(1)
                    .minimumScaleFactor(0.3) // 自動縮小（かなり強く設定）
                    .padding(.horizontal)
                
                // スポットの画像
                if let imageName = spotImages[spotName] {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .clipped()
                        .cornerRadius(12)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.9) // ← 画面の90%に制限
                        .minimumScaleFactor(0.3) // 自動縮小（かなり強く設定）
                        .padding(.horizontal)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .overlay(
                            Text("画像なし")
                                .foregroundColor(.gray)
                        )
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                
                // スポットの詳細説明
                Text("概要")
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.9) // ← 画面の90%に制限
                    .lineLimit(1)
                    .minimumScaleFactor(0.3) // 自動縮小（かなり強く設定）
                
                Text(spotDetails[spotName] ?? "詳細情報がありません。")
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.9) // ← 画面の90%に制限
                    .minimumScaleFactor(0.3) // 自動縮小（かなり強く設定）
                    .fixedSize(horizontal: false, vertical: true)
                
                Link(destination: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSfstPP6Bl7_4_0B1F4Kn1uY8ytsSglnvud9cIirwcEWc5b6Pw/viewform?usp=dialog")!) {
                    Text("スポット到着時アンケート")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.purple) // 好きな色に変更
                        .cornerRadius(25)
                }
                .padding(.bottom, 20)
                
                Link(destination: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSdeW-LuxO5wUw3OW5a9r2bjlvqcIfnQWBjSL7kPH64KXo0AEg/viewform?usp=dialog")!) {
                    Text("写真スポット発見時のアンケート")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.purple) // 好きな色に変更
                        .cornerRadius(25)
                }
                .padding(.bottom, 20)
                
                Link(destination: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSea8F2rS0lRaUWUsyNiV4z20CQEjF0V5hZ2wCo_fwLeL7zevw/viewform?usp=dialog")!) {
                    Text("写真スポット発見時のアンケート")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.purple) // 好きな色に変更
                        .cornerRadius(25)
                }
                .padding(.bottom, 20)
                
                Text("ヒント")
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.9) // ← 画面の90%に制限
                    .lineLimit(1)
                    .minimumScaleFactor(0.3) // 自動縮小（かなり強く設定）
                
                NavigationLink(destination: HintView(spotName: spotName)) {
                    Text("ヒント1を見る")
                        .foregroundColor(Color.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.cyan, in: RoundedRectangle(cornerRadius: 50))
                }
                .padding(.horizontal)
                
                NavigationLink(destination: Hint2View(spotName: spotName)) {
                    Text("ヒント2を見る")
                        .foregroundColor(Color.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.cyan, in: RoundedRectangle(cornerRadius: 50))
                }
                .padding(.horizontal)
                
                NavigationLink(destination: Hint3View(spotName: spotName)) {
                    Text("ヒント3を見る")
                        .foregroundColor(Color.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.cyan, in: RoundedRectangle(cornerRadius: 50))
                }
                .padding(.horizontal)
                
                NavigationLink(destination: PhotoVerificationView(spotName: spotName, spotId: spotName,locationViewModel: locationViewModel)) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("写真で判定")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.green, in: RoundedRectangle(cornerRadius: 50))
                }
                .padding(.horizontal)
                
                //正解の位置情報を表示
                VStack(spacing: 20) {
                    NavigationLink(destination: SpotAnswer(spotName: spotName)){
                        Text("特定できないため位置情報を確認する")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.yellow, in: RoundedRectangle(cornerRadius: 50))
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("スポット詳細")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CameraWrapperView: View {
    let spotName: String
    @Binding var capturedImage: UIImage?
    @State private var showingCamera = true
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            if showingCamera {
                Camera2View(spotName: spotName, image: $capturedImage, isPresented: $showingCamera)
            } else {
                Text("写真が撮影されました")
                    .font(.title2)
                    .padding()
                
                Button("戻る") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            showingCamera = true
        }
        .onChange(of: showingCamera) { isShowing in
            // ここに showingCamera の変更を監視するロジックを必要に応じて追加
        }
    }
}
