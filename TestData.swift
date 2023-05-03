//
//  TestData.swift
//  Statice
//
//  Created by blance on 2023/4/1.
//

import Foundation

let ankiSettingsTestData = AnkiSettings(deck: "core", noteType: "Core 2000", noteMapping: [:])

let ankiDataTestData = Statice.AnkiData(decks: [Statice.AnkiData.Deck(name: "core"), Statice.AnkiData.Deck(name: "Physics"), Statice.AnkiData.Deck(name: "カナデ"), Statice.AnkiData.Deck(name: "デフォルト")], notetypes: [Statice.AnkiData.NoteType(name: "Core 2000", kind: "normal", fields: [Statice.AnkiData.NoteType.Field(name: "Optimized-Voc-Index"), Statice.AnkiData.NoteType.Field(name: "Vocabulary-Kanji"), Statice.AnkiData.NoteType.Field(name: "Vocabulary-Furigana"), Statice.AnkiData.NoteType.Field(name: "Vocabulary-Kana"), Statice.AnkiData.NoteType.Field(name: "Vocabulary-English"), Statice.AnkiData.NoteType.Field(name: "Vocabulary-Audio"), Statice.AnkiData.NoteType.Field(name: "Vocabulary-Pos"), Statice.AnkiData.NoteType.Field(name: "Caution"), Statice.AnkiData.NoteType.Field(name: "Expression"), Statice.AnkiData.NoteType.Field(name: "Reading"), Statice.AnkiData.NoteType.Field(name: "Sentence-Kana"), Statice.AnkiData.NoteType.Field(name: "Sentence-English"), Statice.AnkiData.NoteType.Field(name: "Sentence-Clozed"), Statice.AnkiData.NoteType.Field(name: "Sentence-Audio"), Statice.AnkiData.NoteType.Field(name: "Notes"), Statice.AnkiData.NoteType.Field(name: "Core-Index"), Statice.AnkiData.NoteType.Field(name: "Optimized-Sent-Index"), Statice.AnkiData.NoteType.Field(name: "Frequency")]), Statice.AnkiData.NoteType(name: "Physics", kind: "normal", fields: [Statice.AnkiData.NoteType.Field(name: "Front"), Statice.AnkiData.NoteType.Field(name: "Back"), Statice.AnkiData.NoteType.Field(name: "More")]), Statice.AnkiData.NoteType(name: "Saladict Word", kind: "normal", fields: [Statice.AnkiData.NoteType.Field(name: "Date"), Statice.AnkiData.NoteType.Field(name: "Text"), Statice.AnkiData.NoteType.Field(name: "Translation"), Statice.AnkiData.NoteType.Field(name: "Context"), Statice.AnkiData.NoteType.Field(name: "ContextCloze"), Statice.AnkiData.NoteType.Field(name: "Note"), Statice.AnkiData.NoteType.Field(name: "Title"), Statice.AnkiData.NoteType.Field(name: "Url"), Statice.AnkiData.NoteType.Field(name: "Favicon"), Statice.AnkiData.NoteType.Field(name: "Audio")]), Statice.AnkiData.NoteType(name: "单词 RECITE 日语", kind: "normal", fields: [Statice.AnkiData.NoteType.Field(name: "单词"), Statice.AnkiData.NoteType.Field(name: "音标"), Statice.AnkiData.NoteType.Field(name: "释义"), Statice.AnkiData.NoteType.Field(name: "发音"), Statice.AnkiData.NoteType.Field(name: "例句"), Statice.AnkiData.NoteType.Field(name: "例句翻译"), Statice.AnkiData.NoteType.Field(name: "拓展")]), Statice.AnkiData.NoteType(name: "单词 RECITE 日语core", kind: "normal", fields: [Statice.AnkiData.NoteType.Field(name: "单词"), Statice.AnkiData.NoteType.Field(name: "音标"), Statice.AnkiData.NoteType.Field(name: "释义"), Statice.AnkiData.NoteType.Field(name: "发音"), Statice.AnkiData.NoteType.Field(name: "词性"), Statice.AnkiData.NoteType.Field(name: "例句"), Statice.AnkiData.NoteType.Field(name: "例句翻译"), Statice.AnkiData.NoteType.Field(name: "例句发音"), Statice.AnkiData.NoteType.Field(name: "课时"), Statice.AnkiData.NoteType.Field(name: "拓展")]), Statice.AnkiData.NoteType(name: "基本", kind: "normal", fields: [Statice.AnkiData.NoteType.Field(name: "正面"), Statice.AnkiData.NoteType.Field(name: "背面")]), Statice.AnkiData.NoteType(name: "基本型（含翻转的卡片）", kind: "normal", fields: [Statice.AnkiData.NoteType.Field(name: "正面"), Statice.AnkiData.NoteType.Field(name: "背面")]), Statice.AnkiData.NoteType(name: "基本型（输入答案）", kind: "normal", fields: [Statice.AnkiData.NoteType.Field(name: "正面"), Statice.AnkiData.NoteType.Field(name: "背面")]), Statice.AnkiData.NoteType(name: "基本型（随意添加翻转的卡片）", kind: "normal", fields: [Statice.AnkiData.NoteType.Field(name: "正面"), Statice.AnkiData.NoteType.Field(name: "背面"), Statice.AnkiData.NoteType.Field(name: "添加翻转卡片")]), Statice.AnkiData.NoteType(name: "完形填空", kind: "cloze", fields: [Statice.AnkiData.NoteType.Field(name: "文本"), Statice.AnkiData.NoteType.Field(name: "更多")])], profiles: [Statice.AnkiData.Profile(name: "ユーザー 1")])

let wordResultTestData = Statice.MojiFetchWordsResponse.Result.Word(word: Statice.MojiFetchWordsResponse.Result.Word.WordInfo(excerpt: "[自动·二类] 活，生存，保持生命。（命を持ち続ける。） 生活，维持生活，以……为生。（生活する。） ", spell: "生きる", accent: "②", pron: "いきる"), details: [Statice.MojiFetchWordsResponse.Result.Word.Detail(title: "自动#二类")], subdetails: [Statice.MojiFetchWordsResponse.Result.Word.Subdetail(title: "活，生存，保持生命。（命を持ち続ける。）", id: "86599"), Statice.MojiFetchWordsResponse.Result.Word.Subdetail(title: "生活，维持生活，以……为生。（生活する。）", id: "86600"), Statice.MojiFetchWordsResponse.Result.Word.Subdetail(title: "为……生活；生活于……之中。（生きがい。）", id: "86601"), Statice.MojiFetchWordsResponse.Result.Word.Subdetail(title: "有生气，栩栩如生。（生き生きする。）", id: "86602"), Statice.MojiFetchWordsResponse.Result.Word.Subdetail(title: "『成』，生动。", id: "86603")], examples: [Statice.MojiFetchWordsResponse.Result.Word.Example(title: "希望に生きる。", trans: "生活在希望中。", subdetailsId: "86601", id: "63915"), Statice.MojiFetchWordsResponse.Result.Word.Example(title: "この絵の人物はまるで生きているようだ。", trans: "画中人物简直是栩栩如生。", subdetailsId: "86603", id: "63918"), Statice.MojiFetchWordsResponse.Result.Word.Example(title: "ペン1本で生きる。", trans: "靠一枝笔维持生活。", subdetailsId: "86600", id: "63912"), Statice.MojiFetchWordsResponse.Result.Word.Example(title: "90歳まで生きる。", trans: "活到九十岁。", subdetailsId: "86599", id: "63905"), Statice.MojiFetchWordsResponse.Result.Word.Example(title: "芸道一筋に生きた50年。", trans: "献身于艺术的五十年。", subdetailsId: "86601", id: "63916"), Statice.MojiFetchWordsResponse.Result.Word.Example(title: "生きるための手段。", trans: "谋生的手段。", subdetailsId: "86600", id: "63913"), Statice.MojiFetchWordsResponse.Result.Word.Example(title: "その色を塗ればずっと絵が生きてくる。", trans: "若涂上那种颜色画更生动了。", subdetailsId: "86603", id: "63919"), Statice.MojiFetchWordsResponse.Result.Word.Example(title: "生きて帰る。", trans: "生还。", subdetailsId: "86599", id: "63906"), Statice.MojiFetchWordsResponse.Result.Word.Example(title: "長く幸福に生きる。", trans: "幸福地生活下去。", subdetailsId: "86600", id: "63914"), Statice.MojiFetchWordsResponse.Result.Word.Example(title: "彼女は一生を学童の教育に生きてきた。", trans: "她为儿童教育献出了一生。", subdetailsId: "86601", id: "63917"), Statice.MojiFetchWordsResponse.Result.Word.Example(title: "パンダは何を食べて生きているのか？", trans: "熊猫吃什么活着？", subdetailsId: "86599", id: "63907"), Statice.MojiFetchWordsResponse.Result.Word.Example(title: "生きている間にこの仕事を完成したい。", trans: "但愿在有生之年完成这项工作。", subdetailsId: "86599", id: "63908"), Statice.MojiFetchWordsResponse.Result.Word.Example(title: "彼はもう長く生きられない。", trans: "他活不长了。", subdetailsId: "86599", id: "63909"), Statice.MojiFetchWordsResponse.Result.Word.Example(title: "水がなければ1日も生きることはできない。", trans: "若没有水一天也活不了。", subdetailsId: "86599", id: "63910"), Statice.MojiFetchWordsResponse.Result.Word.Example(title: "いまは生きるか死ぬかのせとぎわだ。", trans: "现在是生死关头。", subdetailsId: "86599", id: "63911")])

let mapMojiConverterTestData = MojiFieldVariableMap()

let translationResultTestData = TranslationResult(sentence: "「だって、幸せになってほしいの」", bold: "「だって、<b>幸せ</b>になってほしいの」", translation: "因为，我想得到幸福呀")

let searchResultTestData = [MojiSearchResult(id: "1989106854", title: "明るい | あかるい ◎③", excerpt: "[形] 明亮。（十分な光がある。また、そう感じられる状態である。） 明朗；快活；光明。（隠しごとがな"), Statice.MojiSearchResult(id: "9QEHS3cZEd", title: "明るい | あかるい ③◎", excerpt: "[形容詞] 明亮的，开朗的，光明的")]

let favouriteSitesTestData = [
    FavouriteSite(name: "Pixiv", url: URL(string: "https://www.pixiv.net/")!),
    FavouriteSite(name: "#6 かなまふ年の差パロ", url: URL(string: "https://www.pixiv.net/novel/show.php?id=16542540")!),
]
let favouriteSitesSettingTestData = FavouriteSitesSetting(favouriteSites: favouriteSitesTestData)
let dataModelFavouriteSitesSettingTestData = DataModel<FavouriteSitesSetting>(
    dataFileName: "favouriteSitesSetting",
    data: favouriteSitesSettingTestData)

let urlManagerTestData = URLManager(url: URL(string: "https://chen03.github.io/p/color")!)

let readerDataTestData = ReaderData(article: """
「ねぇ、奏。部活に入ってもいい？」

まふゆがそう言ったのは高校に入学してすぐのこと。まふゆが作ってくれた晩ご飯を食べながら、今日あった出来事を聞いている時だった。まふゆが自分から何かしたいということが珍しくて固まってしまった思い出。
ダメ？と首を傾げるまふゆに、ぶんぶんと首を横に振る。

「ダメじゃないよ。まふゆがしたいことをしていいんだから」
「うん、ありがとう奏」
「ところで何をするの？部活」
「弓道」
「へ？」
「弓道部に入ろうと思う」

まふゆの言葉に目を丸くする。
器用だからなんでもできるだろうなぁって思っていたけれど、想像以上の部活の名前が出て驚いたのだった。







そんなことを思い出したのは、一緒に晩ご飯を食べていたまふゆが放った言葉があの時を思い起こさせたから。

まふゆが作った親子丼をスプーンで掬って口に運んでいると、名前を呼ばれた。

「ん？どうしたの？」
「えっと……ご飯、美味しい？」
「うん、まふゆのご飯はいつも美味しいよ」
「……そう」

まふゆが少し視線を逸らして口を閉ざす。
どうしたのだろう。
まふゆの言葉を待っていると、夜の始まりのような瞳が再びわたしへと戻ってきた。

「奏」
「うん？」
「……今度、弓道の試合があるの。うちの学校で」
「へぇ、そうなんだ」
「うん。それで、その……」
「まふゆ？」
「ねぇ、奏。見に来ない？」

その言葉にスプーンで掬い上げていた鶏肉がご飯の上にポトリと落ちた。
その様子を見てまふゆが少し眉を下げる。

「もしかして都合悪い？」
「え、あ……ううん。違う、そうじゃなくて」
「？」
「行ってもいいんだって思ったら嬉しくて……」

まふゆが部活を始めた頃、わたしは一度部活を見に行ってもいいか聞いたことがある。
その時まふゆが、まだ見せれるほど上手になっていないから、と首を横に振った。
わたしはまふゆが部活をしているところを見たかっただけなのだけど、まふゆが嫌がるなら仕方ないと諦めた。
諦めて一年、まさかまふゆから見に来ないかと言われるなんて思いもしなかった。

「大袈裟だよ」
「そんなことないよ。誘ってくれてありがとう、まふゆ」
「……ん」

話は終わりとばかりにまふゆが親子丼をスプーンで掬って口に運ぶ様子を見て頬が緩む。
高校生になってもっと綺麗になったまふゆ。
中学生の時に比べると自分の意志を言えるようになって、わたしに自分の考えを言ってくれるようになった。

「ふふ、楽しみだな」
「楽しみなのは嬉しいけど、奏……試合はお昼だからね？」
「……うぇ」
「奏？」

にっこりとまふゆが笑顔をわたしに向ける。
作った笑顔に少し頬が引き攣って、なんでもないです……と呟いて黙々と残りの親子丼を口にしたのだった。






試合当日。
太陽の眩しさにクラクラしながらもたどり着いた宮益坂女子学園。
制服を着た女の子達や大人もいるのは、きっと弓道部の試合を見に来ているからだろう。
まふゆに教えられた地図を確認しながら会場へ向かうとたくさんの人集り。

「すごーい！本物だ！」
「綺麗！美人！」
「チアデ辞めた時ショックだったけど今、別のグループで活動してるんだよね！」
「そう！！」
「隣にいる子も美人じゃない？」
「本当……笑顔が素敵」
「好き……」
「話しかけに行かない？」

制服を着た子や私服の子が黄色い声を上げているのを見て首を傾げる。
まふゆ以外にも美人さんはいるんだなぁ、と思いながらまふゆを探す。
人集りは近付きたくない。

「ねぇ、あの人も綺麗じゃない？」
「誰かの保護者？」
「え、でも若くない？誰かの姉妹とか？」
「髪綺麗……」

キョロキョロと辺りを見回していると。

「奏！」

ピクリと反応する。
声のした方に振り向いて、固まった。
まふゆがそこにいた、のだけど。
弓道着姿は新鮮で目を奪われてしまった。

「よかった、ちゃんと来てくれたんだね」
「あ、う、うん……」
「どうしたの？ちょっと顔が赤いけど」
「な、なんでもない！その……」
「うん？」
「弓道着姿も似合うんだね、まふゆ」
「……」

ぱちり、と瞬きを一つしてまふゆは固まる。

「……そういうところ」
「まふゆ？どうかした？」

ポツリとまふゆが何か呟いた気がしたけれど、周りの声が煩くてきちんと聞き取れなかった。だからそう尋ねたけれど、首を横に振られた。
どうやら気のせいだったみたい。
まふゆは、外にいる時の笑顔を再び浮かべて口を開いた。

「今日頑張るから奏、ちゃんと見ててね？」
「もちろんだよ」
「それでね」

まふゆが私に手を伸ばす。
見つめ返すとまふゆは私の髪を少し掬って目を細めた。
周りがなんだか煩いけれどまふゆの声を聞き逃さないように耳を傾ける。

「優勝したらご褒美が欲しいな」
「いいよ」
「ふふ、やった」

笑ってそのままわたしの髪に唇を落とすまふゆに目を見開く。
キャーーーという甲高い声にビクリと肩を跳ねさせて周りを見れば視線がわたし達に集中していた。

「な、何？この人達、まふゆのファン？」
「……さぁ、わかんない」
「そういえばさっきの人集りもすごかったなぁ。綺麗な人がいたらしいけど」
「あぁ、うん。アイドルをしている子がいるの」
「へぇ、そうなんだ」
「奏も会いたい？」
「え？別にいいよ。じゃあ試合頑張ってね」

まふゆの頭を撫でて笑いかければ、もう……子供扱いする、と少し拗ねたような声で言われてしまった。





会場を包み込む緊張感。
さっきまでの喧騒が嘘のように、水を打ったように静かだった。
それぞれの選手が矢を射る姿勢から矢を放ち、その後の姿勢さえも美しく、息を呑んだ。
矢が的に当たった瞬間に、観客たちもようやく息を吐き出すような雰囲気。
そんな中、ようやくまふゆの番がくる。
射位につき足踏みを行う。
そこから胴造り、弓構え、打起し、引分け、会と流れるように行い、あの子の瞳が的に集中する。
あぁ、どうして……。他の選手達の姿だって綺麗に見えた。息を呑むものだった。
なのに、どうしてこんなにも、まふゆの射姿は目を奪われて、呼吸さえもできない。
痛いほどの静寂。
タンッと的に矢が突き刺さる。
残心をしているまふゆの姿を見て、きゅっと胸が締め付けられた。

「……？」

首を傾げる。
どうして胸が痛くなったのだろう。
まふゆの成長を見れて嬉しいのに、寂しい、のかな。やっぱり。
少しだけまふゆを遠くに感じてしまったのかもしれない。
いつか独り立ちしてしまうまふゆ。
その時までは出来れば一緒にいたいな、なんて。
部活仲間のところに戻って小さくガッツポーズをして笑っているまふゆを見てそう思った。



結果として、まふゆは優勝した。
特に驚くこともないけれど、やっぱり優勝してくれたのが嬉しかった。
まふゆの努力が報われている証拠だから。
いつも家のことをしてくれて、勉強もできて、部活も委員会も頑張っている子だ。
だから、まふゆの頑張りが形になってくれるのはとても喜ばしい。
先に帰ろうかなと思っているとまふゆからメッセージが届いていて確認すると一緒に帰ろうという文字。だから校門の前で待っていると返信して、そこで待っているとすみませんと声をかけられた。
振り向けば宮女の制服を着た女の子が数人、わたしの周りを囲うようにいた。
背中に何か背負っているのは、弓道の道具、かな。まふゆも持っているやつだった。

「え、っと……？」
「さっきまふゆと一緒にいた人ですよね！」
「え？……え？」
「まふゆのお姉さんですか？」
「それとも友達？」

その子達の言葉にわたしは言い淀んでしまう。
わたしは、まふゆの姉でも友達でもない。
わたしとまふゆの関係はなんだろう。
家族、と言ってもいいのかな。
まふゆにとって、わたしはちゃんと家族になっているのかな。

「えっと……」
「あ、連絡先交換しませんか？私達とお友達になってください！」
「え、ずるい！わたしも！」
「あ、私も私も！」
「え、え……」

ど、どうしよう。
若い子の話のテンポが早すぎてついていけない。わたしと連絡先を交換しても意味ないだろうに。
どうしよう、と困惑していると。

「奏、おまたせ」
「わっ」

ギュッと後ろから抱きしめられる。
誰かなんて振り向かなくても声でわかる。

「ま、まふゆ……危ないよ」
「ふふ、ごめんね？」
「ねー！まふゆ、今日こそ教えてよ！その人まふゆのなんなの？」
「そうだよ。いつもはぐらかすんだもん」
「中学の時、授業参観に来てた人だよね？」
「お姉さん？」
「友達？」
「うーん、姉でも友達でもないかなぁ」

まふゆの声が弾んでいる。だけどこれは作っている声だとわたしは知っていた。
だから何も言わない。

「恋人って言ったら信じる？」
「「「え！？」」」
「へ！？」

驚いて振り向けばニコニコと笑顔を浮かべているまふゆ。あ、これ……遊ばれてるな。
ジトリ、とまふゆを見ればスッと視線を逸らされた。

「ふふ、なーんてね。冗談だよ。奏はね、私が辛い時に手を差し伸べてくれた大切な人なんだ」
「あ、そっか……まふゆ、ご両親亡くしてるんだもんね」
「ごめんね、無神経だった」
「ううん、気にしないで。でも大切な人だからあまり奏に近付かれるのは困るなぁ」
「あはは、なにそれ。まふゆの独占欲？」
「えー、まふゆにそんなのがあるの？」
「まふゆの新たな一面？またまふゆのファンが騒いじゃうやつだ」
「なぁに、それ。そんなに驚くことじゃないでしょ」

そう言って笑ったまふゆは、さりげなくわたしを女の子達から隠すように前に出た。
彼女たちの視線が少し隠れたことにホッとする。

「それじゃあ、そろそろ帰るね。みんなもゆっくり休んで。さっきも言ったけど明日は部活休みだから」
「はーい」
「りょうかーい」
「じゃあねー。奏さんもさよならー」
「さ、さようなら」

手を振れば、手を振ってもらっちゃった！とキャイキャイ騒ぎながら彼女たちは歩いて行った。

「……帰ろう、奏」
「うん、そうだね」

高校に入って身長が伸び、少しだけ目線の高くなったまふゆを見上げる。
顔は外用に笑顔だけれど声はわたしの知っているいつものまふゆのもので安心する。

「お疲れ様、頑張ったね」
「ん」

そう言って頭を撫でれば、まふゆはそのままされるがままだった。
それからわたしの手を取って、そのまま繋ぐ。

「え、手を繋いで帰るの？」
「ダメ？」
「だ、ダメじゃないけどまふゆは大丈夫？」
「うん、大丈夫」
「そっか」

手を繋いで帰り道を歩く。
久しぶりに手を繋いだような気がするな。改めて思うけれどまふゆの手は昔に比べて少しだけ固くなっている。にぎにぎとしていると苦笑する気配。

「くすぐったいよ」
「ごめん。頑張ってる手だなぁって」
「それを言うなら奏だってペンダコできてるでしょ」
「ペンダコとこのまふゆの頑張ってる手を一緒にするのはいやだなぁ」
「なぁに、それ」

クスクスと笑い合う。
それにしてもさっきの会話。

「お姉さん、かぁ」
「奏はどっちかというと妹って感じに見えるよね」
「うっ……それは身長的な意味で？」
「さぁ、どう思う？」
「うぅ……まふゆおねーちゃんの意地悪」
「っ」

揶揄ってきたまふゆに少しの仕返しとしてそう言えば、まふゆがピタリと固まる。
仕返しは成功かな？
そうしているうちに家に辿り着く。
玄関の鍵を開けて中に入って、ただいまと自然に口にした。
靴を脱いで、まふゆの方へ振り向く。

「今日の晩ご飯どうしようか。外に食べに行く？何か注文する？」
「……」
「あ、あれ？まふゆ？」

もしかして、さっき揶揄ったから怒らせてしまったのだろうか。

「え、えっと？まふゆ？怒ってる？」
「……ねぇ、奏」
「え」

トンッと壁に押しつけられる。
逃げ道はまふゆが両手で塞いでいてなくて、恐る恐る彼女を見上げた。

「ま、まふゆ？どうしたの？」
「私、今日頑張ったよ」
「う、うん。頑張ったね。だから晩ご飯はどこかに……」
「約束、覚えてる？」
「やく、そく……」

言われて思い出す。
優勝したらご褒美が欲しいなというもの。

「あ、そうだったね。何が欲しい？」
「なんでもいいの？」
「うん、わたしがあげられるものなら」
「そう……そっか」

物欲がないまふゆが欲しいものってなんだろう。
わたしの曲作りを手伝ってくれるようになってお古のシンセサイザーを使ってるから新しいのとか。
本だろうか、それとももっと別のものかな。
なんて考えていると。

「じゃあ、もらうね」

その言葉と共にまふゆとの距離がゼロになる。
唇に感じる柔らかさと温もり。
視界がぶれながらもわかる、まふゆの綺麗な顔。
まふゆに、キスを、されている。
そう認識した瞬間、顔に熱が集まりまふゆの肩を押していた。

「っ、な、な……」

なんで、どうして。
そう言いたいのに動揺して言葉がでない。
まふゆはわたしの顔を見て少しムッとした表情になり、今度はわたしの手首を押さえつけてキスをした。

「ん、ぅ」

逃げられない。
まふゆのキスを受け入れながら、どうしてこんなことをしているのかわからなくて頭が混乱する。

「う、ぁ……まふ……っ、ん」

息が苦しくなって、少し顔を背けてもまふゆがすぐに距離を埋める。
苦しくて、クラクラして、何も考えられなくなる。
しばらくしてまふゆが離れ、手首が解放されるとわたしはずるずるとその場に座り込んだ。
息を整えながら、まふゆを見上げる。

「まふ、な……なんで」

まふゆは自分の唇に触れて、それからわたしを見下ろす。

「ご褒美、だよ。奏」
「へ……」

しゃがみ込んで、まふゆがわたしの瞳を見つめる。夜の始まりのような色から逸せない。

「これが私が欲しかったもの。まぁ、実は初めてじゃないんだけどね」
「え！？」

クスクス笑ってまふゆが部屋へと向かう。

「あ、ご飯は私が作るからいいよ。そんな顔の奏……誰にも見せたくないから」

部屋の扉が閉まる音がする。

「え、えぇ……待って、どういうこと……？」

まふゆが欲しかったものがわたしへのキスで。
でもこのキスは初めてじゃない。

「え、いつしたの……？」

呆然と呟く声に応える声はなかった。
""", title: "かなまふ年の差パロ#6", author: "蒼", series: "かなまふ年の差パロ", chapter: "#6")
