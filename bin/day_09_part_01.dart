void main(List<String> arguments) {
  final raw = input;
  final parts = raw.split('\n').toList();
  final rows = parts.length;
  final cols = parts[0].length;
  final heightmap = parts
      .expand((x) => x.split('').map((e) => int.parse(e)).toList())
      .toList();
  print(
    puzzle0901(heightmap, cols, rows),
  );
}

int puzzle0901(List<int> heightmap, int cols, int rows) {
  // 0 or heightmap[position] if lowPoint.
  int lowPoint(int position) {
    final height = heightmap[position];
    final col = position % cols;
    final row = position ~/ cols;
    bool isLowPoint = true;
    if (col > 0) {
      isLowPoint &= heightmap[position - 1] > height;
    }
    if (col < cols - 1) {
      isLowPoint &= heightmap[position + 1] > height;
    }
    if (row > 0) {
      isLowPoint &= heightmap[position - cols] > height;
    }
    if (row < rows - 1) {
      isLowPoint &= heightmap[position + cols] > height;
    }
    return isLowPoint ? height : -1;
  }

  int sum = 0;
  for (int i = 0; i < heightmap.length; i++) {
    final l = lowPoint(i);
    sum += l + 1;
  }

  return sum;
}

const defaultInput = '''2199943210
3987894921
9856789892
8767896789
9899965678''';

const input =
    '''5456898789432369879876542123489327657987856789656799875436567999109876543212345679832223569876567892
4345987678953459767989654345678916549876545689345987654323499878998765432101234599741012456997456901
3239876565694569653298797656989301234998659793239998789019988769889887643542345987632124669984345893
2198765464689698932129898987993212356799798910198999898998767456778998755643959876545234798763234689
1019874323494987891034999698954324467892987891987899987859654327867899876659898989876345679854347792
2198765654593276789126789569875455578921096999876789976749853213456899987999797899765467998765456991
3459899986789165679297895499986587689545985789995678985432969203456789698988676789876567899886969889
5567998999899234998989976989997688797659874568943467896541398912347991569976545679989699903999898778
7678987899988996897679989879898799899967965679732356789699987893456932498765432578998988912398769568
9789996989876789989567899967789912999899879789653458895987896954567893599984321367896567943987654456
8999895678965998765456789353678999898799989898767867964596545899678974679876210256789456894596543234
7898794567894899886567993232459887689689993919878978923985434678989865789987321347894345789987652105
6987689879923788997678994101269776594568942101989989014974323499299976896599496579943234894298753276
5699578989212567899789989213398667323489659232499998929865513389109987895456987689655346992129864587
4987457893103456799898678924989543214678998943459897898756101278998998967345998798766658989239765698
3986598954312345899986589899878994324567987894998776987543212367897999754259899969877769878999896789
2197679298429459999875456799765889435898976799879565498656434459986899865198782156989879767889987896
1098989197598998998964345987654768956789895989765454349867545578975789971019654345699989555978998945
9129798998987897987653239898743457899899784378964323234978958789564688932239865456999895434567899326
8935697899896786798761098765432345678987643265893210127989869894423567893349997569898789545678998434
7996976798795765679872569654321267789876432123799321256792978943213456794498789689787678956789976545
6789895987654343457983498784310456799984321012678934345694989532102457895987678997656567998999899756
5699754698543212356694569898751287898765754123569545456789996543212345999876529876543456789999788987
4987653987657101234569878997532345789887543234678956567893987665323456789985410989632346899987677898
3495432398763212367789989998643457895998954345889967788942198976534569899854321296541234599876476799
2986521019854323456794398998766568954569765676999878899959359988647999998765652987672456789434345688
9876532198765434767899987899887678999698989989899989967898967898756789899876543498787667894321234567
2987543459889549878998986989998989988987694496789995456987899999967898789987667569898878965210123678
1987674678997656989887665679129998767896543345678986369896798999878954679898977679939989877325235699
9998985889998767998766534568934987656789301234789995498765876789989543498769998998921098765434348789
8769996999999978999654323467899876545889212345689987899654765679997659569656989897932129987845468895
7752987899899989998785412567899986434678923676789999989543254598989798998749876766893234598876879924
6541098998789999899876523788999875423567894567899899878932123987978987987659875845789345699987989015
7432129997679878789987654899998765212878965678946789967891039876769896598767953234578998789598993196
6569239876569767678998765998789984324989976789434599858992129765456797429879865347679789893459654989
7698999988498754567899876789689765534567897895324978745789298954345689310989875498789678942578969878
8987689987329865678945987894578987645789998974219864636678987643254569421399989569896567931345998767
9876577895439876789236798943467898789898679765398743124567896532143478932398998678932459892459897656
8975456989545989894345989432778999896976569876789654578978998643012389987567899789421346789598796545
7432375678967899989459876544699987975653456998999875679699397652134567898878959894210234789989679434
5321434567898999678978987898789876544332387899998986989543298764365689999999349954342345679876568925
4310125678979998567899398999898965432101298934987987897659109896478998989991298765453456798765467899
5423456789369876456789459996987896544312349549855598989798912987567987678989359886567689998654325678
6554967895459987345996567985456789655425459659643459678987899998878996568678967987878998998763214589
7667898979598798236789999875345678966566598998786596567986567899989987434568978998989987987654323478
8978959768987654357899877764234999987987987659897789479875456789999876545678989799999876798765434567
9989543657998765698998765610123889998999989543999892398754325698965987657899694678998765659876545978
2399432648999987789999854321294678989910975432398901249987434567894598769998543567899954343997676789
3468921237899999999989865532989789876799864321297899359876545778923459878987655679999893232498788998
4578910345678987899879876649879998765698765410346778968987686899219678989998789789998789101349899567
5678923456799896799767998798967899854569877621234567899498789964398989795999899898987678916467923456
7899544567998765678946789997658899963567998799345678994329999879987897654789989987853567897878910197
8987656978987654589897999986545789892489109998966899989910123998786789795678978986432456998989421989
9899869899876543476789998765434576789567919887899919879891944987675678989789869864321237899996539878
7799998767987652335578997654312345997679998766998909768799895976554564578998756979410376779987898765
6678987654598921012469459654204456789798999854567998754656789865432123569987641988321234567899999654
4569876432987652133578998765345567999987899968798999643245689765431012498999820987434356789998789763
3456998521299643248689979876789878999876999989899899532124578977542127697898731976546769899987678932
2478987654398794359799865987896989999985898992945798743012367898953234986987652988656789949876568921
3989998785459895469898654598994399989654767891234987654123456999874349875498767898769899234998459420
4998899899578987567997732339789239879953356899345698765674587895976659943239978919878998946987569531
9876789988999997678986510125679198767892245978956999878765678964987898754345989324989997897898678932
8765679876789998799876421234598987656790134567999899989899789943298979896556798735698786789999989543
9654349865459899892987532345987898545989235678989789994929897892109467987687899645798654679899897654
6543299764376789901297654459876789539878997889775698943210946789212389998798998789986543498789789765
7759987853235678992998968598765798798769889997654587894321234994345678999899899898993212999655678976
9898796542124567989899987679876899987658678998523456789532375695456899999956789956989399898534569989
3998654321012679976789998789998999876546567895412378998943456789567989989645689349878989767623459990
2109765442123798865678999892399799943232456789323459987656567897689878976534597959969879654312598921
3299898765434987654587897921987689982101345895434878998767698998798967894325656798754569776454987892
9989999876546898743456986549896549876542659986545999999898789239997856989212345679653478987579876789
7878998989656999842345898698765434987953468999656989899979899949876745678902356798742389898989865678
6867897698767898543476789999876323499866579998999776789954979899964634569895457972101296789998754349
5756986549878987654579895899995439989878689987987654579793459798763123456789569863212345678989643234
4545698756999598765689954678996998878989799876598432345689598697654234767999997654323456899875432123
3234898767892349896896543456789887867899895987689551234578987539876345689109879765437567897988743234
2125899898921234998954312479898766456789954698798762345689299429987456795398769897656898956797654365
4335789989210123679869401289987654347896543479899874456792198998998878976498654998798999345698785466
6545999878921234598998912378999865456897532567934985677999096887899989998987543239899893201349896587
7657899867892365997887893456901977567976544878929996788998985456989999989998764347976789313499999698
9978987654999469875456789679892988878987656989998769899987675345678929879998765456975678929989598789
9899999769898998764365678998789899989398767899987656945976544156789219767899877567894569998765429899
8789879898767987653234567897656789999209879998976545434965432014568998956789989698943478919896434989
7698965999859876542123456912345678997923989987987632129876943223457897545992198789212367909998565679
4567897898645987643934967909659899986799999896898921034989874434567895439891019894101457898679686789
3478999987535798759899899898778965675678999785769892345698765678978999321793998943212456899598787895
4569998796421869898776789799889873234569898643456789456789876789989998210689897654563478997689998934
5678999654320345987655697689991982123698765432145678967894997899997896532456789876674568998798769323
9889698764321239876543789569892993434789898543234567898943498989876987543597999987986978949899953213
9996549895832349765432323456789876545699987654545678949232349679965498657679898798998989756999894901
9765434998743456979521014678899999656789898765656789432101234567894329768789789659679999867999789892
9879429899654567988734123489998978969897679896787896543212345689954219878997689943598999878989676789
3998997698775678999645235678967867978910567987998997654324466799763206989214567892397989989879535597
4987989459986789999856946789456456989423459998989789765436597898954345994302356789986878998965423456
9876564345697899898767857893212347899994578989875689976598678977896459875313767898765657987654312467
9986321234598998769878978976323456789789699876783788987899799656789967984325679999654548998743201345
8765432347899029655989989765434568994678987655312567898919896545789898998434899998653234987654312345
9987643456789197434699993987685678923467898742101348959102989434676789987645799876542123499875534456
5498954567999986512567892498796989312356999863212459543219878920145678999857899987621012345989845568
4329868678999865423456789579897893201767899974346567954334965431234568912967999876542123456798756879''';
