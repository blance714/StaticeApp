//
//  MojiResultView.swift
//  Statice
//
//  Created by blance on 2023/3/24.
//

import SwiftUI
import Combine
import AVKit

struct MojiResultView: View {
    let searchResult: MojiSearchResult
    let translationResult: TranslationResult?

    @State var wordResult: MojiFetchWordsResponse.Result.Word? = nil

    var body: some View {
        let title = searchResult.title
        Group {
            if let wordResult = wordResult {
                MojiWordView(
                    searchResult: searchResult,
                    title: title,
                    wordResult: wordResult,
                    translationResult: translationResult)
            } else {
                loadingView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.regularMaterial)
        .navigationTitle("Moji")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var loadingView: some View {
        Group {
            Spacer()
            ProgressView()
                .onAppear {
                    if wordResult == nil {
                        fetchWord()
                    }
                }
            Spacer()
        }
    }

    func fetchWord() {
        var request = URLRequest(
            url: URL(string: "https://api.mojidict.com/parse/functions/nlt-fetchManyLatestWords")!)
        let requestBody = MojiFetchWordsRequest(
            itemsJson: [MojiFetchWordsRequest.ItemJson(objectId: searchResult.id)],
            skipAccessories: false,
            _ApplicationId: "E62VyFVLMiW7kvbtVq3p")
        let jsonData = try? JSONEncoder().encode(requestBody)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("fetch error")
            } else {
                let string = String(data: data!, encoding: .utf8)
                print(string)
                do {
                    let json = try JSONDecoder().decode(MojiFetchWordsResponse.self, from: data!)
                    wordResult = json.result.result[0]
                } catch let error {
                    print("Moji data decode error: \(error)")
                }
            }
        }.resume()
    }
}

class MojiShowNoteViewAction: ObservableObject {
    @Published var isSheetPresented = false
    @Published var map: MojiFieldVariableMap! = nil
    func show(map: MojiFieldVariableMap) {
        self.map = map
        isSheetPresented = true
    }
}

struct MojiWordView: View {
    let searchResult: MojiSearchResult
    let title: String
    let wordResult: MojiFetchWordsResponse.Result.Word
    let translationResult: TranslationResult?
    
    @StateObject var showAction = MojiShowNoteViewAction()
    @State var ttsLoading = false
    @State var ttsCancellable: AnyCancellable?
    @State var audioPlayer: AVAudioPlayer?
    
    @Environment (\.scenePhase) private var scenePhase

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                headerView
                wordDetailsView
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(20)
            .background(.background)
            .cornerRadius(15)
            .padding(8)
        }
        .sheet(isPresented: $showAction.isSheetPresented) {
            AddNoteView(converter: MojiFieldVariableConverter(map: showAction.map), dictionary: .Moji)
                .environment(\.scenePhase, scenePhase)
        }
        .environmentObject(showAction)
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 1) {
            HStack {
                HStack(alignment: .lastTextBaseline, spacing: 20) {
                    Text(wordResult.word.spell ?? title)
                        .font(.title)
                    HStack(alignment: .top, spacing: 0) {
                        Text(wordResult.word.pron ?? "")
                        Text(wordResult.word.accent ?? "")
                            .font(.footnote)
                    }
                }
                Spacer()
                Button {
                    ttsLoading = true
                    ttsCancellable = mojiTtsFetchPublisher(tarId: searchResult.id, tarType: 102)
                        .getData()
                        .sink { completion in
                            ttsLoading = false
                        } receiveValue: { data in
                            audioPlayer = try? AVAudioPlayer(data: data)
                            audioPlayer?.prepareToPlay()
                            audioPlayer?.play()
                        }
                } label: {
                    if ttsLoading {
                        ProgressView()
                    } else {
                        Label("Play", systemImage: "speaker.wave.2")
                            .labelStyle(.iconOnly)
                    }
                }
            }
            Text("\(wordResult.details[0].title)")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }

    private var wordDetailsView: some View {
        ForEach(wordResult.subdetails) { subdetail in
            MojiSubdetailView(
                searchResult: searchResult,
                subdetail: subdetail,
                wordResult: wordResult,
                translationResult: translationResult)
        }
    }
}

struct MojiSubdetailView: View {
    let searchResult: MojiSearchResult
    let subdetail: MojiFetchWordsResponse.Result.Word.Subdetail
    let wordResult: MojiFetchWordsResponse.Result.Word
    let translationResult: TranslationResult?
    
    @EnvironmentObject var showAction: MojiShowNoteViewAction
    @State var ttsCancellable: AnyCancellable?
    
    var body: some View {
        let examples = wordResult.examples
        VStack(alignment: .leading) {
            HStack {
                Text(subdetail.title)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10.0)
            .contextMenu {
                Button {
                    var map = MojiFieldVariableMap(
                        spell: wordResult.word.spell,
                        pron: wordResult.word.pron,
                        accent: wordResult.word.accent,
                        define: subdetail.title,
                        pos: wordResult.details[0].title,
                        sentence: translationResult?.bold,
                        translation: translationResult?.translation,
                        sentenceAudio: translationResult != nil ? "https://dict.youdao.com/dictvoice?audio=\(translationResult!.sentence.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&le=auto&fakepath=foo.mp3" : nil
                    )
                    ttsCancellable = mojiTtsFetchPublisher(tarId: searchResult.id, tarType: 102)
                        .receive(on: RunLoop.main)
                        .sink { _ in
                            showAction.show(map: map)
                        } receiveValue: { map.audio = $0 }
                } label: {
                    Label("Add to Anki", systemImage: "plus")
                }
            }
            .padding(.top, 10)

            ForEach(examples.filter { $0.subdetailsId == subdetail.id }) { example in
                ExampleView(searchResult: searchResult, subdetail: subdetail, wordResult: wordResult, example: example)
                    .padding(.leading, 7)
            }
        }
    }
}

struct ExampleView: View {
    let searchResult: MojiSearchResult
    let subdetail: MojiFetchWordsResponse.Result.Word.Subdetail
    let wordResult: MojiFetchWordsResponse.Result.Word
    let example: MojiFetchWordsResponse.Result.Word.Example
    
    @EnvironmentObject var showAction: MojiShowNoteViewAction
    @State var ttsCancellable: AnyCancellable?
    @State var audioPlayer: AVAudioPlayer?

    var body: some View {
        VStack(alignment: .leading) {
            Text(example.title)
                .fixedSize(horizontal: false, vertical: true)
            Text(example.trans)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(Color(.systemPink))
        }
        .padding(.top, 1.0)
        .padding(.leading, 9)
        .background(
            Rectangle()
                .frame(width: 4)
                .foregroundColor(Color(.systemMint))
            , alignment: .leading
        )
        .contextMenu {
            Button {
                ttsCancellable = mojiTtsFetchPublisher(tarId: example.id, tarType: 103)
                    .getData()
                    .sink { _ in } receiveValue: { data in
                        audioPlayer = try? AVAudioPlayer(data: data)
                        audioPlayer?.prepareToPlay()
                        audioPlayer?.play()
                    }
            } label: {
                Label("Play audio", systemImage: "play.fill")
            }
            Button {
                var map = MojiFieldVariableMap(
                    spell: wordResult.word.spell,
                    pron: wordResult.word.pron,
                    accent: wordResult.word.accent,
                    define: subdetail.title,
                    pos: wordResult.details[0].title,
                    sentence: example.title,
                    translation: example.trans
                )
                
                ttsCancellable = Publishers.Zip(
                    mojiTtsFetchPublisher(tarId: searchResult.id, tarType: 102)
                        .replaceError(with: ""),
                    mojiTtsFetchPublisher(tarId: example.id, tarType: 103)
                        .replaceError(with: "")
                )
                .receive(on: RunLoop.main)
                .sink { _ in
                    showAction.show(map: map)
                } receiveValue: { (audio, sentenceAudio) in
                    map.audio = audio
                    map.sentenceAudio = sentenceAudio
                }
            } label: {
                Label("Add to Anki", systemImage: "plus")
            }
        } preview: {
            VStack(alignment: .leading) {
                Text(example.title)
                Text(example.trans)
                    .foregroundColor(Color(.systemPink))
            }
            .padding()
        }
    }
}

struct MojiResult_Preview: PreviewProvider {
    static var previews: some View {
        MojiResultView(searchResult: MojiSearchResult(id: "198974907", title: "生きる", excerpt: ""), translationResult: translationResultTestData, wordResult: wordResultTestData)
    }
}

struct MojiWord_Preview: PreviewProvider {
    static var previews: some View {
        MojiWordView(searchResult: MojiSearchResult(id: "198974907", title: "生きる", excerpt: ""), title: "生きる", wordResult: wordResultTestData, translationResult: translationResultTestData)
    }
}

//Statice.FetchWordsResponse.Result.Word(word: Statice.FetchWordsResponse.Result.Word.WordInfo(excerpt: "[自动·二类] 活，生存，保持生命。（命を持ち続ける。） 生活，维持生活，以……为生。（生活する。） ", spell: "生きる", accent: "②", pron: "いきる", romaji: "ikiru", createdAt: "2019-05-07T03:50:48.941Z", updatedAt: "2023-03-24T06:17:01.376Z", tags: "N2#N4#考研#高考", outSharedNum: 10, isFree: true, quality: 1000, isChecked: true, reportedAt: Statice.FetchWordsResponse.Result.Word.IsoDate(__type: "Date", iso: "2022-09-04T23:46:48.146Z"), reportedNum: 1, checkedAt: Statice.FetchWordsResponse.Result.Word.IsoDate(__type: "Date", iso: "2022-09-05T02:42:16.198Z"), viewedNum: 14343, objectId: "198974907"), details: [Statice.FetchWordsResponse.Result.Word.Detail(title: "自动#二类", index: 0, createdAt: "2019-05-07T03:50:50.929Z", updatedAt: "2019-10-24T12:55:11.986Z", wordId: "198974907", objectId: "62176")], subdetails: [Statice.FetchWordsResponse.Result.Word.Subdetail(title: "活，生存，保持生命。（命を持ち続ける。）", index: 0, createdAt: "2019-05-07T03:50:52.378Z", updatedAt: "2019-10-24T13:01:22.446Z", wordId: "198974907", detailsId: "62176", id: "86599"), Statice.FetchWordsResponse.Result.Word.Subdetail(title: "生活，维持生活，以……为生。（生活する。）", index: 1, createdAt: "2019-05-07T03:50:54.151Z", updatedAt: "2019-10-24T13:01:33.095Z", wordId: "198974907", detailsId: "62176", id: "86600"), Statice.FetchWordsResponse.Result.Word.Subdetail(title: "为……生活；生活于……之中。（生きがい。）", index: 2, createdAt: "2019-05-07T03:50:52.378Z", updatedAt: "2019-10-24T13:01:22.425Z", wordId: "198974907", detailsId: "62176", id: "86601"), Statice.FetchWordsResponse.Result.Word.Subdetail(title: "有生气，栩栩如生。（生き生きする。）", index: 3, createdAt: "2019-05-07T03:50:53.338Z", updatedAt: "2019-10-24T13:01:31.976Z", wordId: "198974907", detailsId: "62176", id: "86602"), Statice.FetchWordsResponse.Result.Word.Subdetail(title: "『成』，生动。", index: 4, createdAt: "2019-05-07T03:50:53.261Z", updatedAt: "2019-10-24T13:01:31.920Z", wordId: "198974907", detailsId: "62176", id: "86603")], examples: [Statice.FetchWordsResponse.Result.Word.Example(title: "希望に生きる。", index: 0, trans: "生活在希望中。", createdAt: "2019-05-07T03:50:55.140Z", updatedAt: "2023-03-20T13:24:46.435Z", wordId: "198974907", subdetailsId: "86601", isFree: true, quality: 1000, isChecked: false, viewedNum: 9, id: "63915", notationTitle: "<ruby n4><rb>希望</rb><rp>(</rp><rt roma=\"kibou\" hiragana=\"きぼう\" lemma=\"希望\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >に</span><ruby n4><rb>生きる</rb><rp>(</rp><rt roma=\"ikiru\" hiragana=\"いきる\" lemma=\"生きる\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >。</span>"), Statice.FetchWordsResponse.Result.Word.Example(title: "この絵の人物はまるで生きているようだ。", index: 0, trans: "画中人物简直是栩栩如生。", createdAt: "2019-05-07T03:50:55.402Z", updatedAt: "2023-03-07T01:48:02.647Z", wordId: "198974907", subdetailsId: "86603", isFree: true, quality: 1000, isChecked: false, viewedNum: 3, id: "63918", notationTitle: "<span class=\"moji-toolkit-org\" n5>この</span><ruby n5><rb>絵</rb><rp>(</rp><rt roma=\"e\" hiragana=\"え\" lemma=\"絵\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >の</span><ruby n3><rb>人物</rb><rp>(</rp><rt roma=\"zinbutu\" hiragana=\"じんぶつ\" lemma=\"人物\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >は</span><span class=\"moji-toolkit-org\" n4>まるで</span><ruby n4><rb>生き</rb><rp>(</rp><rt roma=\"iki\" hiragana=\"いき\" lemma=\"生きる\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >て</span><span class=\"moji-toolkit-org\" >いる</span><span class=\"moji-toolkit-org\" n4>よう</span><span class=\"moji-toolkit-org\" >だ</span><span class=\"moji-toolkit-org\" >。</span>"), Statice.FetchWordsResponse.Result.Word.Example(title: "ペン1本で生きる。", index: 0, trans: "靠一枝笔维持生活。", createdAt: "2019-05-07T03:50:56.213Z", updatedAt: "2023-03-08T10:39:04.933Z", wordId: "198974907", subdetailsId: "86600", isFree: true, quality: 1000, isChecked: false, viewedNum: 3, id: "63912", notationTitle: "<span class=\"moji-toolkit-org\" >ペン</span><span class=\"moji-toolkit-org\" >1</span><ruby n5><rb>本</rb><rp>(</rp><rt roma=\"pon\" hiragana=\"ぽん\" lemma=\"本\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >で</span><ruby n4><rb>生きる</rb><rp>(</rp><rt roma=\"ikiru\" hiragana=\"いきる\" lemma=\"生きる\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >。</span>"), Statice.FetchWordsResponse.Result.Word.Example(title: "90歳まで生きる。", index: 0, trans: "活到九十岁。", createdAt: "2019-05-07T03:50:56.325Z", updatedAt: "2023-03-16T04:29:00.384Z", wordId: "198974907", subdetailsId: "86599", isFree: true, quality: 1000, isChecked: false, viewedNum: 11, id: "63905", notationTitle: "<span class=\"moji-toolkit-org\" >9</span><span class=\"moji-toolkit-org\" >0</span><ruby n5><rb>歳</rb><rp>(</rp><rt roma=\"sai\" hiragana=\"さい\" lemma=\"歳\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >まで</span><ruby n4><rb>生きる</rb><rp>(</rp><rt roma=\"ikiru\" hiragana=\"いきる\" lemma=\"生きる\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >。</span>"), Statice.FetchWordsResponse.Result.Word.Example(title: "芸道一筋に生きた50年。", index: 1, trans: "献身于艺术的五十年。", createdAt: "2019-05-07T03:50:54.952Z", updatedAt: "2023-03-07T01:47:49.658Z", wordId: "198974907", subdetailsId: "86601", isFree: true, quality: 1000, isChecked: false, viewedNum: 4, id: "63916", notationTitle: "<ruby ><rb>芸道</rb><rp>(</rp><rt roma=\"geidou\" hiragana=\"げいどう\" lemma=\"芸道\"></rt><rp>)</rp></ruby><ruby ><rb>一筋</rb><rp>(</rp><rt roma=\"hitosuzi\" hiragana=\"ひとすじ\" lemma=\"一筋\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >に</span><ruby n4><rb>生き</rb><rp>(</rp><rt roma=\"iki\" hiragana=\"いき\" lemma=\"生きる\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >た</span><span class=\"moji-toolkit-org\" >50</span><ruby n5><rb>年</rb><rp>(</rp><rt roma=\"nen\" hiragana=\"ねん\" lemma=\"年\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >。</span>"), Statice.FetchWordsResponse.Result.Word.Example(title: "生きるための手段。", index: 1, trans: "谋生的手段。", createdAt: "2019-05-07T03:50:55.219Z", updatedAt: "2023-02-13T02:41:19.130Z", wordId: "198974907", subdetailsId: "86600", isFree: true, quality: 1000, isChecked: false, viewedNum: 2, id: "63913", notationTitle: "<ruby n4><rb>生きる</rb><rp>(</rp><rt roma=\"ikiru\" hiragana=\"いきる\" lemma=\"生きる\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >ため</span><span class=\"moji-toolkit-org\" >の</span><ruby n3><rb>手段</rb><rp>(</rp><rt roma=\"syudan\" hiragana=\"しゅだん\" lemma=\"手段\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >。</span>"), Statice.FetchWordsResponse.Result.Word.Example(title: "その色を塗ればずっと絵が生きてくる。", index: 1, trans: "若涂上那种颜色画更生动了。", createdAt: "2019-05-07T03:50:55.530Z", updatedAt: "2023-03-22T12:19:01.053Z", wordId: "198974907", subdetailsId: "86603", isFree: true, quality: 1000, isChecked: false, viewedNum: 4, id: "63919", notationTitle: "<span class=\"moji-toolkit-org\" n5>その</span><ruby n5><rb>色</rb><rp>(</rp><rt roma=\"iro\" hiragana=\"いろ\" lemma=\"色\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >を</span><ruby n4><rb>塗れ</rb><rp>(</rp><rt roma=\"nure\" hiragana=\"ぬれ\" lemma=\"塗る\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >ば</span><span class=\"moji-toolkit-org\" n4>ずっと</span><ruby n5><rb>絵</rb><rp>(</rp><rt roma=\"e\" hiragana=\"え\" lemma=\"絵\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >が</span><ruby n4><rb>生き</rb><rp>(</rp><rt roma=\"iki\" hiragana=\"いき\" lemma=\"生きる\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >て</span><span class=\"moji-toolkit-org\" n2 n5>くる</span><span class=\"moji-toolkit-org\" >。</span>"), Statice.FetchWordsResponse.Result.Word.Example(title: "生きて帰る。", index: 1, trans: "生还。", createdAt: "2019-05-07T03:50:56.029Z", updatedAt: "2023-03-23T07:55:09.572Z", wordId: "198974907", subdetailsId: "86599", isFree: true, quality: 1000, isChecked: false, viewedNum: 10, id: "63906", notationTitle: "<ruby n4><rb>生き</rb><rp>(</rp><rt roma=\"iki\" hiragana=\"いき\" lemma=\"生きる\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >て</span><ruby n2><rb>帰る</rb><rp>(</rp><rt roma=\"kaeru\" hiragana=\"かえる\" lemma=\"返る\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >。</span>"), Statice.FetchWordsResponse.Result.Word.Example(title: "長く幸福に生きる。", index: 2, trans: "幸福地生活下去。", createdAt: "2019-05-07T03:50:55.485Z", updatedAt: "2023-02-24T03:32:14.891Z", wordId: "198974907", subdetailsId: "86600", isFree: true, quality: 1000, isChecked: false, viewedNum: 6, id: "63914", notationTitle: "<ruby n5><rb>長く</rb><rp>(</rp><rt roma=\"nagaku\" hiragana=\"ながく\" lemma=\"長い\"></rt><rp>)</rp></ruby><ruby n3><rb>幸福</rb><rp>(</rp><rt roma=\"kouhuku\" hiragana=\"こうふく\" lemma=\"幸福\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >に</span><ruby n4><rb>生きる</rb><rp>(</rp><rt roma=\"ikiru\" hiragana=\"いきる\" lemma=\"生きる\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >。</span>"), Statice.FetchWordsResponse.Result.Word.Example(title: "彼女は一生を学童の教育に生きてきた。", index: 2, trans: "她为儿童教育献出了一生。", createdAt: "2019-05-07T03:50:55.513Z", updatedAt: "2023-03-20T02:05:20.363Z", wordId: "198974907", subdetailsId: "86601", isFree: true, quality: 1000, isChecked: false, viewedNum: 1, id: "63917", notationTitle: "<ruby n4><rb>彼女</rb><rp>(</rp><rt roma=\"kanozyo\" hiragana=\"かのじょ\" lemma=\"彼女\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >は</span><ruby n4><rb>一生</rb><rp>(</rp><rt roma=\"issyou\" hiragana=\"いっしょう\" lemma=\"一生\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >を</span><ruby ><rb>学童</rb><rp>(</rp><rt roma=\"gakudou\" hiragana=\"がくどう\" lemma=\"学童\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >の</span><ruby n4><rb>教育</rb><rp>(</rp><rt roma=\"kyouiku\" hiragana=\"きょういく\" lemma=\"教育\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >に</span><ruby n4><rb>生き</rb><rp>(</rp><rt roma=\"iki\" hiragana=\"いき\" lemma=\"生きる\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >て</span><span class=\"moji-toolkit-org\" n2 n5>き</span><span class=\"moji-toolkit-org\" >た</span><span class=\"moji-toolkit-org\" >。</span>"), Statice.FetchWordsResponse.Result.Word.Example(title: "パンダは何を食べて生きているのか？", index: 2, trans: "熊猫吃什么活着？", createdAt: "2019-05-07T03:50:56.070Z", updatedAt: "2023-03-08T10:38:02.507Z", wordId: "198974907", subdetailsId: "86599", isFree: true, quality: 1000, isChecked: false, viewedNum: 5, id: "63907", notationTitle: "<span class=\"moji-toolkit-org\" >パンダ</span><span class=\"moji-toolkit-org\" >は</span><ruby n5><rb>何</rb><rp>(</rp><rt roma=\"nan\" hiragana=\"なん\" lemma=\"何\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >を</span><ruby n5><rb>食べ</rb><rp>(</rp><rt roma=\"tabe\" hiragana=\"たべ\" lemma=\"食べる\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >て</span><ruby n4><rb>生き</rb><rp>(</rp><rt roma=\"iki\" hiragana=\"いき\" lemma=\"生きる\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >て</span><span class=\"moji-toolkit-org\" >いる</span><span class=\"moji-toolkit-org\" >の</span><span class=\"moji-toolkit-org\" >か</span><span class=\"moji-toolkit-org\" >？</span>"), Statice.FetchWordsResponse.Result.Word.Example(title: "生きている間にこの仕事を完成したい。", index: 3, trans: "但愿在有生之年完成这项工作。", createdAt: "2019-05-07T03:50:56.308Z", updatedAt: "2023-03-23T00:00:12.095Z", wordId: "198974907", subdetailsId: "86599", isFree: true, quality: 1000, isChecked: false, viewedNum: 5, id: "63908", notationTitle: "<ruby n4><rb>生き</rb><rp>(</rp><rt roma=\"iki\" hiragana=\"いき\" lemma=\"生きる\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >て</span><span class=\"moji-toolkit-org\" >いる</span><ruby n3 n4><rb>間</rb><rp>(</rp><rt roma=\"aida\" hiragana=\"あいだ\" lemma=\"間\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >に</span><span class=\"moji-toolkit-org\" n5>この</span><ruby n5><rb>仕事</rb><rp>(</rp><rt roma=\"sigoto\" hiragana=\"しごと\" lemma=\"仕事\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >を</span><ruby n3><rb>完成</rb><rp>(</rp><rt roma=\"kansei\" hiragana=\"かんせい\" lemma=\"完成\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >し</span><span class=\"moji-toolkit-org\" >たい</span><span class=\"moji-toolkit-org\" >。</span>"), Statice.FetchWordsResponse.Result.Word.Example(title: "彼はもう長く生きられない。", index: 4, trans: "他活不长了。", createdAt: "2019-05-07T03:50:56.005Z", updatedAt: "2023-03-22T09:46:53.066Z", wordId: "198974907", subdetailsId: "86599", isFree: true, quality: 1000, isChecked: false, viewedNum: 7, id: "63909", notationTitle: "<ruby n4 n5><rb>彼</rb><rp>(</rp><rt roma=\"kare\" hiragana=\"かれ\" lemma=\"彼\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >は</span><span class=\"moji-toolkit-org\" n5>もう</span><ruby n5><rb>長く</rb><rp>(</rp><rt roma=\"nagaku\" hiragana=\"ながく\" lemma=\"長い\"></rt><rp>)</rp></ruby><ruby n4><rb>生き</rb><rp>(</rp><rt roma=\"iki\" hiragana=\"いき\" lemma=\"生きる\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >られ</span><span class=\"moji-toolkit-org\" n5>ない</span><span class=\"moji-toolkit-org\" >。</span>"), Statice.FetchWordsResponse.Result.Word.Example(title: "水がなければ1日も生きることはできない。", index: 5, trans: "若没有水一天也活不了。", createdAt: "2019-05-07T03:50:55.996Z", updatedAt: "2023-03-08T09:16:53.598Z", wordId: "198974907", subdetailsId: "86599", isFree: true, quality: 1000, isChecked: false, viewedNum: 3, id: "63910", notationTitle: "<ruby n5><rb>水</rb><rp>(</rp><rt roma=\"mizu\" hiragana=\"みず\" lemma=\"水\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >が</span><span class=\"moji-toolkit-org\" >なけれ</span><span class=\"moji-toolkit-org\" >ば</span><ruby n5><rb>1日</rb><rp>(</rp><rt roma=\"tuitati\" hiragana=\"ついたち\" lemma=\"一日\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >も</span><ruby n4><rb>生きる</rb><rp>(</rp><rt roma=\"ikiru\" hiragana=\"いきる\" lemma=\"生きる\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" n4>こと</span><span class=\"moji-toolkit-org\" >は</span><span class=\"moji-toolkit-org\" n4 n5>でき</span><span class=\"moji-toolkit-org\" n5>ない</span><span class=\"moji-toolkit-org\" >。</span>"), Statice.FetchWordsResponse.Result.Word.Example(title: "いまは生きるか死ぬかのせとぎわだ。", index: 6, trans: "现在是生死关头。", createdAt: "2019-05-07T03:50:55.068Z", updatedAt: "2023-03-13T12:28:08.268Z", wordId: "198974907", subdetailsId: "86599", isFree: true, quality: 1000, isChecked: false, viewedNum: 3, id: "63911", notationTitle: "<span class=\"moji-toolkit-org\" n5>いま</span><span class=\"moji-toolkit-org\" >は</span><ruby n4><rb>生きる</rb><rp>(</rp><rt roma=\"ikiru\" hiragana=\"いきる\" lemma=\"生きる\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >か</span><ruby n5><rb>死ぬ</rb><rp>(</rp><rt roma=\"sinu\" hiragana=\"しぬ\" lemma=\"死ぬ\"></rt><rp>)</rp></ruby><span class=\"moji-toolkit-org\" >か</span><span class=\"moji-toolkit-org\" >の</span><span class=\"moji-toolkit-org\" >せとぎわ</span><span class=\"moji-toolkit-org\" >だ</span><span class=\"moji-toolkit-org\" >。</span>")])
