import 'models/choice_story.dart';

const List<ChoiceStory> choiceStories = [
  ChoiceStory(
    id: 'kaybolan-kedi-kopuk',
    title: 'Kopuk\'un Izinde',
    description:
        'Ipuclarini hizla birlestir; her secim Mert\'i ya cikmaza ya da Kopuk\'a biraz daha yaklastirsin.',
    coverAsset: 'asset/home page/hayvanlar alemi.jpg',
    scenes: [
      ChoiceStoryScene(
        id: 'start',
        title: 'Acik Pencere',
        text:
            'Mert uyandiginda Kopuk ortada yoktur. Pencere araliktir, perdede pati izleri vardir ve uzakta yagmur bulutlari toplanmaya baslar.',
        imageAsset: 'asset/home page/hayvanlar alemi.jpg',
        options: [
          ChoiceOption(
            text: 'Yagmur izleri silmeden bahcedeki pati izlerini takip et',
            nextSceneId: 'garden_tracks',
          ),
          ChoiceOption(
            text: 'Zamani riske atip once komsulardan bilgi toplamaya calis',
            nextSceneId: 'ask_neighbors',
          ),
        ],
      ),
      ChoiceStoryScene(
        id: 'garden_tracks',
        title: 'Izler Ikiye Ayriliyor',
        text:
            'Pati izleri saksilarin yanindan gecip iki yola ayrilir: biri eski kulubeye, digeri garajin karanlik raflarina gidiyor gibi gorunur. Ruzgar giderek sertlesir.',
        imageAsset: 'asset/home page/maceraya çıkalım.jpg',
        options: [
          ChoiceOption(
            text: 'Dar gecitten kulubeye ilerle, ama iceride ne oldugunu bilme',
            nextSceneId: 'shed_branch',
          ),
          ChoiceOption(
            text: 'Eve donup mama kabi ve fener alarak daha kontrollu davran',
            nextSceneId: 'prepared_search',
          ),
        ],
      ),
      ChoiceStoryScene(
        id: 'ask_neighbors',
        title: 'Komsu Teyze\'nin Ipuclari',
        text:
            'Komsu teyze sabah erkenden park yonunde beyaz bir kedi gordugunu soyler. Ama birazdan sokak temizleme araci gececek, yani Kopuk gurultuden korkup daha da uzaklasabilir.',
        imageAsset: 'asset/home page/hayvanlar alemi.jpg',
        options: [
          ChoiceOption(
            text:
                'Hemen parka kos ve kalabalik buyumeden Kopuk\'u bulmaya calis',
            nextSceneId: 'park_branch',
          ),
          ChoiceOption(
            text: 'Once annene haber verip daha guvenli bir arama plani kur',
            nextSceneId: 'family_branch',
          ),
        ],
      ),
      ChoiceStoryScene(
        id: 'shed_branch',
        title: 'Eski Kulube',
        text:
            'Kulubenin kapisi hafif araliktir. Iceriden metal bir tikirti ve ciplak gozle zor secilen beyaz bir kuyruk gorulur. Mert hizli davranirsa Kopuk daha da urkebilir.',
        imageAsset: 'asset/home page/maceraya çıkalım.jpg',
        options: [
          ChoiceOption(
            text: 'Kapinin arasindan yumusak bir sesle Kopuk\'a seslen',
            nextSceneId: 'shed_call_end',
          ),
          ChoiceOption(
            text: 'Kulubenin arkasini dolanip cikis yolunu kapatmaya calis',
            nextSceneId: 'shed_back_end',
          ),
        ],
      ),
      ChoiceStoryScene(
        id: 'prepared_search',
        title: 'Hazirlik Avantaji',
        text:
            'Mert mama kabini ve feneri alip geri gelir. Artik daha yavas ama daha kontrollu ilerleyebilir. Fener isigi garaj altinda parlayan iki goz secer gibi olur.',
        imageAsset: 'asset/home page/hayvanlar alemi.jpg',
        options: [
          ChoiceOption(
            text: 'Garajin alt raflarini dikkatlice tara',
            nextSceneId: 'garage_search_end',
          ),
          ChoiceOption(
            text: 'Mama kabini saksilarin yanina koyup sessizce bekle',
            nextSceneId: 'food_wait_end',
          ),
        ],
      ),
      ChoiceStoryScene(
        id: 'park_branch',
        title: 'Parkta Baski Artiyor',
        text:
            'Parkta kus seslerine karisan motor gurultusu vardir. Kopuk korkmussa acik alana cikmayabilir. Mert bir yandan acele etmek, bir yandan sakin kalmak zorundadir.',
        imageAsset: 'asset/home page/hayvanlar alemi.jpg',
        options: [
          ChoiceOption(
            text: 'Tahta koprunun altindan gelen hiriltiyi takip et',
            nextSceneId: 'bridge_end',
          ),
          ChoiceOption(
            text: 'Kalabalik dagilana kadar banklarin arkasinda sessizce bekle',
            nextSceneId: 'bench_wait_end',
          ),
        ],
      ),
      ChoiceStoryScene(
        id: 'family_branch',
        title: 'Planli Arama',
        text:
            'Annesi bir battaniye ve tasima cantasi getirir. Birlikte hareket etmek daha guvenlidir ama gec kalirlarsa Kopuk yer degistirebilir.',
        imageAsset: 'asset/home page/maceraya çıkalım.jpg',
        options: [
          ChoiceOption(
            text: 'Park girisinden baslayip izleri sistemli sekilde tara',
            nextSceneId: 'family_gate_end',
          ),
          ChoiceOption(
            text: 'Binanin bodrumuna inip sessiz saklanma yerlerini kontrol et',
            nextSceneId: 'basement_end',
          ),
        ],
      ),
      ChoiceStoryScene(
        id: 'shed_call_end',
        title: 'Sakin Ses Kazandi',
        text:
            'Mert diz cokup yumusak bir sesle Kopuk\'a seslenir. Kopuk once cekinse de tani dik sesi duyunca saklandigi kovadan cikar. Sakin davranmak en hizli cozum olur.',
        imageAsset: 'asset/home page/hayvanlar alemi.jpg',
        isEnding: true,
      ),
      ChoiceStoryScene(
        id: 'shed_back_end',
        title: 'Dar Kosede Karsilasma',
        text:
            'Mert kulubenin arkasini dolaninca kuru yapraklar hirildar ve Kopuk irkilir. Tam kacacakken Mert battaniyeyi yere birakip geri cekilir. Kopuk battaniyenin ustune cikip sakinlesir.',
        imageAsset: 'asset/home page/hayvanlar alemi.jpg',
        isEnding: true,
      ),
      ChoiceStoryScene(
        id: 'garage_search_end',
        title: 'Fenerin Isiginda',
        text:
            'Fener isigi eski boya kutularinin arkasina vurunca Kopuk goz kirpar. Mert mama kabini hafifce sallayinca Kopuk yavas yavas disari cikar. Hazirlik, aramayi guvenli hale getirir.',
        imageAsset: 'asset/home page/maceraya çıkalım.jpg',
        isEnding: true,
      ),
      ChoiceStoryScene(
        id: 'food_wait_end',
        title: 'Sabirli Tuzak',
        text:
            'Mert mama kabini saksilarin yanina birakir ve geri cekilir. Birkac saniye sonra Kopuk kokuyu alip ortaya cikar. Bu kez acele etmek yerine beklemek isi cozer.',
        imageAsset: 'asset/home page/hayvanlar alemi.jpg',
        isEnding: true,
      ),
      ChoiceStoryScene(
        id: 'bridge_end',
        title: 'Koprunun Altinda',
        text:
            'Mert tahta koprunun altina egildiginde yagmurun ilk damlalari dusmeye baslar. Kopuk islak yapraklarin arasina sinmistir. Mert onu korkutmadan kucagina alir ve tam zamaninda eve doner.',
        imageAsset: 'asset/home page/maceraya çıkalım.jpg',
        isEnding: true,
      ),
      ChoiceStoryScene(
        id: 'bench_wait_end',
        title: 'Dogru Ani Beklemek',
        text:
            'Kalabalik biraz dagilinca Kopuk bankin altindan cekingen bir adimla cikar. Mert hizla atilmak yerine elini uzatir. Kopuk kendi istegiyle yanina gelir ve yolculuk guvenle biter.',
        imageAsset: 'asset/home page/hayvanlar alemi.jpg',
        isEnding: true,
      ),
      ChoiceStoryScene(
        id: 'family_gate_end',
        title: 'Birlikte Daha Guclu',
        text:
            'Anne ogul park girisinden baslayip izleri sira sira kontrol eder. Kopuk, cicek tarhinin yaninda sessizce beklerken bulunur. Planli hareket etmek kaygi yerine guven getirir.',
        imageAsset: 'asset/home page/maceraya çıkalım.jpg',
        isEnding: true,
      ),
      ChoiceStoryScene(
        id: 'basement_end',
        title: 'Sessiz Saklanma Yeri',
        text:
            'Bodrumdaki eski kolilerin arasindan hafif bir miyav sesi gelir. Kopuk gurultuden kacip oraya saklanmistir. Annesi tasima cantasini acarken Mert de Kopuk\'u sakinlestirir.',
        imageAsset: 'asset/home page/hayvanlar alemi.jpg',
        isEnding: true,
      ),
    ],
  ),
  ChoiceStory(
    id: 'okul-gezisi-kaybolan-robot',
    title: 'Bilim Muzesinde Sessiz Alarm',
    description:
        'Dakikalar ilerlerken her karar Ela\'yi ya yeni bir ariza noktasina ya da kayip robotun izine gotursun.',
    coverAsset: 'asset/interactive/kayip_tac/bolum_3.png',
    scenes: [
      ChoiceStoryScene(
        id: 'start',
        title: 'Canli Gosteri Once',
        text:
            'Ela sinifiyla bilim muzesindedir. Canli gosteriye dakikalar kala rehber robot ortadan kaybolur. Pil seviyesi dusuk oldugu icin cok uzaga gitmemis olabilir, ama sistem de her an kapanabilir.',
        imageAsset: 'asset/interactive/kayip_tac/bolum_3.png',
        options: [
          ChoiceOption(
            text: 'Servis laboratuvarina gidip son teknik izi kontrol et',
            nextSceneId: 'lab_branch',
          ),
          ChoiceOption(
            text: 'Uzay kubbesinden gelen kesik bip sinyalini takip et',
            nextSceneId: 'space_branch',
          ),
        ],
      ),
      ChoiceStoryScene(
        id: 'lab_branch',
        title: 'Bos Sarj Istasyonu',
        text:
            'Laboratuvarda robotun sarj istasyonu bostur ve sari uyari isigi yanip sonmektedir. Zeminde tekerlek izleri vardir, ama biri bakim koridoruna biri de ekipman odasina yonelir.',
        imageAsset: 'asset/interactive/kayip_tac/bolum_6.png',
        options: [
          ChoiceOption(
            text: 'Bakim koridoruna girip mekanik sesin pesine dus',
            nextSceneId: 'maintenance_branch',
          ),
          ChoiceOption(
            text: 'Gorevliyle birlikte konum tabletini acip veriyle ilerle',
            nextSceneId: 'tablet_branch',
          ),
        ],
      ),
      ChoiceStoryScene(
        id: 'space_branch',
        title: 'Kesik Sinyal',
        text:
            'Uzay kubbesinde isiklar surekli degisiyordur ve kalabalik artmaya baslar. Bip sesi bazen platformun altindan, bazen roket maketinin arkasindan geliyormus gibi duyulur.',
        imageAsset: 'asset/interactive/kayip_tac/bolum_2.png',
        options: [
          ChoiceOption(
            text: 'Karanlik platformun altina inip sesi yakindan dinle',
            nextSceneId: 'dome_branch',
          ),
          ChoiceOption(
            text: 'Ogretmene haber verip alani duzenli sekilde taramayi sec',
            nextSceneId: 'teacher_branch',
          ),
        ],
      ),
      ChoiceStoryScene(
        id: 'maintenance_branch',
        title: 'Bakim Koridoru',
        text:
            'Koridor dardir, fan sesi yankilanir ve yerde acik bir alet kutusu vardir. Ela yanlis yone giderse zaman kaybedecektir; dogru yone giderse robot kapanmadan once bulunabilir.',
        imageAsset: 'asset/interactive/kayip_tac/bolum_6 engel_interaktif.png',
        options: [
          ChoiceOption(
            text: 'Havalandirma odasindan gelen titresimi kontrol et',
            nextSceneId: 'vent_end',
          ),
          ChoiceOption(
            text: 'Kutularin arkasini el feneriyle sessizce tara',
            nextSceneId: 'crates_end',
          ),
        ],
      ),
      ChoiceStoryScene(
        id: 'tablet_branch',
        title: 'Veriyle Iz Surmek',
        text:
            'Gorevlinin tabletinde son konum sinyali zayif zayif yanip soner. Pil cok dusuktur. Bir karar verilmelidir: robotun sarj arayacagini varsaymak mi, yoksa kalabalik alarmi buyumeden sessiz arama yapmak mi?',
        imageAsset: 'asset/interactive/kayip_tac/bolum_3.png',
        options: [
          ChoiceOption(
            text: 'En yakin yedek sarj noktasina kosup robotu orada karsila',
            nextSceneId: 'charging_end',
          ),
          ChoiceOption(
            text: 'Sessiz arama baslatip ziyaretcileri panikletmeden ilerle',
            nextSceneId: 'silent_search_end',
          ),
        ],
      ),
      ChoiceStoryScene(
        id: 'dome_branch',
        title: 'Isiklar Altinda',
        text:
            'Ela platformun altina indiginde yansiyan gezegen isiklari her seyi oldugundan farkli gosterir. Bip sesi ritimli gelir; robot ya projeksiyon perdesine takilmistir ya da roket maketinin arkasina sikismistir.',
        imageAsset: 'asset/interactive/kayip_tac/bolum_2.png',
        options: [
          ChoiceOption(
            text: 'Gorevliden isigi kisip sinyali daha net duymayi iste',
            nextSceneId: 'light_dim_end',
          ),
          ChoiceOption(
            text: 'Bip ritmini sayip sesin geldigi noktayi hesapla',
            nextSceneId: 'rhythm_end',
          ),
        ],
      ),
      ChoiceStoryScene(
        id: 'teacher_branch',
        title: 'Ekiple Arama',
        text:
            'Ogretmen ogrencileri guvenli bir hatta toplar. Bu, Ela\'ya daha sakin dusunme sansi verir; fakat gosteri saati de yaklasmaktadir. Arama iki mantikli noktaya daralir.',
        imageAsset: 'asset/interactive/kayip_tac/bolum_1.png',
        options: [
          ChoiceOption(
            text: 'Posterlerin arkasindaki teknik bolmeye bak',
            nextSceneId: 'poster_end',
          ),
          ChoiceOption(
            text: 'Yerdeki mini tekerlek izlerini takip et',
            nextSceneId: 'rover_end',
          ),
        ],
      ),
      ChoiceStoryScene(
        id: 'vent_end',
        title: 'Fan Sesi Ardinda',
        text:
            'Ela havalandirma odasina vardiginda robotun dusuk pille fan sicakligina yaklasip kendi kendine durdugunu gorur. Zamaninda bulunmasa sistem tamamen kapanacakti.',
        imageAsset: 'asset/interactive/kayip_tac/bolum_6.png',
        isEnding: true,
      ),
      ChoiceStoryScene(
        id: 'crates_end',
        title: 'Kutularin Golgesinde',
        text:
            'El feneri, ekipman kutularinin arasinda iki kucuk mavi goz yakalar. Robot bir kabloya dolanip kalmistir. Ela gorevliye haber verir ve robot dikkatlice kurtarilir.',
        imageAsset: 'asset/interactive/kayip_tac/bolum_6 engel_interaktif.png',
        isEnding: true,
      ),
      ChoiceStoryScene(
        id: 'charging_end',
        title: 'Pil Mantigi',
        text:
            'Ela robotun en yakin yedek sarj noktasina yonelecegini tahmin eder ve hakli cikar. Robot istasyonun onunde gucu tukenmek uzereyken bulunur. Hizli analiz gosteri gununu kurtarir.',
        imageAsset: 'asset/interactive/kayip_tac/bolum_3.png',
        isEnding: true,
      ),
      ChoiceStoryScene(
        id: 'silent_search_end',
        title: 'Panik Olmadan Cozum',
        text:
            'Sessiz arama sayesinde ziyaretciler etkilenmez. Gorevliler kapilari kontrol ederken Ela da sinyalin sabitlendigi noktayi bulur. Robot, perde arkasinda sessiz moda gecmistir.',
        imageAsset: 'asset/interactive/kayip_tac/bolum_1.png',
        isEnding: true,
      ),
      ChoiceStoryScene(
        id: 'light_dim_end',
        title: 'Isiklar Kisilinca',
        text:
            'Ortam isigi azalinca metal yuzeydeki yansima kaybolur ve robotun silueti netlesir. Robot, projeksiyon perdesinin altina sikismistir. Dogru yardim istemek zamani geri kazandirir.',
        imageAsset: 'asset/interactive/kayip_tac/bolum_2.png',
        isEnding: true,
      ),
      ChoiceStoryScene(
        id: 'rhythm_end',
        title: 'Biplerin Hesabi',
        text:
            'Ela bip ritmini sayip sesin yankilanma yonunu hesaplar. Robotun roket maketinin arkasinda kaldigini anlar. Dikkatli dinlemek, en kalabalik alanda bile dogru sonuca goturur.',
        imageAsset: 'asset/interactive/kayip_tac/bolum_2.png',
        isEnding: true,
      ),
      ChoiceStoryScene(
        id: 'poster_end',
        title: 'Teknik Bolmede Iz',
        text:
            'Posterlerin arkasindaki teknik boslukta robotun tekerlek izi ve dusen bir sensor kapagi bulunur. Biraz ileride robot, dar alanda sikisip kalmis halde bekliyordur.',
        imageAsset: 'asset/interactive/kayip_tac/bolum_1.png',
        isEnding: true,
      ),
      ChoiceStoryScene(
        id: 'rover_end',
        title: 'Izler Dogruyu Soyledi',
        text:
            'Yerdeki kucuk tekerlek izleri Ela\'yi roket alaninin yanindaki servis perdesine goturur. Robot, gosteri sesinden urkup oraya gizlenmistir. Sinif rahat bir nefes alir.',
        imageAsset: 'asset/interactive/kayip_tac/bolum_3.png',
        isEnding: true,
      ),
    ],
  ),
];
